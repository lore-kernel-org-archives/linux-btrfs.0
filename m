Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36118 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756421AbcH2G5A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 02:57:00 -0400
Received: by mail-lf0-f43.google.com with SMTP id g62so93878303lfe.3
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 23:56:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <12b26fc1-4586-0cd1-8359-acf9ac5eb42f@cn.fujitsu.com>
References: <CAJF-kYko=dSuCmxpj6uJmKRZtAOhYCzoK=8hoyqBAe5UA8nQUg@mail.gmail.com>
 <12b26fc1-4586-0cd1-8359-acf9ac5eb42f@cn.fujitsu.com>
From: Lukas Lueg <lukas.lueg@gmail.com>
Date: Mon, 29 Aug 2016 08:56:20 +0200
Message-ID: <CAJF-kY=a+i=97m8e=R8ipHTAxQOSbjG5bHBF_tQntjCHHQyFqA@mail.gmail.com>
Subject: Re: Multiple bugs found by fuzzing BTRFS
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I will let the current setup run for another 200 hours and deal with
low memory mode then. Having had a quick glance at it, at least some
of the bugs mentioned above show up and should get fix beforehand.

2016-08-29 8:20 GMT+02:00 Qu Wenruo <quwenruo@cn.fujitsu.com>:
> Thanks for your fuzzing images.
>
> Quite helpful.
>
> At 08/29/2016 02:06 PM, Lukas Lueg wrote:
>>
>> Hi,
>>
>> I've now spent around 160 hours of fuzzing BTRFS, here are the crashes
>> I found so far. Every type of crash is reported only once although
>> there are usually multiple locations where they show up (especially
>> heap-use-after-free and calls to abort()).
>>
>> The following bug reports have attached to them images of ±18kb which
>> expand to 16mb and reproduce a crash when running btrfsck; they all
>> have been revirginized so CRC- and FSID-checks pass by a vanilla
>> btrfsck.
>>
>>
>> Use-after-free, shows up all over the place:
>> https://bugzilla.kernel.org/show_bug.cgi?id=153641
>>
>> Segfault in memcpy, yeah:
>> https://bugzilla.kernel.org/show_bug.cgi?id=154021
>>
>> Run-off-the-mill buffer-overflow:
>> https://bugzilla.kernel.org/show_bug.cgi?id=154961
>>
>> Endless loop in btrfsck:
>> https://bugzilla.kernel.org/show_bug.cgi?id=155151
>>
>> Calls to abort() by lack of error paths:
>> https://bugzilla.kernel.org/show_bug.cgi?id=155181
>>
>> Division by zero, the old problem of computing stripe_size:
>> https://bugzilla.kernel.org/show_bug.cgi?id=155201
>
>
> Digging, while it's a little different from the original one.
>
> BTW, for btrfsck bugs, would you please also try the new low memory mode?
> For example, the above image won't trigger bug in low memory mode.
>
> Thanks,
> Qu
>>
>>
>>
>> There are many more crashes like the above; how do you guys want them
>> to be reported?
>>
>>
>> Best regards
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
