Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38598 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754523AbdLDOPh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 09:15:37 -0500
Date: Mon, 4 Dec 2017 15:13:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: Greatly simplify btrfs_read_dev_super
Message-ID: <20171204141337.GX3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1512119984-12708-1-git-send-email-nborisov@suse.com>
 <1512119984-12708-6-git-send-email-nborisov@suse.com>
 <96aafd8d-a1e8-2846-0aa3-59b3ff97edb7@oracle.com>
 <f08faba1-2c79-bd80-34f5-f8f85e927464@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <f08faba1-2c79-bd80-34f5-f8f85e927464@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 03, 2017 at 11:43:13AM +0200, Nikolay Borisov wrote:
> On  2.12.2017 01:23, Anand Jain wrote:
> > On 12/01/2017 05:19 PM, Nikolay Borisov wrote:
> >> Currently this function executes the inner loop at most 1 due to the i
> >> = 0;
> >> i < 1 condition. Furthermore, the btrfs_super_generation(super) >
> >> transid code
> >> in the if condition is never executed due to latest always set to NULL
> >> hence the
> >> first part of the condition always triggering. The gist of
> >> btrfs_read_dev_super
> >> is really to read the first superblock.
> >>
> >> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> >> ---
> >>   fs/btrfs/disk-io.c | 27 ++++-----------------------
> >>   1 file changed, 4 insertions(+), 23 deletions(-)
> >>
> >> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >> index 82c96607fc46..6d5f632fd1e7 100644
> >> --- a/fs/btrfs/disk-io.c
> >> +++ b/fs/btrfs/disk-io.c
> >> @@ -3170,37 +3170,18 @@ int btrfs_read_dev_one_super(struct
> >> block_device *bdev, int copy_num,
> >>   struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
> >>   {
> >>       struct buffer_head *bh;
> >> -    struct buffer_head *latest = NULL;
> >> -    struct btrfs_super_block *super;
> >> -    int i;
> >> -    u64 transid = 0;
> >> -    int ret = -EINVAL;
> >> +    int ret;
> >>         /* we would like to check all the supers, but that would make
> >>        * a btrfs mount succeed after a mkfs from a different FS.
> >>        * So, we need to add a special mount option to scan for
> >>        * later supers, using BTRFS_SUPER_MIRROR_MAX instead
> >>        */
> > 
> >  We need below loop to support the above comment at some point,
> 
> And when is that, since I don't see anyone working on it. Furthermore
> what is it that we are losing in terms of functionality by not
> supporting the comment? It seems this code was just slapt here without
> any vision how/when to implement it?
> 
> Furthermore, you seem to be aware of what the comment is talking about,
> I have to admit I'm not. Is the idea that if another filesystem does
> mkfs and doesn't overwrite ALL superblock copies that btrfs writes (at
> 64k, 64mb, 256gb and 1 PiB) then it's possible for this code to
> erroneously detect btrfs when in fact there is a different fs?
> 
> I don't understand what problem *should* be solved here...

Without any further checks and validation, we cannot simply iterate over
all superblocks and try to mount anything that looks ok. Even if the
offsets exist on the block device.  The fsid should be at least checked,
but that's still not enough to ensure the 1st copy is what we want to
mount.

In that case it's up to the user to deal with the problem vs automating
all fallbacks in the kernel by default. We could enhance the recovery
options (usebackuproot) to look at the other superblocks.

An example scenario:

- mkfs, contains 2 superblocks (primary and 1st copy)
- shrink the filesystem, 1st copy contains stale version of the same
  filesystem
- mount, primary is broken, use 1st backup copy -- now, this could
  actually succeed if all metadata pointed by the 1st copy exist and are
  consistent and we'd end up with an older version of the filesystem
  metadata, and partially data


Another example, and this was probably meant by the comment:

- mkfs filesystem, contains primary and 1st (or more) superblock copy
- mkfs again, now contains fewer sb copies
- mount, similar situation as above, though the fsid will mismatch
  (provided we're able to read the primary sb at all)


The commit introducing the comment is from 2008, nobody saw the need to
add the validation. And from the usability POV, the current behaviour
looks better because the user/admin has a chance to analyze the problem
first, run fsck before mounting from the sb copies and then use
'btrfs-select-super' to overwrite the primary sb with the backup copy.

If there are clear guarantees and enough validation for the sb copy use,
then fine, otherwise we can apply this patch and extend the comment so
it's documented why we don't iterate.
