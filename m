Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933295Ab3DKBlE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 21:41:04 -0400
Message-ID: <516614AD.3040303@redhat.com>
Date: Wed, 10 Apr 2013 20:41:01 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: Wang Shilong <wangshilong1991@gmail.com>,
        Olivier BATARD <obatard@icloud.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs prof compile error on debian squeeze.
References: <09F43135-B6BE-4549-A42C-52A340CD522B@icloud.com> <11DA7B81-2E09-41ED-9D25-DBEECC0555BB@gmail.com> <CAKcLGm-wjw6g3brNiB46iyYAzRvwB2zMoJ++mBmofOODQiz4oQ@mail.gmail.com>
In-Reply-To: <CAKcLGm-wjw6g3brNiB46iyYAzRvwB2zMoJ++mBmofOODQiz4oQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/10/13 7:28 PM, Mitch Harder wrote:
> We had a discussion on this topic in another thread.
> 
> I'd be happy to be corrected, but I think the conclusion was that you
> probably need to be on a really  modern version of Linux to work with
> the latest version of btrfs-progs that is in the kernel git
> repository.
> 
> The mkfs.btrfs version in the kernel git tree won't even work
> correctly on a kernel <= 3.7, and only partially works on the 3.8
> kernel.

Well, that needs to be fixed too, IMHO, and I think that's the plan?

For userspace, if we used autoconf, we could pretty easily turn off the
ssd code in btrfs for older systems.

We could probably use the older blkid interfaces to do the same thing
as well, but nobody's made it a priority yet.

-Eric

> On 4/10/13, Wang Shilong <wangshilong1991@gmail.com> wrote:
>> Hello,
>> Maybe this url will help you.
>>
>> https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories
>>
>> Thanks,
>> Wang
>>> Hello,
>>>
>>> I'm trying to build btrfs-prog on debian squeeze but when I'm trying to
>>> use make, I have an error :
>>>
>>>
>>> pc@debian:~/b/btrfs-progs$ make
>>>    [LD]     mkfs.btrfs
>>> mkfs.o: In function `is_ssd':
>>> /home/pc/b/btrfs-progs/mkfs.c:1234: undefined reference to
>>> `blkid_probe_get_wholedisk_devno'
>>> collect2: ld returned 1 exit status
>>> make: *** [mkfs.btrfs] Erreur 1
>>>
>>>
>>> After a few searches over the internet, it seems that my blkid library is
>>> out of date. How can I compile btrfs prog on debian squeeze ?
>>>
>>> Thanks !
>>>
>>>
>>> Olivier.--
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

