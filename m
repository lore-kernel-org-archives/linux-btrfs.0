From: Chris Mason <chris.mason@oracle.com>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:305
Date: Thu, 3 Nov 2011 07:19:27 -0400
Message-ID: <20111103111927.GJ18900@shiny>
References: <4EB1ED83.8010301@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EB1ED83.8010301@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 03, 2011 at 10:25:23AM +0900, Tsutomu Itoh wrote:
> In integration-scrub branch, following warning messages were displayed by
> running xfstests.
> 
> # btrfs fi sh /dev/sdd4
> Label: none  uuid: 8f28d85c-e37c-4c1b-adef-2627ca59be78
>         Total devices 2 FS bytes used 31.49MB
>         devid    1 size 9.31GB used 9.31GB path /dev/sdd4
>         devid    2 size 15.01GB used 9.29GB path /dev/sdc1
> 
> Btrfs Btrfs v0.19
> # mount
> ...
> /dev/sdd4 on /test7 type btrfs (rw,compress=lzo)
> #
> 
> Thanks,
> Tsutomu
> 
> ====================================================================================
> 
> Nov  3 09:55:18 luna kernel: [  939.732044] device fsid 8f28d85c-e37c-4c1b-adef-2627ca59be78 devid 1 transid 20510 /dev/sdd4
> Nov  3 09:55:18 luna kernel: [  939.732533] btrfs: use lzo compression
> Nov  3 09:55:18 luna kernel: [  939.732536] btrfs: disk space caching is enabled
> Nov  3 09:55:18 luna kernel: [  939.898190] ------------[ cut here ]------------
> Nov  3 09:55:18 luna kernel: [  939.898223] WARNING: at fs/btrfs/free-space-cache.c:305 io_ctl_map_page+0x29/0x76 [btrfs]()
> Nov  3 09:55:18 luna kernel: [  939.898227] Hardware name: PRIMERGY
> Nov  3 09:55:18 luna kernel: [  939.898229] Modules linked in: btrfs zlib_deflate crc32c libcrc32c nfsd lockd nfs_acl auth_rpcgss autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf cachefiles fscache ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif megaraid_sas sr_mod cdrom floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
> Nov  3 09:55:18 luna kernel: [  939.898291] Pid: 13337, comm: dd Not tainted 3.1.0integ-sc+ #1
> Nov  3 09:55:18 luna kernel: [  939.898294] Call Trace:
> Nov  3 09:55:18 luna kernel: [  939.898303]  [<ffffffff8104b6fe>] warn_slowpath_common+0x85/0x9d
> Nov  3 09:55:18 luna kernel: [  939.898308]  [<ffffffff8104b730>] warn_slowpath_null+0x1a/0x1c
> Nov  3 09:55:18 luna kernel: [  939.898328]  [<ffffffffa0477507>] io_ctl_map_page+0x29/0x76 [btrfs]
> Nov  3 09:55:18 luna kernel: [  939.898349]  [<ffffffffa0477733>] io_ctl_check_crc+0x62/0xdd [btrfs]

Looks like io_ctl_read_bitmap will call io_ctl_check_crc with a mapped
page mapped.  Any chance you're able to reproduce this?

-chris

