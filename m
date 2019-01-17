Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BAE2C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDE4C20851
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfAQPk2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 10:40:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:41786 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726854AbfAQPk2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 10:40:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B2303AEF8;
        Thu, 17 Jan 2019 15:40:26 +0000 (UTC)
Subject: Re: [PATCH 5/7] btrfs: just delete pending bgs if we are aborted
To:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20181121190545.24798-1-josef@toxicpanda.com>
 <20181121190545.24798-6-josef@toxicpanda.com>
 <20190116145920.GO2900@twin.jikos.cz> <20190116152255.GP2900@twin.jikos.cz>
 <20190117145632.GS2900@twin.jikos.cz>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <a2af90d1-067b-870d-802f-c9cdf2b0e6f5@suse.com>
Date:   Thu, 17 Jan 2019 17:40:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190117145632.GS2900@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 17.01.19 г. 16:56 ч., David Sterba wrote:
> On Wed, Jan 16, 2019 at 04:22:55PM +0100, David Sterba wrote:
>> On Wed, Jan 16, 2019 at 03:59:20PM +0100, David Sterba wrote:
>>> On Wed, Nov 21, 2018 at 02:05:43PM -0500, Josef Bacik wrote:
>>>> We still need to do all of the accounting cleanup for pending block
>>>> groups if we abort.  So set the ret to trans->aborted so if we aborted
>>>> the cleanup happens and everybody is happy.
>>>>
>>>> Reviewed-by: Omar Sandoval <osandov@fb.com>
>>>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>>>> ---
>>>>  fs/btrfs/extent-tree.c | 8 +++++++-
>>>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>> index b9b829c8825c..90423b6749b7 100644
>>>> --- a/fs/btrfs/extent-tree.c
>>>> +++ b/fs/btrfs/extent-tree.c
>>>> @@ -10500,11 +10500,17 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
>>>>  	struct btrfs_root *extent_root = fs_info->extent_root;
>>>>  	struct btrfs_block_group_item item;
>>>>  	struct btrfs_key key;
>>>> -	int ret = 0;
>>>> +	int ret;
>>>>  
>>>>  	if (!trans->can_flush_pending_bgs)
>>>>  		return;
>>>>  
>>>> +	/*
>>>> +	 * If we aborted the transaction with pending bg's we need to just
>>>> +	 * cleanup the list and carry on.
>>>> +	 */
>>>> +	ret = trans->aborted;
>>>
>>> The cleanup is suitable for a separate helper that does only
>>>
>>> while (!list_empty(&trans->new_bgs)) {
>>> 	list_del_init(&block_group->bg_list);
>>> 	btrfs_delayed_refs_rsv_release(fs_info, 1);
>>> }
>>>
>>> and does not rely on the transaction->abort in a function with 'create'
>>> in it's name.
>>>
>>> The related part is in a separate patch that ab-uses the fact that
>>> setting ->abort will trigger the cleanup.
>>>
>>> https://patchwork.kernel.org/patch/10693081/ will then simply call the
>>> halper instead of
>>>
>>> +	/* This cleans up the pending block groups list properly. */
>>> +	if (!trans->aborted)
>>> +		trans->aborted = ret;
>>> +	btrfs_create_pending_block_groups(trans);
>>>
>>> Setting aborted to an error code anywhere else than
>>> __btrfs_abort_transaction does not sound right as it misses the whole
>>> report.
>>
>> Like this:
>>
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -1901,6 +1901,20 @@ static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
>>                 btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
>>  }
>>
>> +static void btrfs_cleanup_pending_block_groups(struct btrfs_trans_handle *trans)
>> +{
>> +       struct btrfs_fs_info *fs_info = trans->fs_info;
>> +       struct btrfs_block_group_cache *block_group;
>> +
>> +       while (!list_empty(&trans->new_bgs)) {
>> +               block_group = list_first_entry(&trans->new_bgs,
>> +                                              struct btrfs_block_group_cache,
>> +                                              bg_list);
>> +               btrfs_delayed_refs_rsv_release(fs_info, 1);
>> +               list_del_init(&block_group->bg_list);
>> +       }
>> +}
>> +
>>  int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>>  {
>>         struct btrfs_fs_info *fs_info = trans->fs_info;
>> @@ -2270,6 +2284,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>>         btrfs_scrub_continue(fs_info);
>>  cleanup_transaction:
>>         btrfs_trans_release_metadata(trans);
>> +       btrfs_cleanup_pending_block_groups(trans);
>>         btrfs_trans_release_chunk_metadata(trans);
>>         trans->block_rsv = NULL;
>>         btrfs_warn(fs_info, "Skipping commit of aborted transaction.");
>> ---
>>
>> The call to btrfs_trans_release_chunk_metadata is not duplicated now as it
>> would happen twice in you version (within btrfs_create_pending_block_groups and
>> in transaction commit).
> 
> FYI, this passed the 475 test (with accounting warnings that are
> possibly fixed by the other patches) + no blowups in the following
> tests.

For what is worth 475 doesn't always fail for me - without those
patches. So make sure you have given it a good bashing before deeming it
good.

> 
