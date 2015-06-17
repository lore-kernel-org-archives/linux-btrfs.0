Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300AbbFQOgz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 10:36:55 -0400
Message-ID: <55818603.1080109@suse.com>
Date: Wed, 17 Jun 2015 10:36:51 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/7] btrfs: explictly delete unused block groups in close_ctree
 and ro-remount
In-Reply-To: <558184E1.5040103@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1434375680-4115-5-git-send-email-jeffm@suse.com>
 <CAL3q7H7ZLQWSMsSSDg_+p3o3ODxDM8xO+95zJ8cFp-nMzAShOQ@mail.gmail.com>
 <CAL3q7H6+QrLFX3H-5jsccv1hvPFhsF4h-vYzdEJcWoefAEymAg@mail.gmail.com>
 <558184E1.5040103@suse.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/17/15 10:32 AM, Jeff Mahoney wrote:
> On 6/17/15 9:24 AM, Filipe David Manana wrote:
>> On Wed, Jun 17, 2015 at 11:04 AM, Filipe David Manana 
>> <fdmanana@gmail.com> wrote:
>>> On Mon, Jun 15, 2015 at 2:41 PM,  <jeffm@suse.com> wrote:
>>>> From: Jeff Mahoney <jeffm@suse.com>
>>>> 
>>>> The cleaner thread may already be sleeping by the time we 
>>>> enter close_ctree.  If that's the case, we'll skip removing
>>>> any unused block groups queued for removal, even during a
>>>> normal umount. They'll be cleaned up automatically at next
>>>> mount, but users expect a umount to be a clean
>>>> synchronization point, especially when used on
>>>> thin-provisioned storage with -odiscard.  We also explicitly
>>>> remove unused block groups in the ro-remount path for the
>>>> same reason.
>>>> 
>>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>>> Reviewed-by: Filipe Manana <fdmanana@suse.com> Tested-by:
>>> Filipe Manana <fdmanana@suse.com>
>>> 
>>>> --- fs/btrfs/disk-io.c |  9 +++++++++ fs/btrfs/super.c   |
>>>> 11 +++++++++++ 2 files changed, 20 insertions(+)
>>>> 
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c index 
>>>> 2ef9a4b..2e47fef 100644 --- a/fs/btrfs/disk-io.c +++ 
>>>> b/fs/btrfs/disk-io.c @@ -3710,6 +3710,15 @@ void 
>>>> close_ctree(struct btrfs_root *root) 
>>>> cancel_work_sync(&fs_info->async_reclaim_work);
>>>> 
>>>> if (!(fs_info->sb->s_flags & MS_RDONLY)) { +               /*
>>>> + * If the cleaner thread is stopped and there are + * block
>>>> groups queued for removal, the deletion will be + * skipped
>>>> when we quit the cleaner thread. +                */ +
>>>> mutex_lock(&root->fs_info->cleaner_mutex); + 
>>>> btrfs_delete_unused_bgs(root->fs_info); + 
>>>> mutex_unlock(&root->fs_info->cleaner_mutex); + ret = 
>>>> btrfs_commit_super(root); if (ret) btrfs_err(fs_info,
>>>> "commit super ret %d", ret); diff --git a/fs/btrfs/super.c 
>>>> b/fs/btrfs/super.c index 9e66f5e..2ccd8d4 100644 --- 
>>>> a/fs/btrfs/super.c +++ b/fs/btrfs/super.c @@ -1539,6
>>>> +1539,17 @@ static int btrfs_remount(struct super_block *sb,
>>>> int *flags, char *data)
>>>> 
>>>> sb->s_flags |= MS_RDONLY;
>>>> 
>>>> +               /* +                * Setting MS_RDONLY will 
>>>> put the cleaner thread to +                * sleep at the
>>>> next loop if it's already active. +                * If it's
>>>> already asleep, we'll leave unused block +                *
>>>> groups on disk until we're mounted read-write again +
>>>> * unless we clean them up here. +                */ + 
>>>> mutex_lock(&root->fs_info->cleaner_mutex); + 
>>>> btrfs_delete_unused_bgs(fs_info); + 
>>>> mutex_unlock(&root->fs_info->cleaner_mutex);
> 
>> So actually, this allows for a deadlock after the patch I sent
>> out last week:
> 
>> https://patchwork.kernel.org/patch/6586811/
> 
>> In that patch delete_unused_bgs is no longer called under the 
>> cleaner_mutex, and making it so, will cause a deadlock with/ru 
>> relocation.
> 
>> Even without that patch, I don't think you need using this mutex
>>  anyway - no 2 tasks running this function can get the same bg
>> from the fs_info->unused_bgs list.
> 
> I was hitting crashes during umount when xfstests would do
> remount-ro and umount in quick succession.  I can go back and
> confirm this, but I believe I was encountering a race between the
> cleaner thread and umount after being set read-only.  It didn't
> trigger all the time.  My hypothesis is that if the cleaner thread
> was running and had a lot of work to do, it could start before set
> MS_RDONLY and still be performing work through the remount and into
> the umount.  Ro-remount would have set MS_RDONLY so we skip the
> btrfs_super_commit in close_ctree and then blow up afterwards.
> 
> Taking the cleaner mutex means we either wait until the cleaner
> thread has finished or we put it to sleep on the next loop before
> it does anything.  In either case, it's safe.  It could just has
> easily been:
> 
> mutex_lock(&root->fs_info->cleaner_mutex); 
> mutex_unlock(&root->fs_info->cleaner_mutex);
> 
> btrfs_delete_unused_bgs(fs_info);
> 
> I think it actually was in a previous version I was testing.  It 
> probably should go back to that version so that we don't end up 
> confusing it with the new mutex you introduced in your patch.

It looks like your:
[PATCH] Btrfs: fix crash on close_ctree() if cleaner starts new
transaction

would also fix this in a more general case.  We can drop taking the
cleaner mutex here.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJVgYYDAAoJEB57S2MheeWyxIcQAIGwFvP1bL4C8Oa3WyFL/tjE
QITNDQZGYXEKfFqRWdHEAeFJ8kv234xo/tx7Ml0Txd8DFrqzDwXSxv6deLzDiiTT
gymMdBKO3x7TLKZTxnyDXYEUDHM72IMOUS2el3wOOsc61rL1KajFEWySGtAA80pk
bIUH6uosRTXhpXBRe080mc9XPhtfIQyCC8nroJHYazNwT3VWrvbhDaZPM3npNttj
5glsCz7ieseiWKqFCIlYC5yCgpst79U7D8M75Jo0yslvtZNpZOMR3YhvyQakj5hG
p/CFRfbdFGnl3wKv+ACyu7XlewqoA9LwkB5Sbjzd4XbS3n7J4gch043b+BbIl2SA
VghNTTI+tm7KKvMa3fghtedooVYu6DjdhU58VEWOBtHaDiWntSmd0FqzUCqAotxC
fwEmMWCWCWR1E0etRUrnbO1DGltkR38ost7cvXOPXUUdvv3Hy22mTfWW73YwsWXW
kwmG2V+IdgOWHDMxQCnj55/NbYep+/TiVjDPJnOuCn8tD5Tw+zHxtRbXhVcyKpGj
jJXKb9uxDhKpsisz8HQJHf1uMLFJ3qzCqgYxysbc2PqlzylFfY2aefYWSPmrE6y4
6OJW7gTr75PzrGGm7gM1sPiPQLuFNEFBEi0Ak7ad6Q6SAAV339r+h00sg4Q1adVu
2JedYHUeFDUjAGAgft0G
=SQ/a
-----END PGP SIGNATURE-----
