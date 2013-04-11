Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:50295 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934997Ab3DKA25 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 20:28:57 -0400
Received: by mail-oa0-f41.google.com with SMTP id f4so1027178oah.28
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2013 17:28:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <11DA7B81-2E09-41ED-9D25-DBEECC0555BB@gmail.com>
References: <09F43135-B6BE-4549-A42C-52A340CD522B@icloud.com>
	<11DA7B81-2E09-41ED-9D25-DBEECC0555BB@gmail.com>
Date: Wed, 10 Apr 2013 19:28:57 -0500
Message-ID: <CAKcLGm-wjw6g3brNiB46iyYAzRvwB2zMoJ++mBmofOODQiz4oQ@mail.gmail.com>
Subject: Re: btrfs prof compile error on debian squeeze.
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: Olivier BATARD <obatard@icloud.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We had a discussion on this topic in another thread.

I'd be happy to be corrected, but I think the conclusion was that you
probably need to be on a really  modern version of Linux to work with
the latest version of btrfs-progs that is in the kernel git
repository.

The mkfs.btrfs version in the kernel git tree won't even work
correctly on a kernel <= 3.7, and only partially works on the 3.8
kernel.

On 4/10/13, Wang Shilong <wangshilong1991@gmail.com> wrote:
> Hello,
> Maybe this url will help you.
>
> https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories
>
> Thanks,
> Wang
>> Hello,
>>
>> I'm trying to build btrfs-prog on debian squeeze but when I'm trying to
>> use make, I have an error :
>>
>>
>> pc@debian:~/b/btrfs-progs$ make
>>    [LD]     mkfs.btrfs
>> mkfs.o: In function `is_ssd':
>> /home/pc/b/btrfs-progs/mkfs.c:1234: undefined reference to
>> `blkid_probe_get_wholedisk_devno'
>> collect2: ld returned 1 exit status
>> make: *** [mkfs.btrfs] Erreur 1
>>
>>
>> After a few searches over the internet, it seems that my blkid library is
>> out of date. How can I compile btrfs prog on debian squeeze ?
>>
>> Thanks !
>>
>>
>> Olivier.--
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
