From: Josef Bacik <josef@redhat.com>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Mon, 18 Jul 2011 14:17:21 -0400
Message-ID: <4E2478B1.60601@redhat.com>
References: <BANLkTimMv_MMVmsJeVvr_1_wEVam1WZ6BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Nirbheek Chauhan <nirbheek@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTimMv_MMVmsJeVvr_1_wEVam1WZ6BA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/06/2011 06:58 PM, Nirbheek Chauhan wrote:
> Hello list,
> 
> I've been using btrfs on my personal machines for about two years now,
> and on this machine for about a year with absolutely no problems.
> Infact, it has held up better than ext4 with regards to reliability.
> 
> However, recently, perhaps with 2.6.39, or after I quickly started
> filling up my disk again, it has become impossible for me to work for
> long periods on my machine.
> 
> Every few minutes, (I guess) when applications do fsync (firefox,
> xchat, vim, etc), all applications that use fsync() hang for several
> seconds, and applications that use general IO suffer extreme
> slowdowns. iotop shows various combinations of the processes listed
> below doing writes, and the total write as 2-3MB/s.
> 
> [btrfs-dealloc-]
> [btrfs-submit-0]
> [btrfs-transacti]
> [btrfs-endio-wri]
> [flush-btrfs-1]
> 
> In some extreme cases, I've had hangs for 5 whole minutes. I'm really
> beginning to appreciate how little I/O GNOME Shell does since it
> remains completely responsive throughout this. I have a feeling that
> the cause for this is extreme fragmentation.
> 
> My hard disk is a 500GB SATA hdd, my btrfs partition details are:
> 
> # btrfs filesystem show
> Label: 'gentoo'  uuid: 6f539d7f-f70f-4216-a4a9-6f7a2117a04a
> 	Total devices 1 FS bytes used 246.37GB
> 	devid    1 size 345.13GB used 345.13GB path /dev/sda7
> 
> Btrfs v0.19-35-g1b444cd-dirty
> 
> What can I do to debug this issue? What other information should I
> supply? Could someone guide me on how to figure out why my machine is
> unusable now?
> 
> Thanks in advance,
> 

Hello,

I've been looking into this and I have a suspicion.  Would you run with this
patch and see if the problem goes away?  If so I'm on the right track
and I'll
have more test patches for you to try :).  Thanks,

Josef

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 19450bc..2e30350 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -150,7 +150,6 @@ static noinline int run_scheduled_bios(struct
btrfs_device *device)
 	 * another device without first sending all of these down.
 	 * So, setup a plug here and finish it off before we return
 	 */
-	blk_start_plug(&plug);

 	bdi = blk_get_backing_dev_info(device->bdev);
 	fs_info = device->dev_root->fs_info;
@@ -290,7 +289,6 @@ loop_lock:
 	spin_unlock(&device->io_lock);

 done:
-	blk_finish_plug(&plug);
 	return 0;
 }

