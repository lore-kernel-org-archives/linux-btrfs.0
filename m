Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:36567 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab3JYCNw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 22:13:52 -0400
Message-ID: <5269D41A.6040802@cn.fujitsu.com>
Date: Fri, 25 Oct 2013 10:14:50 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Chris Mason <chris.mason@fusionio.com>
CC: Stefan Behrens <sbehrens@giantdisaster.de>,
        Bob Marley <bobmarley@shiftmail.org>,
        Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race condition between writting and scrubing
 supers
References: <1382156250-2336-1-git-send-email-wangshilong1991@gmail.com> <526247E3.9000804@giantdisaster.de> <CAP9B-Qncw5aCJzbQapy6i4iRrJ-mYh_yhkorY7+p9wZtzJodTQ@mail.gmail.com> <5262914D.7030306@giantdisaster.de> <B9B7D38F-3E92-4347-A41F-FA4D80D31745@gmail.com> <52663960.4060905@giantdisaster.de> <5266AE1F.6030304@shiftmail.org> <5268059E.707@giantdisaster.de> <20131024100842.14051.45479@localhost.localdomain> <5269053F.3050906@cn.fujitsu.com>
In-Reply-To: <5269053F.3050906@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	thu, 24 Oct 2013 19:32:15 +0800, Wang Shilong wrote:
> On 10/24/2013 06:08 PM, Chris Mason wrote:
>> Quoting Stefan Behrens (2013-10-23 13:21:34)
>>> On Tue, 22 Oct 2013 18:55:59 +0200, Bob Marley wrote:
>>>> On 22/10/2013 10:37, Stefan Behrens wrote:
>>>>> I don't believe that this issue can ever happen. I don't believe that
>>>>> somewhere on the path to the flash memory, to the magnetic disc or to
>>>>> the drive's cache memory, someone interrupts a 4KB write in the middle
>>>>> of operation to read from this 4KB area. This is not an issue IMHO.
>>>> I think I have read that unfortunately it can happen.
>>>> SAS and SATA specs for disks do not mandate that if a write is in-flight
>>>> but still not completed, reads from the same sector should return the
>>>> value it is being written; they can return the old value.
>>>> I also think that Linux does not check either.
>>> If the _old_ 4KB block is returned, that's fine and won't cause a
>>> checksum error.
>>>
>>> The patch in question addresses the case that Btrfs submits a write
>>> request for a 4KB block, and a concurrent read request for that 4KB
>>> block reads partially the old block and partially the new block,
>>> resulting in a checksum error reported in the scrub statistic counters.
>> Concurrent reads and writes to the device are completely undefined, and
>> Any combination of old, new, random memory corruption wouldn't
>> surprise me...I'd rather avoid them ;)
>>
>> Doing the transaction join during the super read is probably the least
>> complex choice.
> Yeah, by joining transaction we can solve this problem, but it is a little confused,
> because we don't involve writting in scrubing supers.
> 
> And the only race condition happens in commiting transaction, Miao also pointed out that
> maybe the best way is to move btrfs_scrub_continue after write_ctree_super().

Sorry, My miss.

btrfs_scrub_continue() is behind write_ctree_super() all the while, so the above problem
doesn't exist.

Thanks
Miao

> 
> Thanks,
> Wang
>> -chris
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

