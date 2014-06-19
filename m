Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965528AbaFSXQ2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 19:16:28 -0400
Date: Thu, 19 Jun 2014 16:16:26 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: btrfs: qgroup: account shared subtrees during snapshot delete
Message-ID: <20140619231626.GQ5484@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1403214567-3137-1-git-send-email-mfasheh@suse.de> <1403214567-3137-3-git-send-email-mfasheh@suse.de> <53A36348.4010106@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53A36348.4010106@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the review Josef, I will implement everything you mentioned. I
have one question below though:

On Thu, Jun 19, 2014 at 03:25:12PM -0700, Josef Bacik wrote:
> On 06/19/2014 02:49 PM, Mark Fasheh wrote:
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 46f39bf..672d2a4 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -7472,6 +7703,9 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>>
>>   	if (wc->stage == DROP_REFERENCE) {
>>   		if (wc->refs[level - 1] > 1) {
>> +			account_shared_subtree(trans, root, next, generation,
>> +					       level - 1);
>> +
>
> We don't pay attention to the return value, we should probably abort the
> transaction if there is a problem.

Abort or log an error and continue? I ask because technically we could
continue with the subvolume drop but obviously qgroup state will need to be
fixed via a future rescan. I guess the question is which is more 'friendly'
to the user.
	--Mark

--
Mark Fasheh
