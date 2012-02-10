From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mkfs: Handle creation of filesystem larger than the
 first device
Date: Fri, 10 Feb 2012 11:49:19 +0100
Message-ID: <20120210104919.GE10509@quack.suse.cz>
References: <1327593785-23466-1-git-send-email-jack@suse.cz>
 <4F32F0AB.8030003@ubuntu.com>
 <20120208232015.GE1696@quack.suse.cz>
 <4F3337F6.7010900@ubuntu.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Cc: Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.cz>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F3337F6.7010900@ubuntu.com>
List-ID: <linux-btrfs.vger.kernel.org>


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 08-02-12 22:05:26, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 02/08/2012 06:20 PM, Jan Kara wrote:
> >   Thanks for your reply. I admit I was not sure what exactly size argument
> > should be. So after looking into the code for a while I figured it should
> > be a total size of the filesystem - or differently it should be size of
> > virtual block address space in the filesystem. Thus when filesystem has
> > more devices (or admin wants to add more devices later), it can be larger
> > than the first device. But I'm not really a btrfs developper so I might be
> > wrong and of course feel free to fix the issue as you deem fit.
> 
> The size of the fs is the total size of the individual disks.  When you
> limit the size, you limit the size of a disk, not the whole fs.  IIRC,
> mkfs initializes the fs on the first disk, which is why it was using that
> size as the size of the whole fs, and then adds the other disks after (
> which then add their size to the total fs size ).
  OK, I missed that btrfs_add_to_fsid() increases total size of the
filesystem. So now I agree with you. New patch is attached. Thanks for your
review.

> It might be nice if
> mkfs could take sizes for each disk, but it only seems to take one size
> for the initial disk.
  Yes, but I don't see a realistic usecase so I don't think it's really
worth the work.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--k1lZvvs/B4yU6o8G
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-mkfs-Handle-creation-of-filesystem-larger-than-the-f.patch"

>From e5f46872232520310c56327593c02ef6a7f5ea33 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 10 Feb 2012 11:44:44 +0100
Subject: [PATCH] mkfs: Handle creation of filesystem larger than the first device

mkfs does not properly check requested size of the filesystem. Thus if the
requested size is larger than the first device, it happily creates larger
filesystem than a device it resides on which results in 'attemp to access
beyond end of device' messages from the kernel. So verify specified filesystem
size against the size of the first device.

CC: David Sterba <dsterba@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mkfs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index e3ced19..3afe9eb 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1282,6 +1282,10 @@ int main(int ac, char **av)
 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count, &mixed);
 		if (block_count == 0)
 			block_count = dev_block_count;
+		else if (block_count > dev_block_count) {
+			fprintf(stderr, "%s is smaller than requested size\n", file);
+			exit(1);
+		}
 	} else {
 		ac = 0;
 		file = av[optind++];
-- 
1.7.1


--k1lZvvs/B4yU6o8G--
