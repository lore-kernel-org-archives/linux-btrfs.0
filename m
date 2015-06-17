Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372AbbFQOcG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 10:32:06 -0400
Message-ID: <558184E1.5040103@suse.com>
Date: Wed, 17 Jun 2015 10:32:01 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/7] btrfs: explictly delete unused block groups in close_ctree
 and ro-remount
In-Reply-To: <CAL3q7H6+QrLFX3H-5jsccv1hvPFhsF4h-vYzdEJcWoefAEymAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1434375680-4115-5-git-send-email-jeffm@suse.com>
 <CAL3q7H7ZLQWSMsSSDg_+p3o3ODxDM8xO+95zJ8cFp-nMzAShOQ@mail.gmail.com>
 <CAL3q7H6+QrLFX3H-5jsccv1hvPFhsF4h-vYzdEJcWoefAEymAg@mail.gmail.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/17/15 9:24 AM, Filipe David Manana wrote:
> On Wed, Jun 17, 2015 at 11:04 AM, Filipe David Manana 
> <fdmanana@gmail.com> wrote:
>> On Mon, Jun 15, 2015 at 2:41 PM,  <jeffm@suse.com> wrote:
>>> From: Jeff Mahoney <jeffm@suse.com>
>>> 
>>> The cleaner thread may already be sleeping by the time we
>>> enter close_ctree.  If that's the case, we'll skip removing any
>>> unused block groups queued for removal, even during a normal
>>> umount. They'll be cleaned up automatically at next mount, but
>>> users expect a umount to be a clean synchronization point,
>>> especially when used on thin-provisioned storage with
>>> -odiscard.  We also explicitly remove unused block groups in
>>> the ro-remount path for the same reason.
>>> 
>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> Reviewed-by: Filipe Manana <fdmanana@suse.com> Tested-by: Filipe
>> Manana <fdmanana@suse.com>
>> 
>>> --- fs/btrfs/disk-io.c |  9 +++++++++ fs/btrfs/super.c   | 11
>>> +++++++++++ 2 files changed, 20 insertions(+)
>>> 
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c index
>>> 2ef9a4b..2e47fef 100644 --- a/fs/btrfs/disk-io.c +++
>>> b/fs/btrfs/disk-io.c @@ -3710,6 +3710,15 @@ void
>>> close_ctree(struct btrfs_root *root) 
>>> cancel_work_sync(&fs_info->async_reclaim_work);
>>> 
>>> if (!(fs_info->sb->s_flags & MS_RDONLY)) { +               /* +
>>> * If the cleaner thread is stopped and there are +
>>> * block groups queued for removal, the deletion will be +
>>> * skipped when we quit the cleaner thread. +                */ 
>>> +               mutex_lock(&root->fs_info->cleaner_mutex); +
>>> btrfs_delete_unused_bgs(root->fs_info); +
>>> mutex_unlock(&root->fs_info->cleaner_mutex); + ret =
>>> btrfs_commit_super(root); if (ret) btrfs_err(fs_info, "commit
>>> super ret %d", ret); diff --git a/fs/btrfs/super.c
>>> b/fs/btrfs/super.c index 9e66f5e..2ccd8d4 100644 ---
>>> a/fs/btrfs/super.c +++ b/fs/btrfs/super.c @@ -1539,6 +1539,17
>>> @@ static int btrfs_remount(struct super_block *sb, int *flags,
>>> char *data)
>>> 
>>> sb->s_flags |= MS_RDONLY;
>>> 
>>> +               /* +                * Setting MS_RDONLY will
>>> put the cleaner thread to +                * sleep at the next
>>> loop if it's already active. +                * If it's already
>>> asleep, we'll leave unused block +                * groups on
>>> disk until we're mounted read-write again +                *
>>> unless we clean them up here. +                */ +
>>> mutex_lock(&root->fs_info->cleaner_mutex); +
>>> btrfs_delete_unused_bgs(fs_info); +
>>> mutex_unlock(&root->fs_info->cleaner_mutex);
> 
> So actually, this allows for a deadlock after the patch I sent out
> last week:
> 
> https://patchwork.kernel.org/patch/6586811/
> 
> In that patch delete_unused_bgs is no longer called under the 
> cleaner_mutex, and making it so, will cause a deadlock with/ru 
> relocation.
> 
> Even without that patch, I don't think you need using this mutex 
> anyway - no 2 tasks running this function can get the same bg from
> the fs_info->unused_bgs list.

I was hitting crashes during umount when xfstests would do remount-ro
and umount in quick succession.  I can go back and confirm this, but I
believe I was encountering a race between the cleaner thread and
umount after being set read-only.  It didn't trigger all the time.  My
hypothesis is that if the cleaner thread was running and had a lot of
work to do, it could start before set MS_RDONLY and still be
performing work through the remount and into the umount.  Ro-remount
would have set MS_RDONLY so we skip the btrfs_super_commit in
close_ctree and then blow up afterwards.

Taking the cleaner mutex means we either wait until the cleaner thread
has finished or we put it to sleep on the next loop before it does
anything.  In either case, it's safe.  It could just has easily been:

               mutex_lock(&root->fs_info->cleaner_mutex);
               mutex_unlock(&root->fs_info->cleaner_mutex);

               btrfs_delete_unused_bgs(fs_info);

I think it actually was in a previous version I was testing.  It
probably should go back to that version so that we don't end up
confusing it with the new mutex you introduced in your patch.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJVgYThAAoJEB57S2MheeWymvMP/jPnCFslZfEphccGlqsDUQeb
Ua9SVQJ5XjS0BbnVfuMGmzxew30BkUBdpnlWsufdVIKIeR9DNcvuDHJtcXMUI+Uw
FU/Asik//xiDPJ1hldPc4d0CJjsFBKHVLKjirkeE7kuvwa+XmfUYfKrhfzt6ZGvt
sWrCwMJRWFAS88ayR+NAelwaMzIy+Rbs5gZYg6dd2OCvIa4GuTh/szx8RaPOjNWQ
QcQHy2FlCcV/AtCA+ZaXh8NLmATIA8613biP7ATGIYHEdaZf7Oivov/u154QVwkt
c4omauofHKbBmlz2d//PS/T/n9nT7F7p1YvFaDnLLyQ0Ew3VBq+M9gyuWF8IGxti
iHdGkgQxnPSY0gGLA5bIt0D+su1RcTqa/71LOsBqbmk7KioNF4bp9FmaykHx2LAL
NpKGPD6BEcTTZAXfGdV6/IxTuii1temxcyawJrijakFTseA/GOmODI3K1kg+nLZA
OBjzFmzzLFir8SuiIWLO5ncbbsoM6rHhbl08DeKZ6tOH4JQm2ROciVgTn67SVxB5
bmjzl/zhhePfPgmbf5WoLsT4cbuGK00r+M3U79vzIjfEPmKAfGFbu9jEGPvQahKT
tOBRw7IaL8vCrBLFGUhhQzECwOK6Zms4r2ZTino30MwSNHegPjUbt8xDmFHw+gp3
Td6o4o23By9ygZgac0KI
=iHjc
-----END PGP SIGNATURE-----
