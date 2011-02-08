From: Sage Weil <sage@newdream.net>
Subject: Re: WARNING: at fs/btrfs/inode.c:2143 btrfs_orphan_commit_root+0x7f/0x9b
Date: Tue, 8 Feb 2011 07:19:36 -0800 (PST)
Message-ID: <Pine.LNX.4.64.1102080716520.4825@cobra.newdream.net>
References: <20110204084808.GA3814@onthe.net.au> <1296830292.2408.0.camel@wido-desktop>
 <20110207062306.GB25062@onthe.net.au> <20110207063102.GD25062@onthe.net.au>
 <20110207073911.GB16034@onthe.net.au> <20110208073732.GA13060@onthe.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
To: Chris Dunlop <chris@onthe.net.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110208073732.GA13060@onthe.net.au>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On Tue, 8 Feb 2011, Chris Dunlop wrote:
> On Mon, Feb 07, 2011 at 06:39:11PM +1100, Chris Dunlop wrote:
> > On Mon, Feb 07, 2011 at 05:31:02PM +1100, Chris Dunlop wrote:
> >> G'day,
> >> 
> >> Using Josef's btrfs-work bacae123 (+ ceph-client 9aae8faf), I
> >> can consistently reproduce the following btrfs warning by simply
> >> creating and starting a new btrfs-based ceph file system:
> >> 
> >> [  549.767234] ------------[ cut here ]------------
> >> [  549.767276] WARNING: at fs/btrfs/inode.c:2143 btrfs_orphan_commit_root+0x7f/0x9b [btrfs]()
> > 
> > Sorry, just found I've been booting wrong kernel. I've been
> > seeing the warning *without* Josef's btrfs-work.  Will re-test
> > tomorrow.
> 
> OK, the line number has changed slightly, but still getting the
> same thing with:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Can you try to reproduce this with the following patch applied to the 
server side?  This will disable the async snapshot ioctl.  It doesn't look 
like it's related to me, but let's be sure.

Thanks!
sage


diff --git a/src/os/FileStore.cc b/src/os/FileStore.cc
index dc78451..d5530c5 100644
--- a/src/os/FileStore.cc
+++ b/src/os/FileStore.cc
@@ -865,7 +865,7 @@ int FileStore::_detect_fs()
       dout(0) << "mount btrfs SNAP_CREATE_V2 got " << r << " " << strerror_r(-r, buf, sizeof(buf)) << dendl;
       if (r == 0 || errno == EEXIST) {
        dout(0) << "mount btrfs SNAP_CREATE_V2 is supported" << dendl;
-       btrfs_snap_create_v2 = true;
+       //btrfs_snap_create_v2 = true;
       
        // clean up
        r = ::ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &vol_args);


> 
> commit cb5520f02c010e3cb974b9ac06f30aafa2eebc38
> Merge: eee4da2... 3a90983...
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon Feb 7 14:06:18 2011 -0800
> 
>     Merge git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable
> 
> 
> [ 129.524029] ------------[ cut here ]------------
> [ 129.524080] WARNING: at fs/btrfs/inode.c:2161 btrfs_orphan_commit_root+0x7f/0x9b [btrfs]()
> [ 129.524111] Hardware name: System Product Name
> [ 129.524140] Modules linked in: loop netconsole configfs dm_mod sd_mod i2c_piix4 k10temp i2c_core asus_atk0110 ata_generic ahci libahci libata scsi_mod shpchp button pci_hotplug processor nfs lockd nfs_acl auth_rpcgss sunrpc r8169 mii ohci_hcd ehci_hcd thermal fan thermal_sys btrfs zlib_deflate crc32c libcrc32c
> [ 129.525057] Pid: 10, comm: kworker/0:1 Tainted: G        W   2.6.38-rc3-otn1-00323-gc88f808 #5
> [ 129.525088] Call Trace:
> [ 129.525125]  [<ffffffffa003db51>] ? btrfs_orphan_commit_root+0x7f/0x9b [btrfs]
> [ 129.525158]  [<ffffffff81043a20>] ? warn_slowpath_common+0x78/0x8d
> [ 129.525195]  [<ffffffffa003db51>] ? btrfs_orphan_commit_root+0x7f/0x9b [btrfs]
> [ 129.525232]  [<ffffffffa0033729>] ? commit_fs_roots+0x87/0xef [btrfs]
> [ 129.525268]  [<ffffffffa00343a2>] ? btrfs_commit_transaction+0x348/0x615 [btrfs]
> [ 129.525300]  [<ffffffff8105d14a>] ? autoremove_wake_function+0x0/0x2e
> [ 129.525336]  [<ffffffffa00c8e49>] ? call_transmit+0x214/0x24f [sunrpc]
> [ 129.525372]  [<ffffffffa0034681>] ? do_async_commit+0x12/0x1b [btrfs]
> [ 129.525400]  [<ffffffff81057df4>] ? process_one_work+0x22c/0x3a5
> [ 129.525437]  [<ffffffffa003466f>] ? do_async_commit+0x0/0x1b [btrfs]
> [ 129.525465]  [<ffffffff810582c0>] ? worker_thread+0x1d5/0x353
> [ 129.525495]  [<ffffffff810580eb>] ? worker_thread+0x0/0x353
> [ 129.525526]  [<ffffffff8105cd08>] ? kthread+0x7e/0x86
> [ 129.525557]  [<ffffffff8100a764>] ? kernel_thread_helper+0x4/0x10
> [ 129.525588]  [<ffffffff8105cc8a>] ? kthread+0x0/0x86
> [ 129.525617]  [<ffffffff8100a760>] ? kernel_thread_helper+0x0/0x10
> [ 129.525649] ---[ end trace deccd3c0dec6c2ba ]---
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
