Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from st11p05mm-asmtp001.mac.com ([17.172.108.236]:45037 "EHLO
	st11p05mm-asmtp001.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571Ab3DKQ0J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 12:26:09 -0400
Received: from [192.168.1.11]
 (ANantes-653-1-173-45.w109-211.abo.wanadoo.fr [109.211.48.45])
 by st11p05mm-asmtp001.mac.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Jan
  3 2012)) with ESMTPSA id <0ML300M0KMZJ7L50@st11p05mm-asmtp001.mac.com> for
 linux-btrfs@vger.kernel.org; Thu, 11 Apr 2013 16:26:08 +0000 (GMT)
Content-type: text/plain; charset=iso-8859-1
MIME-version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: btrfs prof compile error on debian squeeze.
From: Olivier BATARD <obatard@icloud.com>
In-reply-to: <516614AD.3040303@redhat.com>
Date: Thu, 11 Apr 2013 18:26:08 +0200
Message-id: <65A4DA2F-1478-4429-816F-2B60A6193764@icloud.com>
References: <09F43135-B6BE-4549-A42C-52A340CD522B@icloud.com>
 <11DA7B81-2E09-41ED-9D25-DBEECC0555BB@gmail.com>
 <CAKcLGm-wjw6g3brNiB46iyYAzRvwB2zMoJ++mBmofOODQiz4oQ@mail.gmail.com>
 <516614AD.3040303@redhat.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I agree with you. Debian package are out of date. I've chosen to change distribution, I switched to ArchLinux and everything is fine. And finally I don't like the way debian works anymore.

Thanks for your help.


Le 11 avr. 2013 à 03:41, Eric Sandeen <sandeen@redhat.com> a écrit :

> On 4/10/13 7:28 PM, Mitch Harder wrote:
>> We had a discussion on this topic in another thread.
>> 
>> I'd be happy to be corrected, but I think the conclusion was that you
>> probably need to be on a really  modern version of Linux to work with
>> the latest version of btrfs-progs that is in the kernel git
>> repository.
>> 
>> The mkfs.btrfs version in the kernel git tree won't even work
>> correctly on a kernel <= 3.7, and only partially works on the 3.8
>> kernel.
> 
> Well, that needs to be fixed too, IMHO, and I think that's the plan?
> 
> For userspace, if we used autoconf, we could pretty easily turn off the
> ssd code in btrfs for older systems.
> 
> We could probably use the older blkid interfaces to do the same thing
> as well, but nobody's made it a priority yet.
> 
> -Eric
> 
>> On 4/10/13, Wang Shilong <wangshilong1991@gmail.com> wrote:
>>> Hello,
>>> Maybe this url will help you.
>>> 
>>> https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories
>>> 
>>> Thanks,
>>> Wang
>>>> Hello,
>>>> 
>>>> I'm trying to build btrfs-prog on debian squeeze but when I'm trying to
>>>> use make, I have an error :
>>>> 
>>>> 
>>>> pc@debian:~/b/btrfs-progs$ make
>>>>   [LD]     mkfs.btrfs
>>>> mkfs.o: In function `is_ssd':
>>>> /home/pc/b/btrfs-progs/mkfs.c:1234: undefined reference to
>>>> `blkid_probe_get_wholedisk_devno'
>>>> collect2: ld returned 1 exit status
>>>> make: *** [mkfs.btrfs] Erreur 1
>>>> 
>>>> 
>>>> After a few searches over the internet, it seems that my blkid library is
>>>> out of date. How can I compile btrfs prog on debian squeeze ?
>>>> 
>>>> Thanks !
>>>> 
>>>> 
>>>> Olivier.--
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
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

