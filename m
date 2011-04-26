From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs plugging
Date: Tue, 26 Apr 2011 09:52:16 -0400
Message-ID: <1303825489-sup-1263@think>
Content-Type: text/plain; charset=UTF-8
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"Linux Btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The for-linus branch of the btrfs unstable tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

Has a single commit for the btrfs bio submission worker threads.  These
gather up IOs when the checksumming or compression threads are done with
the CPU intensive work.  Since the submission threads go one device at a
time, they want to unplug after finishing off all the bios for one
device.

Jens ripped this code out when he did the plugging work, I had promised
to redo it in the new framework.

Instead of the normal shortlog:

commit 211588ad1902df57beeeadc9b44546540fa4bd81
Author: Chris Mason <chris.mason@oracle.com>
Date:   Tue Apr 19 20:12:40 2011 -0400

    Btrfs: do some plugging in the submit_bio threads
    
    The Btrfs submit bio threads have a small number of
    threads responsible for pushing down bios we've collected
    for a large number of devices.
    
    Since we do all the bios for a single device at once,
    we want to make sure we unplug and send down the bios
    for each device as we're done processing them.
    
    The new plugging API removed the btrfs code to
    unplug while processing bios, this adds it back with
    the new API.
    
    Signed-off-by: Chris Mason <chris.mason@oracle.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 309a57b..c7367ae 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -155,6 +155,15 @@ static noinline int run_scheduled_bios(struct btrfs_device *device)
 	unsigned long limit;
 	unsigned long last_waited = 0;
 	int force_reg = 0;
+	struct blk_plug plug;
+
+	/*
+	 * this function runs all the bios we've collected for
+	 * a particular device.  We don't want to wander off to
+	 * another device without first sending all of these down.
+	 * So, setup a plug here and finish it off before we return
+	 */
+	blk_start_plug(&plug);
 
 	bdi = blk_get_backing_dev_info(device->bdev);
 	fs_info = device->dev_root->fs_info;
@@ -294,6 +303,7 @@ loop_lock:
 	spin_unlock(&device->io_lock);
 
 done:
+	blk_finish_plug(&plug);
 	return 0;
 }
 
