From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Re: Don't prevent removal of devices that break raid reqs
Date: Sat, 19 Nov 2011 08:10:24 -0200
Message-ID: <oraa7s778v.fsf@livre.localdomain>
References: <orvcqrpycf.fsf@livre.localdomain> <20111111022100.GD4435@shiny>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111111022100.GD4435@shiny> (Chris Mason's message of "Thu, 10
	Nov 2011 21:21:00 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

On Nov 11, 2011, Chris Mason <chris.mason@oracle.com> wrote:

> On Thu, Nov 10, 2011 at 05:32:48PM -0200, Alexandre Oliva wrote:
>> Instead of preventing the removal of devices that would render existing
>> raid10 or raid1 impossible, warn but go ahead with it; the rebalancing
>> code is smart enough to use different block group types.

> We'll need a --force or some kind.  There are definitely cases users
> have wanted to do this but it is rarely a good idea ;)

Even if it's just metadata that will turn from raid1 to dup, as in the
revised patch below?


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-Btrfs-enable-removal-of-second-disk-with-raid1-metad.patch

>From 276b1af70556bf5bdbaa1f81cb630d6c83962323 Mon Sep 17 00:00:00 2001
From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Tue, 8 Nov 2011 12:33:11 -0200
Subject: [PATCH 1/8] Btrfs: enable removal of second disk with raid1 metadata

Enable removal of a second disk even if that requires conversion of
metadata from raid1 to dup, but not when data would lose replication.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/volumes.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c37433d..7b348c2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1290,12 +1290,16 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		goto out;
 	}
 
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) &&
+	if ((root->fs_info->avail_data_alloc_bits & BTRFS_BLOCK_GROUP_RAID1) &&
 	    root->fs_info->fs_devices->num_devices <= 2) {
 		printk(KERN_ERR "btrfs: unable to go below two "
 		       "devices on raid1\n");
 		ret = -EINVAL;
 		goto out;
+	} else if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) &&
+		   root->fs_info->fs_devices->num_devices <= 2) {
+		printk(KERN_ERR "btrfs: going below two devices "
+		       "will switch metadata from raid1 to dup\n");
 	}
 
 	if (strcmp(device_path, "missing") == 0) {
-- 
1.7.4.4


--=-=-=



-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

--=-=-=--
