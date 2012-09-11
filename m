Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:42231 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab2IKPBL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 11:01:11 -0400
Message-ID: <504F5225.6050404@oracle.com>
Date: Tue, 11 Sep 2012 23:00:53 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: dave@jikos.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Btrfs: snapshot-aware defrag
References: <1346893852-9815-1-git-send-email-bo.li.liu@oracle.com> <1346893852-9815-2-git-send-email-bo.li.liu@oracle.com> <20120910234911.GU17430@twin.jikos.cz>
In-Reply-To: <20120910234911.GU17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/11/2012 07:49 AM, David Sterba wrote:
> On Thu, Sep 06, 2012 at 09:10:52AM +0800, Liu Bo wrote:
>> This comes from one of btrfs's project ideas,
>> As we defragment files, we break any sharing from other snapshots.
>> The balancing code will preserve the sharing, and defrag needs to grow this
>> as well.
>>
>> Now we're able to fill the blank with this patch, in which we make full use of
>> backref walking stuff.
>>
>> Here is the basic idea,
>> o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
>> o  at endio, after we finish updating fs tree, we use backref walking to find
>>    all parents of the ranges and re-link them with the new COWed file layout by
>>    adding corresponding backrefs.
>>
>> Original-Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> This is a non-standard tag, I think Li will not object against
> Signed-off-by as his original submission covers most of this patch. And
> more S-O-B lines is allowed and understood.
> 

So I googled for a standard tag 'Original-patch-by' suggested by Tejun Heo, is it ok?

>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> ---
>> v2: rebase against the latest btrfs-repo
>>

>> +		if (btrfs_file_extent_disk_bytenr(leaf, fi) == new->bytenr &&
>> +		    btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_REG &&
>> +		    !btrfs_file_extent_compression(leaf, fi) &&
>> +		    !btrfs_file_extent_encryption(leaf, fi) &&
>> +		    !btrfs_file_extent_other_encoding(leaf, fi) &&
>> +		    extent_len + found_key.offset == start) {
> 
> so no cow-aware defrag for compressed files?
> 

hmm, it just disable merging adjacent compressed extents, and it may leave some space to improve.

> 
> general notes:
> * the error handling or reporting could be improved, I wouldn't mind the
>   more WARN_ONs or BUG_ONs for testing purposes, but for a finalized
>   versiont the practice of transaction abort or at least an attempt to
>   minimize number of BUG_ONs should be done
> * I didn't review the math over the extent lengths and starts
> 
> ohterwise ok, passed 1st round :)
> 
> david
> 

Will address the comments in a new version.

I'd say a huge thank you for reviewing this :)

thanks,
liubo

