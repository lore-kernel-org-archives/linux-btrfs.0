Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:33616 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3LOU2H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Dec 2013 15:28:07 -0500
Received: by mail-la0-f54.google.com with SMTP id b8so2403632lan.27
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Dec 2013 12:28:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131215202456.GA11281@carfax.org.uk>
References: <CAAeznTpG6A7ygKg1AUx_pAMs_SNwG4a4C5gHPeT+HcKRsD+TWA@mail.gmail.com>
	<20131215202456.GA11281@carfax.org.uk>
Date: Sun, 15 Dec 2013 20:28:05 +0000
Message-ID: <CAAeznTryb7kyuvEyBFniv-UtGCQwdNtZMhpxm=-2MtKZSOj9Tw@mail.gmail.com>
Subject: Re: btrfs balance on single device
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        Leonidas Spyropoulos <artafinde@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 15, 2013 at 8:24 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sun, Dec 15, 2013 at 08:20:19PM +0000, Leonidas Spyropoulos wrote:
>> Hey all,
[..]
>> Anyone can explain me the Data row of the above output ? It used to be
>> 19.19GB and now it's 10.00GB. It's like the partition shrunk!? The
>> balance operation finished without issues.
>
>    It freed up some of the unused data chunks, returning them to the
> unallocated space on the device.
>
Oh, so the df report from btrfs doesn't show the total as 'free'! But
it means how much space the filesystem allocated so far.
>> Here's some other information:
>>
>> inglor@tiamat ~$ sudo btrfs filesystem show
>> Label: 'home'  uuid: 458c70e2-7037-4c4d-bba2-3d5288f04510
>>     Total devices 1 FS bytes used 9.56GB
>>     devid    1 size 21.00GB used 10.81GB path /dev/sda3
>
>    You can see that the filesystem is still the same size as before --
> it's just that less of it is allocated.
>
>    There's nothing to worry about here -- it's all working as expected.
>
>    Hugo.
>

Thanks Hugo for the explanation

Leonidas

-- 
Caution: breathing may be hazardous to your health.

#include <stdio.h>
int main(){printf("%s","\x4c\x65\x6f\x6e\x69\x64\x61\x73");}
