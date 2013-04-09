Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:44441 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab3DIBvZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Apr 2013 21:51:25 -0400
Message-ID: <5163746A.50902@cn.fujitsu.com>
Date: Tue, 09 Apr 2013 09:52:42 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org, martin.krizek@gmail.com
Subject: Re: [PATCH 1/2] Btrfs: online data deduplication
References: <1365340369-23537-1-git-send-email-bo.li.liu@oracle.com> <1365340369-23537-2-git-send-email-bo.li.liu@oracle.com> <20130408134726.GD18193@twin.jikos.cz>
In-Reply-To: <20130408134726.GD18193@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	mon, 8 Apr 2013 15:47:27 +0200, David Sterba wrote:
> On Sun, Apr 07, 2013 at 09:12:48PM +0800, Liu Bo wrote:
>> (2) WHAT is deduplication?
>>     Two key ways for practical deduplication implementations,
>>     *  When the data is deduplicated
>>        (inband vs background)
>>     *  The granularity of the deduplication.
>>        (block level vs file level)
>>
>>     For btrfs, we choose
>>     *  inband(synchronous)
>>     *  block level
> 
> Block level may be too fine grained leading to excessive fragmentation
> and increased metadata usage given that there's a much higher chance to
> find duplicate (4k) blocks here and there.
> 
> There's always a tradeoff, the practical values that are considered for
> granularity range from 8k to 64, see eg. this paper for graphs and analyses
> 
> http://static.usenix.org/event/fast11/tech/full_papers/Meyer.pdf .
> 
> This also depends on file data type and access patterns, fixing the dedup
> basic chunk size to one block does not IMHO fit most usecases.

Maybe we can make btrfs(including dedup) support the bigalloc just like ext4.

Thanks
Miao

> 
>> (3) HOW does deduplication works?
> ...
>>     Here we have
>>     a)  a new dedicated tree(DEDUP tree) and
>>     b)  a new key(BTRFS_DEDUP_ITEM_KEY), which consists of
>>         (stop 64bits of hash, type, disk offset),
>>         *  stop 64bits of hash
>>            It comes from sha256, which is very helpful on avoiding collision.
>>            And we take the stop 64bits as the index.
> 
> Is it safe to use just 64 bits? I'd like to see better reasoning why
> this is ok. The limitation of btrfs_key to store only 1-2 64bit items is
> clear and must be handled, but it's IMO a critical design point.
> 
>>         *  disk offset
>>            It helps to find where the data is stored.
> 
> Does the disk offset also help to resolving block hash collisions?
> 
>>     So the whole deduplication process works as,
>>     1) write something,
>>     2) calculate the hash of this "something",
>>     3) try to find the match of hash value by searching DEDUP keys in
>>        a dedicated tree, DEDUP tree.
>>     4) if found, skip real IO and link to the existing copy
>>        if not, do real IO and insert a DEDUP key to the DEDUP tree.
> 
> ... how are the hash collisions handled? Using part of a secure has
> cannot be considered equally strong (given that there is not other
> safety checks like comparing the whole blocks).
> 
> Last but not least, there was another dedup proposal (author CCed)
> 
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/21722
> 
> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

