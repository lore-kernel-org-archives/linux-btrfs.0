Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab3CUQZU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 12:25:20 -0400
Message-ID: <514B346D.1010403@redhat.com>
Date: Thu, 21 Mar 2013 11:25:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Jon Nelson <jnelson@jamponi.net>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-show vs. btrfs different output
References: <CAKuK5J05iXaDd7Q4fLby9vJyPXBURx06xb0_--WmgTpJ0j2RoA@mail.gmail.com> <514B232E.2050705@redhat.com> <CAKuK5J3Fd+ya3SOwQPZohJArE+cPNZKchzH3UkvpvoAnK-6Hng@mail.gmail.com>
In-Reply-To: <CAKuK5J3Fd+ya3SOwQPZohJArE+cPNZKchzH3UkvpvoAnK-6Hng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/21/13 10:29 AM, Jon Nelson wrote:
> On Thu, Mar 21, 2013 at 10:11 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 3/21/13 10:04 AM, Jon Nelson wrote:
> ...
>>> 2. the current git btrfs-show and btrfs fi show both output
>>> *different* devices for device with UUID
>>> b5dc52bd-21bf-4173-8049-d54d88c82240, and they're both wrong.
>>
>> does blkid output find that uuid anywhere?
>>
>> Since you're working in git, can you maybe do a little bisecting
>> to find out when it changed?  Should be a fairly quick test?
> 
> blkid does /not/ report that uuid anywhere.
> 
> git bisect, if I did it correctly, says:
> 
> 
> 6eba9002956ac40db87d42fb653a0524dc568810 is the first bad commit
> commit 6eba9002956ac40db87d42fb653a0524dc568810
> Author: Goffredo Baroncelli <kreijack@inwind.it>
> Date:   Tue Sep 4 19:59:26 2012 +0200
> 
>     Correct un-initialized fsid variable
> 
> :100644 100644 b21a87f827a6250da45f2fb6a1c3a6b651062243
> 03952051b5e25e0b67f0f910c84d93eb90de8480 M      disk-io.c

Ok, I think this is another case of greedily scanning stale
backup superblocks (did you ever have btrfs on the whole sda
or sdb?)

btrfs_read_dev_super() currently tries to scan all 3 superblocks
(primary & 2 backups).  I'm guessing that you have some stale
backup superblocks on sda and/or sdb.

Before the above commit, if the first sb didn't look valid,
it'd skip to the 2nd.  If the 2nd (stale) one looked OK,
it'd compare its fsid to an uniniitialized variable (fsid)
which would fail (since the "fsid" contents were random.)
Same for the 3rd backup if found, and eventually it'd return
-1 as failure and not report the device.

After the commit, it'd skip the first invalid sb as well.
But this time, it takes the fsid from the 2nd superblock as
"good" and makes it through the loop thinking that it's found
something valid.  Hence the report of a device which you didn't
expect even though the first superblock is indeed wiped out.

There are some patches floating around to stop this
backup superblock scanning altogether.

This might fix it for you; it basically returns failure
if any superblock on the device is found to be bad.

What we really need is the right bits in the right places
to let the administrator know if a device looks like it might
be corrupt & in need of fixing, vs. ignoring it altogether.

Not sure if this is something we want upstream but you could
test if if you like.

-Eric

[PATCH] Fail btrfs_read_dev_super if any super looks invalid.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/disk-io.c b/disk-io.c
index a9fd374..3aca16f 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1104,7 +1104,6 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 {
 	u8 fsid[BTRFS_FSID_SIZE];
-	int fsid_is_initialized = 0;
 	struct btrfs_super_block buf;
 	int i;
 	int ret;
@@ -1130,24 +1129,22 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 		if (ret < sizeof(buf))
 			break;
 
-		if (btrfs_super_bytenr(&buf) != bytenr )
-			continue;
-		/* if magic is NULL, the device was removed */
-		if (buf.magic == 0 && i == 0) 
+		/* Bail out on any invalid superblock */
+		if (btrfs_super_bytenr(&buf) != bytenr ||
+		    buf.magic != cpu_to_le64(BTRFS_MAGIC))
 			return -1;
-		if (buf.magic != cpu_to_le64(BTRFS_MAGIC))
-			continue;
 
-		if (!fsid_is_initialized) {
+		/* if sb 0 looks valid use its fsid as trusted */
+		if (i == 0)
 			memcpy(fsid, buf.fsid, sizeof(fsid));
-			fsid_is_initialized = 1;
-		} else if (memcmp(fsid, buf.fsid, sizeof(fsid))) {
+		else if (memcmp(fsid, buf.fsid, sizeof(fsid))) {
 			/*
 			 * the superblocks (the original one and
 			 * its backups) contain data of different
-			 * filesystems -> the super cannot be trusted
+			 * filesystems -> the super cannot be trusted,
+			 * hence the fs cannot be trusted.
 			 */
-			continue;
+			return -1;
 		}
 
 		if (btrfs_super_generation(&buf) > transid) {



