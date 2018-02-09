Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i6.italiaonline.it ([213.209.14.17]:55215 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751140AbeBIRCE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Feb 2018 12:02:04 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH RFC] Btrfs: expose bad chunks in sysfs
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
References: <20180205231502.12900-1-bo.li.liu@oracle.com>
 <cfd107b0-e08d-775d-9b46-3cc49e587242@libero.it>
 <20180208190714.GC9008@lim.localdomain>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <5c754f5f-5f16-1c9c-4a0e-c9c5c55cdc60@inwind.it>
Date: Fri, 9 Feb 2018 18:02:01 +0100
MIME-Version: 1.0
In-Reply-To: <20180208190714.GC9008@lim.localdomain>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/08/2018 08:07 PM, Liu Bo wrote:
> On Thu, Feb 08, 2018 at 07:52:05PM +0100, Goffredo Baroncelli wrote:
>> On 02/06/2018 12:15 AM, Liu Bo wrote:
>> [...]
>>> One way to mitigate the data loss pain is to expose 'bad chunks',
>>> i.e. degraded chunks, to users, so that they can use 'btrfs balance'
>>> to relocate the whole chunk and get the full raid6 protection again
>>> (if the relocation works).
>>
>> [...]
>> [...]
>>
>>> +
>>> +	/* read lock please */
>>> +	do {
>>> +		seq = read_seqbegin(&fs_info->bc_lock);
>>> +		list_for_each_entry(bc, &fs_info->bad_chunks, list) {
>>> +			len += snprintf(buf + len, PAGE_SIZE - len, "%llu\n",
>>> +					bc->chunk_offset);
>>> +			/* chunk offset is u64 */
>>> +			if (len >= PAGE_SIZE)
>>> +				break;
>>> +		}
>>> +	} while (read_seqretry(&fs_info->bc_lock, seq));
>>
>> Using this interface, how many chunks can you list ? If I read the code correctly, only up to fill a kernel page.
>>
>> If my math are correctly (PAGE_SIZE=4k, a u64 could require up to 19 bytes) it is possible to list only few hundred of chunks (~200). Not more; and the last one could be even listed incomplete.
>>
> 
> That's true.
> 
>> IIRC a chunk size is max 1GB; If you lost a 500GB of disks, the chunks to list could be more than 200.
>>
>> My first suggestion is to limit the number of chunks to show to 200 (a page should be big enough to contains all these chunks offset). If the chunks number are greater, ends the list with a marker (something like '[...]\n').
>> This would solve the ambiguity about the fact that the list chunks are complete or not. Anyway you cannot list all the chunks.
>>
> 
> Good point, and I need to add one more field to each record to specify
> it's metadata or data.
> 
> So what I have in my mind is that this kind of error is rare and
> reflects bad sectors on disk, but if there are really that many
> errors, I think we need to replace the disk without hesitation.

What happens if you loose an entire disk ? If so, you fill "bad_sector"


> 
>> However, my second suggestions is to ... change completely the interface. What about adding a directory in sysfs, where each entry is a chunk ?
>>
>> Something like:
>>
>> /sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/type		# data/metadata/sys
>> /sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/profile		# dup/linear....
>> /sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/size		# size
>> /sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/devs		# chunks devs 
>>
>> And so on. 
>>
>> Checking  "[...]<chunks-offset>/devs", it would be easy understand if the chunk is in "degraded" mode or not.
> 
> I'm afraid we cannot do that as it'll occupy too much memory for large
> filesystems given a typical chunk size is 1GB.
> 
>>
>> However I have to admit that I don't know how feasible is iterate over a sysfs directory which is a map of a kernel objects list.
>>
>> I think that if these interface would be good enough, we could get rid of a lot of ioctl(TREE_SEARCH) from btrfs-progs. 
>>
> 
> TREE_SEARCH is faster than iterating sysfs (if we could), isn't it?

Likely yes. However TREE_SEARCH is bad because it is hard linked to the filesystem structure. I.e. if for some reason BTRFS change the on disk layout, what happens for the old application which expect the previous disk format ? And for the same reason, it is root-only (UID==0)

Let me to give another idea: what about exporting these information via an ioctl ? It could be extended to query all information about (all) the chunks...

> 
> thanks,
> -liubo
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
