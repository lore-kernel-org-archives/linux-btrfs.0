From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
Date: Mon, 12 Mar 2012 15:21:49 +0100
Message-ID: <CADDYkjRkmqbKQnGL+VGgS2hi6F4Z7PbLb6dUB2PYd0M9pVSmPg@mail.gmail.com>
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
	<20120308155211.GF4334@twin.jikos.cz>
	<CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com>
	<4F595D6D.6080809@cn.fujitsu.com>
	<20120309105537.GG4334@twin.jikos.cz>
	<CADDYkjRcRbxxPErdMBOs55-gNHZA0GfxcsWNrVbAuv37b3rtvw@mail.gmail.com>
	<20120309114010.GH4334@twin.jikos.cz>
	<CADDYkjTsDf0J0v7B-78SiYPsjPsn1VOCbiqAMq8TJxgPc_MiBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, Jacek Luczak <difrost.kernel@gmail.com>,
	Liu Bo <liubo2009@cn.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, josef@redhat.com,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADDYkjTsDf0J0v7B-78SiYPsjPsn1VOCbiqAMq8TJxgPc_MiBg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2012/3/10 Jacek Luczak <difrost.kernel@gmail.com>:
> 2012/3/9 David Sterba <dave@jikos.cz>:
>> On Fri, Mar 09, 2012 at 12:08:12PM +0100, Jacek Luczak wrote:
>>> For this one I've created also a report [1].
>>> >
>>> > so there is probably other problem in reservations and it just bl=
ew up during
>>> > the unlink call.
>>>
>>> Could be as this came up after a longer time of throwing above WARN=
_ON.
>>>
>>> I'm now cloning the Linus tree. Lets see if both will pop up on the=
re.
>>
>> The 3.3-rc6 should help in one case, with
>>
>> http://thread.gmane.org/gmane.comp.file-systems.btrfs/15268
>>
>> but I was able to reproduce the WARN_ON even with this patch, didn't=
 get
>> to debugging it again yet.
>>
>
>
> The story so far looks like this:
> 1) kernel 3.2.7:
> - on the BUG_ON triggers after a longer while of CI env (doing builds=
)
> running. This has been already reproduced twice.
> - WARN_ON spams heavily, even after BUG_ON pop up.
> - possible relation between WARN_ON and BUG_ON.

WARN_ON still popup in 3.3.0-rc6-00197-g9f8050c but did not triggered
BUG_ON after ~300 occurrence.

> 2) A *regression* in 3.3.0-rc6-00197-g9f8050c
> - completely unusable as reports ENOSPC
> - to reproduce, mount volume and issue:
> # CNT=3D1 ; while [ $CNT -lt 10000 ] ; do =A0rm -f /btrfs/dd ; ! touc=
h
> /btrfs/dd && echo "$CNT" && break =A0; CNT=3D$(( $CNT + 1 )) ; done
> On my host this shows:
> # CNT=3D1 ; while [ $CNT -lt 10000 ] ; do =A0rm -f /btrfs/dd ; ! touc=
h
> /btrfs/dd && echo "$CNT" && break =A0; CNT=3D$(( $CNT + 1 )) ; done
> touch: cannot touch `/btrfs/dd': No space left on device
> 423
> - remount to reset:
> # CNT=3D1 ; while [ $CNT -lt 10000 ] ; do =A0rm -f /btrfs/dd ; ! touc=
h
> /btrfs/dd && echo "$CNT" && break =A0; CNT=3D$(( $CNT + 1 )) ; done
> touch: cannot touch `/btrfs/dd': No space left on device
> 1
> # umount /btrfs/
> # mount -t btrfs /dev/vg00/btrfs /btrfs/ -o noatime,nodatacow,default=
s
> # CNT=3D1 ; while [ $CNT -lt 10000 ] ; do =A0rm -f /btrfs/dd ; ! touc=
h
> /vdd && echo "$CNT" && break =A0; CNT=3D$(( $CNT + 1 )) ; done
> touch: cannot touch `/btrfs/dd': No space left on device
> 423
> - bisected down to 5500cdb (Btrfs: increase the global block reserve
> estimates). After reverting this one Linus master works for me again.

With above patch reverted after a longer run I've got ENOSPC again:
1) # df -hP /btrfs
=46ilesystem            Size  Used Avail Use% Mounted on
/dev/mapper/vg00-btrfs  195G  179G   11G  95% /btrfs
2) # rm -f /btrfs/dd
rm: cannot remove `/btrfs/dd': No space left on device
3) strace
unlink("/btrfs/dd")                =3D -1 ENOSPC (No space left on devi=
ce)
4) last message from kernel (except WARN_ONs):
btrfs: fail to dirty inode 116882385 error -28

