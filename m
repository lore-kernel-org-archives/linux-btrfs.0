From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: WARNING: at fs/btrfs/inode.c:2143
 btrfs_orphan_commit_root+0x7f/0x9b
Date: Wed, 9 Feb 2011 14:58:55 +1100
Message-ID: <20110209035855.GA32598@onthe.net.au>
References: <20110204084808.GA3814@onthe.net.au>
 <1296830292.2408.0.camel@wido-desktop>
 <20110207062306.GB25062@onthe.net.au>
 <20110207063102.GD25062@onthe.net.au>
 <20110207073911.GB16034@onthe.net.au>
 <20110208073732.GA13060@onthe.net.au>
 <Pine.LNX.4.64.1102080716520.4825@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1102080716520.4825@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 08, 2011 at 07:19:36AM -0800, Sage Weil wrote:
> On Tue, 8 Feb 2011, Chris Dunlop wrote:
>> On Mon, Feb 07, 2011 at 06:39:11PM +1100, Chris Dunlop wrote:
>>> On Mon, Feb 07, 2011 at 05:31:02PM +1100, Chris Dunlop wrote:
>>>> 
>>>> [  549.767234] ------------[ cut here ]------------
>>>> [  549.767276] WARNING: at fs/btrfs/inode.c:2143 btrfs_orphan_commit_root+0x7f/0x9b [btrfs]()
>> 
>> OK, the line number has changed slightly, but still getting the
>> same thing with:
>> 
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> Can you try to reproduce this with the following patch applied to the 
> server side?  This will disable the async snapshot ioctl.  It doesn't look 
> like it's related to me, but let's be sure.
> 
> diff --git a/src/os/FileStore.cc b/src/os/FileStore.cc
> index dc78451..d5530c5 100644
> --- a/src/os/FileStore.cc
> +++ b/src/os/FileStore.cc
> @@ -865,7 +865,7 @@ int FileStore::_detect_fs()
>        dout(0) << "mount btrfs SNAP_CREATE_V2 got " << r << " " << strerror_r(-r, buf, sizeof(buf)) << dendl;
>        if (r == 0 || errno == EEXIST) {
>         dout(0) << "mount btrfs SNAP_CREATE_V2 is supported" << dendl;
> -       btrfs_snap_create_v2 = true;
> +       //btrfs_snap_create_v2 = true;
>        
>         // clean up
>         r = ::ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &vol_args);

The patch (applied to ceph.git 778902b, with changed line
numbers) didn't help, same warning message:

[73382.202774] ------------[ cut here ]------------
[73382.202811] WARNING: at fs/btrfs/inode.c:2161 btrfs_orphan_commit_root+0x7f/0x9b [btrfs]()
[73382.202820] Hardware name: System Product Name
[73382.202827] Modules linked in: loop netconsole configfs dm_mod sd_mod i2c_piix4 k10temp i2c_core asus_atk0110 ata_generic ahci libahci libata scsi_mod shpchp button pci_hotplug processor nfs lockd nfs_acl auth_rpcgss sunrpc r8169 mii ohci_hcd ehci_hcd thermal fan thermal_sys btrfs zlib_deflate crc32c libcrc32c
[73382.202936] Pid: 7092, comm: cosd Tainted: G        W   2.6.38-rc3-otn1-00323-gc88f808 #5
[73382.202945] Call Trace:
[73382.202960]  [<ffffffffa003db51>] ? btrfs_orphan_commit_root+0x7f/0x9b [btrfs]
[73382.202971]  [<ffffffff81043a20>] ? warn_slowpath_common+0x78/0x8d
[73382.202985]  [<ffffffffa003db51>] ? btrfs_orphan_commit_root+0x7f/0x9b [btrfs]
[73382.203001]  [<ffffffffa0033729>] ? commit_fs_roots+0x87/0xef [btrfs]
[73382.203015]  [<ffffffffa00343a2>] ? btrfs_commit_transaction+0x348/0x615 [btrfs]
[73382.203026]  [<ffffffff8105d14a>] ? autoremove_wake_function+0x0/0x2e
[73382.203038]  [<ffffffffa002073d>] ? block_rsv_add_bytes+0x15/0x3c [btrfs]
[73382.203052]  [<ffffffffa0059520>] ? btrfs_mksubvol+0x1f4/0x308 [btrfs]
[73382.203065]  [<ffffffffa0059732>] ? btrfs_ioctl_snap_create_transid+0xfe/0x11d [btrfs]
[73382.203080]  [<ffffffffa0059856>] ? btrfs_ioctl_snap_create+0x49/0x5e [btrfs]
[73382.203094]  [<ffffffffa005c36f>] ? btrfs_ioctl+0x471/0x90a [btrfs]
[73382.203102]  [<ffffffff81114e79>] ? fsnotify+0x255/0x279
[73382.203110]  [<ffffffff8100a36e>] ? invalidate_interrupt1+0xe/0x20
[73382.203119]  [<ffffffff810f7e2a>] ? do_vfs_ioctl+0x40c/0x453
[73382.203126]  [<ffffffff810f7eae>] ? sys_ioctl+0x3d/0x5c
[73382.203134]  [<ffffffff81009952>] ? system_call_fastpath+0x16/0x1b
[73382.203142] ---[ end trace deccd3c0dec6c2bd ]---
