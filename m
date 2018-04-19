Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54470 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753549AbeDSQYv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 12:24:51 -0400
Subject: Re: [PATCH 1/3] btrfs: Add incompat flags check for
 btrfs_check_super_valid()
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180419093816.888-1-wqu@suse.com>
 <7e7554c2-28d1-5912-7f02-e1f87556a3a8@suse.com>
 <b94eaf2e-8d5e-23e9-0672-2eb5abd56ae8@gmx.com>
 <20180419153106.GJ21272@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <17216718-a88d-de20-1a26-e7a5a515d02a@suse.com>
Date: Thu, 19 Apr 2018 19:24:48 +0300
MIME-Version: 1.0
In-Reply-To: <20180419153106.GJ21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.04.2018 18:31, David Sterba wrote:
> On Thu, Apr 19, 2018 at 07:10:30PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018年04月19日 18:59, Nikolay Borisov wrote:
>>>
>>>
>>> On 19.04.2018 12:38, Qu Wenruo wrote:
>>>> Although we have already checked incompat flags manually before really
>>>> mounting it, we could still enhance btrfs_check_super_valid() to check
>>>> incompat flags for later write time super block validation check.
>>>>
>>>> This patch adds such incompat flags check for btrfs_check_super_valid(),
>>>> currently it won't be triggered, but provides the basis for later write
>>>> time check.
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>
>>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>>>
>>>> ---
>>>>  fs/btrfs/disk-io.c | 13 +++++++++++++
>>>>  1 file changed, 13 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>> index 60caa68c3618..ec123158f051 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -4104,6 +4104,19 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
>>>
>>> nit: Thinking out loud here - wouldn't it make more sense to name the
>>> function btrfs_validate_super. check_super_valid sounds a bit cumbersome
>>> to me. What do you think ?
>>
>> Indeed, I also like to remove the btrfs_ prefix since it's a static
>> function.
>> validate_super() looks much better.
> 
> It's not necessary to remove the btrfs_ prefix from all static
> functions, sometimes the functions appear on stacks or mixed with other
> subystem helpers that have generic names. The prefix makes it clear that
> it's our function.

I agree with David, just make it btrfs_validate_super
> 
