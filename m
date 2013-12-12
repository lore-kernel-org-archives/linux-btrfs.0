Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30113 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797Ab3LLTkZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 14:40:25 -0500
Message-ID: <52AA0CE1.3050000@fb.com>
Date: Thu, 12 Dec 2013 14:22:09 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        <guihc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs-progs: deal with invalid key orderings and bad
 orphan items
References: <1386779134-16228-1-git-send-email-jbacik@fb.com> <20131212182842.GU6498@twin.jikos.cz>
In-Reply-To: <20131212182842.GU6498@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/12/2013 01:28 PM, David Sterba wrote:
> On Wed, Dec 11, 2013 at 11:25:34AM -0500, Josef Bacik wrote:
>> @@ -5527,15 +5734,16 @@ again:
>>   	}
>>   	btrfs_release_path(&path);
>>   	while(1) {
>> -		ret = run_next_block(root, bits, bits_nr, &last, &pending,
>> -				     &seen, &reada, &nodes, &extent_cache,
>> -				     &chunk_cache, &dev_cache,
>> +		ret = run_next_block(trans, root, bits, bits_nr, &last,
>> +				     &pending, &seen, &reada, &nodes,
>> +				     &extent_cache, &chunk_cache, &dev_cache,
>>   				     &block_group_cache, &dev_extent_cache);
>>   		if (ret != 0)
>>   			break;
>>   	}
>>   
>> -	ret = check_extent_refs(trans, root, &extent_cache);
>> +	if (ret >= 0)
>> +		ret = check_extent_refs(trans, root, &extent_cache);
>>   	if (ret == -EAGAIN) {
>>   		ret = btrfs_commit_transaction(trans, root);
>>   		if (ret)
> This hunk conflicts with Gui Hecheng's patch
> "Btrfs-progs: fix btrfsck improper prompt on dropping snapshots"
>
> I applied the change where necessary, but haven't reviewed if this does
> not break the semantics. You may want to take a look.
>
As long as it passes make test it should be fine, I'll double check just 
in case.  Thanks,

Josef
