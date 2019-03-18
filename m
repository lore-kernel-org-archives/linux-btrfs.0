Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C39BC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 19:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36ACB20989
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 19:41:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=lesimple.fr header.i=@lesimple.fr header.b="ooZRcVqj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbfCRTlf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:41:35 -0400
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:39188 "EHLO
        mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727647AbfCRTle (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 15:41:34 -0400
Received: from rc.speed47.net (nginx [192.168.80.2])
        by box.speed47.net (Postfix) with ESMTP id D95DFB9B1;
        Mon, 18 Mar 2019 20:41:31 +0100 (CET)
Authentication-Results: box.speed47.net; dmarc=fail (p=none dis=none) header.from=lesimple.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lesimple.fr;
        s=mail01; t=1552938091;
        bh=49pwqX73f2Tm67v1i0Bys6S9Oy3WMbAyd+fOPqy9tlg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=ooZRcVqjqe7IAEw5Q6ievVevr+8/pyFBO45oLS90IF3dLz5A41jK0BT0PFP1Ck+x0
         9tOHs2GUiLgBiSDWx8k93VwyJt7T/Jq/Q7j2n6Rzqtc+cZkD68UtrEimgwsdd/G4Jr
         M8RsT4fBy3NBULAgyOYVi/8Uc/FExRN2EczTEVQE=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 18 Mar 2019 20:41:31 +0100
From:   =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To:     Hans van Kranenburg <hans@knorrie.org>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: fi usage: implement raid56
In-Reply-To: <d74a1afe-b218-25f9-97f1-43315e9590cf@knorrie.org>
References: <20190317125150.26265-1-stephane_btrfs@lesimple.fr>
 <20190317125150.26265-2-stephane_btrfs@lesimple.fr>
 <d74a1afe-b218-25f9-97f1-43315e9590cf@knorrie.org>
Message-ID: <9fb1f7ffe56acda248a64103c2a4bda8@lesimple.fr>
X-Sender: stephane_btrfs@lesimple.fr
User-Agent: Roundcube Webmail/1.2.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Hans,

Le 2019-03-18 00:23, Hans van Kranenburg a écrit :
> Hi,
> 
> On 3/17/19 1:51 PM, stephane_btrfs@lesimple.fr wrote:
>> From: Stéphane Lesimple <stephane_btrfs@lesimple.fr>
>> 
>> Implement RAID5 and RAID6 support in `filesystem usage'.
>> 
>> Before:
>>> WARNING: RAID56 detected, not implemented
>>> WARNING: RAID56 detected, not implemented
>>> WARNING: RAID56 detected, not implemented
>>>      Device allocated:     0.00B
>>>      Device unallocated:   2.04GiB
>>>      Used:                 0.00B
>>>      Free (estimated):     0.00B      (min: 8.00EiB)
>>>      Data ratio:           0.00
>>>      Metadata ratio:       0.00
>> 
>> After:
>>>      Device allocated:     1.83GiB
>>>      Device unallocated:   211.50MiB
>>>      Used:                 1.83GiB
>>>      Free (estimated):     128.44MiB  (min: 128.44MiB)
>>>      Data ratio:           1.65
>>>      Metadata ratio:       1.20
>> 
>> Note that this might need some fine-tuning for mixed mode.
>> 
>> We may also overestimate the free space incorrectly in
>> some complex disk configurations, i.e. when some of the
>> unallocated space is in fact unallocatable because the
>> redundancy profile requisites can't be matched with how
>> the remaining unallocated space is distributed over the
>> devices. This is not specific to raid56 and also happens
>> with other raid profiles, it'll need to be taken care of
>> separately.
>> 
>> Signed-off-by: Stéphane Lesimple <stephane_btrfs@lesimple.fr>
>> ---
>>  cmds-fi-usage.c | 96 
>> ++++++++++++++++++++++++++++++-------------------
>>  1 file changed, 60 insertions(+), 36 deletions(-)
>> 
>> diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
>> index 9a23e176..baa1ff89 100644
>> --- a/cmds-fi-usage.c
>> +++ b/cmds-fi-usage.c
>> @@ -280,28 +280,6 @@ static struct btrfs_ioctl_space_args 
>> *load_space_info(int fd, const char *path)
>>  	return sargs;
>>  }
>> 
>> -/*
>> - * This function computes the space occupied by a *single* 
>> RAID5/RAID6 chunk.
>> - * The computation is performed on the basis of the number of stripes
>> - * which compose the chunk, which could be different from the number 
>> of devices
>> - * if a disk is added later.
>> - */
>> -static void get_raid56_used(struct chunk_info *chunks, int 
>> chunkcount,
>> -		u64 *raid5_used, u64 *raid6_used)
>> -{
>> -	struct chunk_info *info_ptr = chunks;
>> -	*raid5_used = 0;
>> -	*raid6_used = 0;
>> -
>> -	while (chunkcount-- > 0) {
>> -		if (info_ptr->type & BTRFS_BLOCK_GROUP_RAID5)
>> -			(*raid5_used) += info_ptr->size / (info_ptr->num_stripes - 1);
>> -		if (info_ptr->type & BTRFS_BLOCK_GROUP_RAID6)
>> -			(*raid6_used) += info_ptr->size / (info_ptr->num_stripes - 2);
>> -		info_ptr++;
>> -	}
>> -}
>> -
>>  #define	MIN_UNALOCATED_THRESH	SZ_16M
>>  static int print_filesystem_usage_overall(int fd, struct chunk_info 
>> *chunkinfo,
>>  		int chunkcount, struct device_info *devinfo, int devcount,
>> @@ -331,13 +309,15 @@ static int print_filesystem_usage_overall(int 
>> fd, struct chunk_info *chunkinfo,
>>  	double data_ratio;
>>  	double metadata_ratio;
>>  	/* logical */
>> -	u64 raid5_used = 0;
>> -	u64 raid6_used = 0;
>> +	u64 r_data_raid56_chunks = 0;
>> +	u64 l_data_raid56_chunks = 0;
>> +	u64 r_metadata_raid56_chunks = 0;
>> +	u64 l_metadata_raid56_chunks = 0;
> 
> Can you explain what r and l mean? I have been staring at the code and
> reading back and forth for some time, but I still really have no idea.

I've tried to stick with the naming convention of the other variables
used in this function. Some lines above this diff, you'll find the 
following
comment in the original file, followed by some vars declarations:

/*
  * r_* prefix is for raw data
  * l_* is for logical
  */
  [...]
  u64 r_data_chunks = 0;
  u64 l_data_chunks = 0;
  u64 r_metadata_used = 0;
  u64 r_metadata_chunks = 0;
  u64 l_metadata_chunks = 0;

This is why I've also named my vars this way.
If you take for example a chunk with a raid1 replication policy, its
real (r_) used size will be 2G, and its logical (l_) size will be 1G.


>>  	u64 l_global_reserve = 0;
>>  	u64 l_global_reserve_used = 0;
>>  	u64 free_estimated = 0;
>>  	u64 free_min = 0;
>> -	int max_data_ratio = 1;
>> +	double max_data_ratio = 1;
>>  	int mixed = 0;
>> 
>>  	sargs = load_space_info(fd, path);
>> @@ -359,24 +339,29 @@ static int print_filesystem_usage_overall(int 
>> fd, struct chunk_info *chunkinfo,
>>  		ret = 1;
>>  		goto exit;
>>  	}
>> -	get_raid56_used(chunkinfo, chunkcount, &raid5_used, &raid6_used);
>> 
>>  	for (i = 0; i < sargs->total_spaces; i++) {
>>  		int ratio;
>>  		u64 flags = sargs->spaces[i].flags;
>> 
>> +		if ((flags & (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA))
>> +		    == (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA)) {
>> +			mixed = 1;
>> +		}
>> +
>>  		/*
>>  		 * The raid5/raid6 ratio depends by the stripes number
>> -		 * used by every chunk. It is computed separately
>> +		 * used by every chunk. It is computed separately,
>> +		 * after we're done with this loop, so skip those.
>>  		 */
>>  		if (flags & BTRFS_BLOCK_GROUP_RAID0)
>>  			ratio = 1;
>>  		else if (flags & BTRFS_BLOCK_GROUP_RAID1)
>>  			ratio = 2;
>>  		else if (flags & BTRFS_BLOCK_GROUP_RAID5)
>> -			ratio = 0;
>> +			continue;
>>  		else if (flags & BTRFS_BLOCK_GROUP_RAID6)
>> -			ratio = 0;
>> +			continue;
>>  		else if (flags & BTRFS_BLOCK_GROUP_DUP)
>>  			ratio = 2;
>>  		else if (flags & BTRFS_BLOCK_GROUP_RAID10)
>> @@ -384,9 +369,6 @@ static int print_filesystem_usage_overall(int fd, 
>> struct chunk_info *chunkinfo,
>>  		else
>>  			ratio = 1;
>> 
>> -		if (!ratio)
>> -			warning("RAID56 detected, not implemented");
>> -
>>  		if (ratio > max_data_ratio)
>>  			max_data_ratio = ratio;
>> 
>> @@ -394,10 +376,6 @@ static int print_filesystem_usage_overall(int fd, 
>> struct chunk_info *chunkinfo,
>>  			l_global_reserve = sargs->spaces[i].total_bytes;
>>  			l_global_reserve_used = sargs->spaces[i].used_bytes;
>>  		}
>> -		if ((flags & (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA))
>> -		    == (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA)) {
>> -			mixed = 1;
>> -		}
>>  		if (flags & BTRFS_BLOCK_GROUP_DATA) {
>>  			r_data_used += sargs->spaces[i].used_bytes * ratio;
>>  			r_data_chunks += sargs->spaces[i].total_bytes * ratio;
>> @@ -414,6 +392,52 @@ static int print_filesystem_usage_overall(int fd, 
>> struct chunk_info *chunkinfo,
>>  		}
>>  	}
>> 
>> +	/*
>> +	 * Here we compute the space occupied by every RAID5/RAID6 chunks.
>> +	 * The computation is performed on the basis of the number of 
>> stripes
>> +	 * which compose each chunk, which could be different from the 
>> number of devices
>> +	 * if a disk is added later, or if the disks are of different 
>> sizes..
>> +	 */
>> +	struct chunk_info *info_ptr;
>> +	for (info_ptr = chunkinfo, i = chunkcount; i > 0; i--, info_ptr++) {
>> +		int flags = info_ptr->type;
>> +		int nparity;
>> +
>> +		if (flags & BTRFS_BLOCK_GROUP_RAID5) {
>> +			nparity = 1;
>> +		}
>> +		else if (flags & BTRFS_BLOCK_GROUP_RAID6) {
>> +			nparity = 2;
>> +		}
>> +		else {
>> +			// We're only interested in raid56 here
>> +			continue;
>> +		}
> 
> I interpret the else continue as "ok, so apparently we can hit these
> lines of code for other stuff than RAID56", which is expected and fine,
> and then we'll silently ignore it.

Yes, this for() loop will be entered in any case, because the 
replication
policy (raid5 or raid1) is not a property of the filesystem as a whole,
it's a property of a chunk. So you can have in the same filesystem, some
chunks with raid1 replication policy, and some others in raid5.
This can happen if, for example, you start a balance with 
-dconvert=raid5
on a previously raid1-only filesystem, and stop it after a few chunks 
have
been converted. This is perfectly valid from a btrfs standpoint.

So, this for() loop's job is to go trough each chunkinfo and process 
only
the raid5/raid6 ones, because for the other replication profiles, this 
is
already handled by the code above this for(), asfor every profile
except raid5/raid6, one don't need to go through each chunk: for raid1 
we
know that the ratio is exactly 2, because that's the very definition of
btrfs-raid1. For raid5/6 on the other hand, it depends on the number of
slices the chunk has, and this can change over time (as disks are added,
or if disks are not of the same size).

> But, in that case the value of nparity is not initialized and the lines
> below seem like this part of the code is actually never executed for
> anything that's not RAID56, so why the else up here? Or, maube print a
> big error or crash the program, if the else never should happen?

Actually, the else is there to just go check the next chunk in case the 
one we're
working on is not raid5 or raid6, because this for() loop only counts 
the
number of bytes in raid5/raid6 chunks (to later be able to compute the 
ratio).
We just want to skip all the others (they've already been handled by 
preexisting
code).
Also, as nparity is only used if we're inspecting a raid5/6 chunk,
there shouldn't be a case where it is referenced and not initialized 
AFAICT.

> 
>> +
>> +		if (flags & BTRFS_BLOCK_GROUP_DATA) {
>> +			r_data_raid56_chunks += info_ptr->size / (info_ptr->num_stripes - 
>> nparity);
> 
> Ah, so this is the calculation of device extent size. Still wondering
> what the r would mean.

here, we're counting the number of bytes used by raid5 or raid6 chunks, 
physically
on the devices.

> 
>> +			l_data_raid56_chunks += info_ptr->size / info_ptr->num_stripes;
> 
> I still don't understand what meaning this has. Chunk length divided by
> num_stripes (with parity)...
> 
> A variable named data_raid56_chunks tells me that you are counting the
> amount of chunks that have type DATA and profile RAID5 or RAID6, but
> this code is doing something really different, it's counting bytes. But
> what sort of bytes...

It's a bit misleading indeed, actually a previous version of my patch 
had
this variable named "r_data_raid56_size", but I noticed that in 
preexisting
code, "r_data_chunks" is used to count the number of bytes (and not 
number of
chunks) used by non-raid5/6 chunks, as you can see:

r_data_chunks += sargs->spaces[i].total_bytes * ratio;

And a similar line for the "l_" variant:

l_data_chunks += sargs->spaces[i].total_bytes;

So I've renamed my variables to stick with this naming usage.

>> +		}
>> +		if (flags & BTRFS_BLOCK_GROUP_METADATA) {
>> +			r_metadata_raid56_chunks += info_ptr->size / 
>> (info_ptr->num_stripes - nparity);
>> +			l_metadata_raid56_chunks += info_ptr->size / 
>> info_ptr->num_stripes;
>> +		}
>> +	}
>> +
>> +	if (l_data_raid56_chunks > 0) {
>> +		double ratio = (double)r_data_raid56_chunks / l_data_raid56_chunks;
>> +		r_data_used += r_data_raid56_chunks;
>> +		r_data_chunks += r_data_raid56_chunks;
>> +		l_data_chunks += l_data_raid56_chunks;
>> +		if (ratio > max_data_ratio)
>> +			max_data_ratio = ratio;
>> +	}
>> +	if (l_metadata_raid56_chunks > 0) {
>> +		r_metadata_used += r_metadata_raid56_chunks;
>> +		r_metadata_chunks += r_metadata_raid56_chunks;
>> +		l_metadata_chunks += l_metadata_raid56_chunks;
>> +	}
>> +
>>  	r_total_chunks = r_data_chunks + r_system_chunks;
>>  	r_total_used = r_data_used + r_system_used;
>>  	if (!mixed) {
>> 
> 
> I'm not a super-experienced C coder, but I can read C and write patches
> while looking at the history of the code in some place, and following
> patterns. What I'm throwing at you here is some feedback about
> readability. I'd like to help reviewing this, but I can't really
> understand it.

Thanks for your time reviewing this patch, and in any case I hope I've 
shed
some light on what it does exactly! Please don't hesitate to comment 
back
if anything is still not clear!

-- 
Stéphane.