I've remouted volume and after that I've been able to remove dd file
from volume. In dmesg there's bunch on new WARN_ONs:
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:4185
btrfs_free_block_groups+0x17d/0x2b8 [btrfs]()
Hardware name: ProLiant BL460c G6
Modules linked in: btrfs zlib_deflate lzo_compress ipmi_devintf
autofs4 be2iscsi iscsi_boot_sysfs ib_iser rdma_cm ib_cm iw_cm ib_sa
ib_mad ib_addr iscsi_tcp bnx2i cnic uio ipv6 cxgb3i libcxgbi iw_cxgb3
ib_core cxgb3 libiscsi_tcp libiscsi scsi_transport_iscsi dm_mirror
dm_region_hash dm_log dm_multipath video battery acpi_pad acpi_ipmi ac
parport usbhid evdev acpi_power_meter radeon ttm drm_kms_helper drm
hwmon ipmi_si bnx2x backlight i2c_algo_bit ipmi_msghandler i2c_core
hpilo mdio hpwdt psmouse uhci_hcd ehci_hcd
Pid: 9518, comm: umount Tainted: G        W    3.3.0-rc6-00197-g9f8050c=
-dirty #1
Call Trace:
 [<ffffffff8105caca>] ? print_oops_end_marker+0x9/0x20
 [<ffffffffa031a8a7>] ? btrfs_free_block_groups+0x17d/0x2b8 [btrfs]
 [<ffffffff8105cc92>] ? warn_slowpath_common+0x78/0x8d
 [<ffffffffa031a8a7>] ? btrfs_free_block_groups+0x17d/0x2b8 [btrfs]
 [<ffffffffa0327473>] ? close_ctree+0x1e1/0x380 [btrfs]
 [<ffffffff811320c2>] ? dispose_list+0x27/0x31
 [<ffffffff8113248c>] ? evict_inodes+0xc5/0xcc
 [<ffffffff8112098c>] ? generic_shutdown_super+0x4d/0xc1
 [<ffffffff81120a67>] ? kill_anon_super+0x9/0x11
 [<ffffffffa030a3aa>] ? btrfs_kill_super+0xd/0x73 [btrfs]
 [<ffffffff81120c81>] ? deactivate_locked_super+0x2f/0x5f
 [<ffffffff81135d5f>] ? sys_umount+0x2c1/0x30b
 [<ffffffff813ef0f9>] ? system_call_fastpath+0x16/0x1b
---[ end trace fd6da849e53b77dd ]---
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:4186
btrfs_free_block_groups+0x198/0x2b8 [btrfs]()
Hardware name: ProLiant BL460c G6
Modules linked in: btrfs zlib_deflate lzo_compress ipmi_devintf
autofs4 be2iscsi iscsi_boot_sysfs ib_iser rdma_cm ib_cm iw_cm ib_sa
ib_mad ib_addr iscsi_tcp bnx2i cnic uio ipv6 cxgb3i libcxgbi iw_cxgb3
ib_core cxgb3 libiscsi_tcp libiscsi scsi_transport_iscsi dm_mirror
dm_region_hash dm_log dm_multipath video battery acpi_pad acpi_ipmi ac
parport usbhid evdev acpi_power_meter radeon ttm drm_kms_helper drm
hwmon ipmi_si bnx2x backlight i2c_algo_bit ipmi_msghandler i2c_core
hpilo mdio hpwdt psmouse uhci_hcd ehci_hcd
Pid: 9518, comm: umount Tainted: G        W    3.3.0-rc6-00197-g9f8050c=
-dirty #1
Call Trace:
 [<ffffffff8105caca>] ? print_oops_end_marker+0x9/0x20
 [<ffffffffa031a8c2>] ? btrfs_free_block_groups+0x198/0x2b8 [btrfs]
 [<ffffffff8105cc92>] ? warn_slowpath_common+0x78/0x8d
 [<ffffffffa031a8c2>] ? btrfs_free_block_groups+0x198/0x2b8 [btrfs]
 [<ffffffffa0327473>] ? close_ctree+0x1e1/0x380 [btrfs]
 [<ffffffff811320c2>] ? dispose_list+0x27/0x31
 [<ffffffff8113248c>] ? evict_inodes+0xc5/0xcc
 [<ffffffff8112098c>] ? generic_shutdown_super+0x4d/0xc1
 [<ffffffff81120a67>] ? kill_anon_super+0x9/0x11
 [<ffffffffa030a3aa>] ? btrfs_kill_super+0xd/0x73 [btrfs]
 [<ffffffff81120c81>] ? deactivate_locked_super+0x2f/0x5f
 [<ffffffff81135d5f>] ? sys_umount+0x2c1/0x30b
 [<ffffffff813ef0f9>] ? system_call_fastpath+0x16/0x1b
