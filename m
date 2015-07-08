Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36286 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758919AbbGHUzC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 16:55:02 -0400
Received: by pacgz10 with SMTP id gz10so64095724pac.3
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 13:55:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADfjVrhammqPo68TTckaGA8p+=G=zdno_LLiSZQj=9xLq14WVg@mail.gmail.com>
References: <CAJCQCtSyf+ADvupbAoVi3BPN-TxdYr0n=-6gykWVe-U33rUNAQ@mail.gmail.com>
	<CADfjVrhammqPo68TTckaGA8p+=G=zdno_LLiSZQj=9xLq14WVg@mail.gmail.com>
Date: Wed, 8 Jul 2015 23:55:01 +0300
Message-ID: <CAFdkf7PA36kC-E0yaGYjWoU9igkT+KC+OT-pDi1-KRPDE3B=Jg@mail.gmail.com>
Subject: Re: [BUG] BTRFS: error in btrfs_run_delayed_refs:2821: errno=-5 IO failure
From: =?UTF-8?B?0J3QuNC60L7Qu9Cw0Lkg0J7QstGH0LjQvdC90LjQutC+0LI=?=
	<nik.ovchin@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like my case.
I also have some files over 1Gb ans skip defrag before balance.


2015-07-08 23:02 GMT+03:00 Noah Massey <noah.massey@gmail.com>:
> On Wed, Jul 8, 2015 at 10:01 AM, Chris Murphy <lists@colorremedies.com> wrote:
>> The short version: btrfs convert and subsequent balance will eat an
>> ext4 file system. I've reproduced this 6 for 6 times with both kernel
>> 4.1 and 4.2rc1, but I get different back traces for the two kernels.
>>
>> Kernel 4.1.0
>> Btrfs-progs 4.1
>>
>> New ext4 file system populated with several thousand files (Fedora 22
>> installation) and a 1.5GB ISO.
>>
>
> Standard disclaimer: Not a developer, just a user.
> The 1.5 GB ISO on a fresh ext4 system made me think of
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/36955
> (ext4 extents over 1 GB causing ENOSPC).
>
> Did the "btrfs filesystem balance" specify a "-t 900G" or similar?
>
> Or has that issue been fixed?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
