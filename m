Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37302 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2I3Xz3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 19:55:29 -0400
Received: by lbon3 with SMTP id n3so3543139lbo.19
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Sep 2012 16:55:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120930222916.GK14582@twin.jikos.cz>
References: <CANW9uyu_-DFmggZUyAc1OOd0knMxEp-O3GPcs_8ZsoXAxm0DZg@mail.gmail.com>
	<20120929162140.GI14582@twin.jikos.cz>
	<CANW9uys+9BHixw-sG3xbH5AyaOCFYW_o5XyAgBTiioczygcsfg@mail.gmail.com>
	<CANW9uytWQ2DmpkAEg+Q=ZOenqdhe=NiRL9=Yq-7-Y6QVXQRFLQ@mail.gmail.com>
	<20120930222916.GK14582@twin.jikos.cz>
Date: Mon, 1 Oct 2012 08:55:28 +0900
Message-ID: <CANW9uyvdTthEvEwEDJeVRFKNm+3OF+cUS8Y22fmvKokL-Je4-w@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: shrink_delalloc check bdi write congested
From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
To: dave@jikos.cz
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,
Thank you for your comments. I wanted to fix a lockdep warning on a
possible deadlock
case encountered during the xfstests with a scratch space almost full.

You are right I encountered the worst scenario you described below, I
drop this patch and
I'll look at btrfs_congested_fn more to examine the mechanisms
implemented there are
working as expected.

Thanks,

Itaru

On Mon, Oct 1, 2012 at 7:29 AM, David Sterba <dave@jikos.cz> wrote:
> Hi again,
>
> On Sun, Sep 30, 2012 at 11:11:10AM +0900, Itaru Kitayama wrote:
>> This is the correct one.
>>
>> Signed-off-by: Itaru Kitayama <kitayama@cl.bb4.ne.jp>
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index efb044e..c032dbe 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -3712,8 +3712,9 @@ static void shrink_delalloc(struct btrfs_root
>> *root, u64 to_reclaim, u64 orig,
>>         while (delalloc_bytes && loops < 3) {
>>                 max_reclaim = min(delalloc_bytes, to_reclaim);
>>                 nr_pages = max_reclaim >> PAGE_CACHE_SHIFT;
>> -               writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages,
>> -                                              WB_REASON_FS_FREE_SPACE);
>> +               if (!bdi_write_congested(root->fs_info->sb->s_bdi))
>> +                       writeback_inodes_sb_nr_if_idle(root->fs_info, nr_pages,
>> +                                                      WB_REASON_FS_FREE_SPACE);
>
> You don't pass the same argument to writeback_inodes_sb_nr_if_idle in
> the changed code, this would not compile (root->fs_info->sb), but it's
> a minor thing.
>
> I'm more interested in the background motivation of the change, it's
> clear that it tries to avoid writing data if the devices are congested,
> have you measured an improvement against original behaviour?
>
> writeback_inodes_sb_nr_if_idle checks if writeback is in progress and
> does not start if this is true. That way this will not hammer the device
> unnecessarily.
>
> Your code tries to avoid even more hammering of the device when the
> writes do not come from writeback. This may or may not be a good thing
> (and hard to guess without a few tests, or at least I don't see that).
>
> Shrink delalloc starts the writeback for a given number of pages and
> then hopes they'll be flushed so the reserved space can be reclaimed
> back. If the device is congested, this will not start the writeback and
> it would be very unlikely that total delalloc bytes shrinks. The rest of
> the function relies on asynchronous behaviour, it's even less clear what
> it would do without the writeback call. In the worst case it could block
> on 'wait_event' or at 'btrfs_wait_ordered_extents' in some case, though
> this is just more of a speculation.
>
>
> david
