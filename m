Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:45056 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751717AbdJBU1q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Oct 2017 16:27:46 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Why do full balance and deduplication reduce available free
 space?
To: =?UTF-8?Q?Niccol=c3=b2_Belli?= <darkbasic@linuxsystems.it>,
        linux-btrfs@vger.kernel.org
References: <49ec6395-19b4-46e0-83cf-806ef6cdd396@linuxsystems.it>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <eaf9395a-ce2e-fac1-f344-9328e2816318@libero.it>
Date: Mon, 2 Oct 2017 22:27:44 +0200
MIME-Version: 1.0
In-Reply-To: <49ec6395-19b4-46e0-83cf-806ef6cdd396@linuxsystems.it>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/02/2017 12:02 PM, Niccolò Belli wrote:
> Hi,
> I have several subvolumes mounted with compress-force=lzo and autodefrag. 
>> Since I use lots of snapshots (snapper keeps around 24 hourly snapshots, 7 daily 
> snapshots and 4 weekly snapshots) I had to create a systemd timer to perform a 
> full balance and deduplication each night. In fact data needs to be 
> already deduplicated when snapshots are created, otherwise I have no other way to deduplicate snapshots.


[...] 
> Data,single: Size:44.00GiB, Used:40.00GiB
>   /dev/sda5      44.00GiB
> 
> Metadata,single: Size:5.00GiB, Used:3.78GiB
>   /dev/sda5       5.00GiB
[...]

> Data,single: Size:41.00GiB, Used:40.01GiB
>   /dev/sda5      41.00GiB
> 
> Metadata,single: Size:5.00GiB, Used:3.77GiB
>   /dev/sda5       5.00GiB
[...]

> Data,single: Size:41.00GiB, Used:40.03GiB
>   /dev/sda5      41.00GiB
> 
> Metadata,single: Size:5.00GiB, Used:3.84GiB
>   /dev/sda5       5.00GiB
[...]

> Data,single: Size:41.00GiB, Used:40.04GiB
>   /dev/sda5      41.00GiB
> 
> Metadata,single: Size:5.00GiB, Used:3.97GiB
>   /dev/sda5       5.00GiB
[....]

 
> 
> It further reduced the available free space! Balance and deduplication actually reduced my available free space of 400MB!
> 400MB each night!

Your data increased by 40MB (over 40GB, so about ~0.1%); instead your metadata increased about 200MB (over ~4GB, about ~2%); so

1) it seems to me that your data is quite "deduped"
2) (NB this is a my guessing) I think that deduping (and or re-balancing) rearranges the metadata leading to a increase disk usage. The only explanation that I found is that the deduping breaks the sharing of metadata with the snapshots:
- a snapshot share the metadata, which in turn refers to the data. Because the metadata is shared, there is only one copy. The metadata remains shared, until it is not changed/updated.
- dedupe, when shares a file block, updates the metadata breaking the sharing with its snapshot, and thus creating a copy of these.
NB: updating snapshot metadata is the same that updating subvolume metadata


> How is it possible? Should I avoid doing balances and deduplications at all?

Try few days without deduplication, and check if something change. May be that it would be sufficient to delay the deduping: not each night, but each week or month.
Another option is running dedupe on all the files (including the snapshotted ones). In fact this would still break the metadata sharing, but the extents should still be shared (IMHO :-) ). Of course the cost of deduping will increasing a lot (about 24+7+4 = 35 times)


> 
> Thanks,
> Niccolò

BR
G.Baroncelli

> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
