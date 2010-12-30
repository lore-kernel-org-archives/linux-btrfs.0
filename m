From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Reproducible kernel BUG while using VirtualBox:
Date: Thu, 30 Dec 2010 13:19:26 +0800
Message-ID: <4D1C165E.70208@cn.fujitsu.com>
References: <4D1BAD75.1060602@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Kenneth Lakin <kennethlakin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D1BAD75.1060602@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Kenneth Lakin wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> All,
> 
> I believe that I can pretty reliably reproduce the BUG mentioned in the
> attached dmesg output. (This doesn't mean that you can, but I'll detail
> what I've done here.) [This BUG is the same one that I reported last night.]
> 

Revert:

commit 914ee295af418e936ec20a08c1663eaabe4cd07a
Author: Xin Zhong <xin.zhong@intel.com>
Date:   Thu Dec 9 09:30:14 2010 +0000

    Btrfs: pwrite blocked when writing from the mmaped buffer of the same page

    This problem is found in meego testing:
    http://bugs.meego.com/show_bug.cgi?id=6672
    A file in btrfs is mmaped and the mmaped buffer is passed to pwrite to write
    of the same file. In btrfs_file_aio_write(), the pages is locked by prepare_
    btrfs_copy_from_user() is called, page fault happens and the same page needs
    in filemap_fault(). The fix is to move iov_iter_fault_in_readable() before p
    fault happen before pages are locked. And also disable page fault in critica
    btrfs_copy_from_user().

And see if the bug still exists?

> 1) Create a 2 GB dynamically expanding disk.
> 2) Attach it to a VirtualBox machine.
> 3) Start the Kubuntu install process.
> 4) Wait until the virtual disk grows to around ~850MB. (This happens
> when the install process is in the "installing packages" phase.)
> 5) Notice that that progress bar hasn't moved in a little while.
> 6) Record the BUG info from dmesg.
> 7) Wait around a little while more until the Kubuntu install mentions
> that it has encountered an error.
> 8) Reboot your physical machine to kill the VirtualBox instance that now
> won't shut down, but isn't actually using any CPU time. [Using xkill on
> this instance results in the zombie VirtualBox process that's stuck in
> IO-wait that I reported last night.]
> 
> Note that dd'ing 1GB of data to a file on disk (from /dev/zero or
> /dev/urandom) does not cause an error, so this doesn't seem to be a disk
> fullness thing.
> 
> More information about my machine:
> I once mounted the filesystem in question with the space_cache option.
> All free space numbers here are from *before* I dd'd 1GB of data onto disk.
> 
> $ btrfs fi df /
> Data: total=71.23GB, used=68.16GB
> System, DUP: total=8.00MB, used=24.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=4.75GB, used=2.26GB
> 
> $ df -h /
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/mapper/campstovevg-root
>                        81G   73G  3.4G  96% /
> $ mount | grep btrfs
> /dev/mapper/campstovevg-root on / type btrfs (rw,relatime,ssd)
> 
> $ uname -a
> Linux campstove 2.6.36+ #5 SMP PREEMPT Mon Dec 20 09:28:14 PST 2010 i686
> Intel(R) Core(TM) Duo CPU L2400 @ 1.66GHz GenuineIntel GNU/Linux
> 
> ~/btrfs-unstable $ git log -n1 | head -n3
> commit 83a50de97fe96aca82389e061862ed760ece2283
> Author: Chris Mason <chris.mason@oracle.com>
> Date:   Mon Dec 13 15:06:46 2010 -0500
> 
> ~/btrfs-progs-unstable $ git log -n1 | head -n3
> commit 1b444cd2e6ab8dcafdd47dbaeaae369dd1517c17
> Author: Chris Mason <chris.mason@oracle.com>
> Date:   Wed Oct 6 09:53:38 2010 -0400
> 
