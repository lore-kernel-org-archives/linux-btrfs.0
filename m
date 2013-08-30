Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61708 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab3H3K5k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 06:57:40 -0400
Message-ID: <52207AD7.6010008@cn.fujitsu.com>
Date: Fri, 30 Aug 2013 18:58:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: allocate the free space by the existed max extent
 size when ENOSPC
References: <1377755258-2722-1-git-send-email-miaox@cn.fujitsu.com> <20130829124510.GH23113@twin.jikos.cz>
In-Reply-To: <20130829124510.GH23113@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	thu, 29 Aug 2013 14:45:10 +0200, David Sterba wrote:
> On Thu, Aug 29, 2013 at 01:47:38PM +0800, Miao Xie wrote:
>> By the current code, if the requested size is very large, and all the extents
>> in the free space cache are small, we will waste lots of the cpu time to cut
>> the requested size in half and search the cache again and again until it gets
>> down to the size the allocator can return. In fact, we can know the max extent
>> size in the cache after the first search, so we needn't cut the size in half
>> repeatedly, and just use the max extent size directly. This way can save
>> lots of cpu time and make the performance grow up when there are only fragments
>> in the free space cache.
>>
>> According to my test, if there are only 4KB free space extents in the fs,
>> and the total size of those extents are 256MB, we can reduce the execute
>> time of the following test from 5.4s to 1.4s.
>>   dd if=/dev/zero of=<testfile> bs=1MB count=1 oflag=sync
> 
> Sounds like a good improvement! Can you please post the test? Fragmented
> free space is nothing uncommon, so I guess aging the filesystem for a
> while works as well and there the improvement would show up in reduced
> cpu time.

# mkfs.btrfs -f -b 1g <dev>
# mount <dev> <mnt>
# cd <mnt>
# i=0
# while [ 1 ];
> do
> 	fallocate -o 0 -l 1M tmpfile_1M_$i
> 	if [ $? -ne 0 ]
> 	then
> 		break
> 	fi
> 	i=$((i+1))
> done
# dd if=/dev/zero of=tmpfile_4K bs=4K oflag=sync
# rm -f tmpfile_1M_{0..511}
# i=0
# while [ 1 ];
> do
> 	fallocate -o 0 -l 4K fragmented_file_4K_$i
> 	if [ $? -ne 0 ]
> 	then
> 		break
> 	fi
> 	i=$((i+1))
> done
# i=0
# while [ 1 ];
> do
> 	rm -f fragmented_file_4K_$i
> 	i=$((i+2))
> done

Now, we have a fs with 4K-fragmented free space, the free space is 256MB in total.
then, we can do

# dd if=/dev/zero of=<testfile> bs=1MB count=1 oflag=sync

Thanks
Miao
