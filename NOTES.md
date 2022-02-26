
> (!) These are just notes and not polished or intented as *ready-to-use*.

# Setup notes

* Download and extract the *OpenWRT ImageBuilder*
* Prepare *OpenWRT* config, see `./files`
* Build an *image* with `openwrt-imagebuilder-21.02.1-x86-64.Linux-x86_64`, see `./make.sh`
* `gunzip ./bin/targets/x86/64/openwrt-21.02.1-x86-64-generic-ext4-combined.img.gz`
* Prepare *Openstack*

```
openstack image create \
	--disk-format raw \
	--min-disk 1 \
	--min-ram 1 \
	--file ./bin/targets/x86/64/openwrt-21.02.1-x86-64-generic-ext4-combined.img \
	--progress \
	--private \
	"openwrt-21.02.1-x86-64-generic-ext4-combined-custom.img"

openstack network create --disable-port-security "openwrt"

openstack subnet create \
	--ip-version 6 \
	--ipv6-ra-mode slaac \
	--ipv6-address-mode slaac \
	--subnet-pool "ipv6_tenant_pool" \
	--network "openwrt" \
	"openwrt-v6"

openstack router create "openwrt"
openstack router add subnet "openwrt" "openwrt-v6"

openstack server create \
	--flavor 2C-2GB \
	--image "openwrt-21.02.1-x86-64-generic-ext4-combined-custom.img" \
	--network "openwrt" \
	"openwrt"
```

* `/root/resize_part.sh` and `/root/resize_fs.sh` can be used to rewrite the partition table and extend `vda2` to its possible maximum, and resize the file-system according to it. \
  **Caution**: `/root/resize_fs.sh` performs `reboot` at the end!



# General notes
* [openwrt.org/docs/guide-user/installation/openwrt_x86#resizing_partitions](https://openwrt.org/docs/guide-user/installation/openwrt_x86#resizing_partitions)
* Google Public DNS IPv6: \
  2001:4860:4860::8888 \
  2001:4860:4860::8844