---[ end trace fd6da849e53b77de ]---
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:4187
btrfs_free_block_groups+0x1b3/0x2b8 [btrfs]()
Hardware name: ProLiant BL460c G6
Modules linked in: btrfs zlib_deflate lzo_compress ipmi_devintf
autofs4 be2iscsi iscsi_boot_sysfs ib_iser rdma_cm ib_cm iw_cm ib_sa
ib_mad ib_addr iscsi_tcp bnx2i cnic uio ipv6 cxgb3i libcxgbi iw_cxgb3
ib_core cxgb3 libiscsi_tcp libiscsi scsi_transport_iscsi dm_mirror
dm_region_hash dm_log dm_multipath video battery acpi_pad acpi_ipmi ac
parport usbhid evdev acpi_power_meter radeon ttm drm_kms_helper drm
hwmon ipmi_si bnx2x backlight i2c_algo_bit ipmi_msghandler i2c_core
hpilo mdio hpwdt psmouse uhci_hcd ehci_hcd
Pid: 9518, comm: umount Tainted: G        W    3.3.0-rc6-00197-g9f8050c=
-dirty #1
Call Trace:
 [<ffffffff8105caca>] ? print_oops_end_marker+0x9/0x20
 [<ffffffffa031a8dd>] ? btrfs_free_block_groups+0x1b3/0x2b8 [btrfs]
 [<ffffffff8105cc92>] ? warn_slowpath_common+0x78/0x8d
 [<ffffffffa031a8dd>] ? btrfs_free_block_groups+0x1b3/0x2b8 [btrfs]
 [<ffffffffa0327473>] ? close_ctree+0x1e1/0x380 [btrfs]
 [<ffffffff811320c2>] ? dispose_list+0x27/0x31
 [<ffffffff8113248c>] ? evict_inodes+0xc5/0xcc
 [<ffffffff8112098c>] ? generic_shutdown_super+0x4d/0xc1
 [<ffffffff81120a67>] ? kill_anon_super+0x9/0x11
 [<ffffffffa030a3aa>] ? btrfs_kill_super+0xd/0x73 [btrfs]
 [<ffffffff81120c81>] ? deactivate_locked_super+0x2f/0x5f
 [<ffffffff81135d5f>] ? sys_umount+0x2c1/0x30b
 [<ffffffff813ef0f9>] ? system_call_fastpath+0x16/0x1b
---[ end trace fd6da849e53b77df ]---
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:7454
btrfs_free_block_groups+0x256/0x2b8 [btrfs]()
Hardware name: ProLiant BL460c G6
Modules linked in: btrfs zlib_deflate lzo_compress ipmi_devintf
autofs4 be2iscsi iscsi_boot_sysfs ib_iser rdma_cm ib_cm iw_cm ib_sa
ib_mad ib_addr iscsi_tcp bnx2i cnic uio ipv6 cxgb3i libcxgbi iw_cxgb3
ib_core cxgb3 libiscsi_tcp libiscsi scsi_transport_iscsi dm_mirror
dm_region_hash dm_log dm_multipath video battery acpi_pad acpi_ipmi ac
parport usbhid evdev acpi_power_meter radeon ttm drm_kms_helper drm
hwmon ipmi_si bnx2x backlight i2c_algo_bit ipmi_msghandler i2c_core
hpilo mdio hpwdt psmouse uhci_hcd ehci_hcd
Pid: 9518, comm: umount Tainted: G        W    3.3.0-rc6-00197-g9f8050c=
-dirty #1
Call Trace:
 [<ffffffff8105caca>] ? print_oops_end_marker+0x9/0x20
 [<ffffffffa031a980>] ? btrfs_free_block_groups+0x256/0x2b8 [btrfs]
 [<ffffffff8105cc92>] ? warn_slowpath_common+0x78/0x8d
 [<ffffffffa031a980>] ? btrfs_free_block_groups+0x256/0x2b8 [btrfs]
 [<ffffffffa0327473>] ? close_ctree+0x1e1/0x380 [btrfs]
 [<ffffffff811320c2>] ? dispose_list+0x27/0x31
 [<ffffffff8113248c>] ? evict_inodes+0xc5/0xcc
 [<ffffffff8112098c>] ? generic_shutdown_super+0x4d/0xc1
 [<ffffffff81120a67>] ? kill_anon_super+0x9/0x11
 [<ffffffffa030a3aa>] ? btrfs_kill_super+0xd/0x73 [btrfs]
 [<ffffffff81120c81>] ? deactivate_locked_super+0x2f/0x5f
 [<ffffffff81135d5f>] ? sys_umount+0x2c1/0x30b
 [<ffffffff813ef0f9>] ? system_call_fastpath+0x16/0x1b
---[ end trace fd6da849e53b77e0 ]---
space_info 4 has 3043549184 free, is not full
space_info total=3D11953766400, used=3D8901763072, pinned=3D0, reserved=
=3D0,
may_use=3D121643008, readonly=3D8454144
device fsid b70500f5-3ec6-4a39-9b9a-adad0e8a0346 devid 1 transid 54268
/dev/vg00/btrfs
btrfs: setting nodatacow

-Jacek
