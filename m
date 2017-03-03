Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34867 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751482AbdCCN1x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Mar 2017 08:27:53 -0500
Received: by mail-io0-f173.google.com with SMTP id z13so29987806iof.2
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Mar 2017 05:27:30 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id j201sm804792ita.3.2017.03.03.04.19.11
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Mar 2017 04:19:12 -0800 (PST)
Subject: Re: raid1 degraded mount still produce single chunks, writeable mount
 not allowed
To: linux-btrfs@vger.kernel.org
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
 <20170302103753.x35jhe7xgnwl6ee6@angband.pl>
 <20170303065622.2a9a244e@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <88b27891-b3fc-eef6-d793-96fd32504818@gmail.com>
Date: Fri, 3 Mar 2017 07:19:06 -0500
MIME-Version: 1.0
In-Reply-To: <20170303065622.2a9a244e@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-03 00:56, Kai Krakow wrote:
> Am Thu, 2 Mar 2017 11:37:53 +0100
> schrieb Adam Borowski <kilobyte@angband.pl>:
>
>> On Wed, Mar 01, 2017 at 05:30:37PM -0700, Chris Murphy wrote:
>>> [1717713.408675] BTRFS warning (device dm-8): missing devices (1)
>>> exceeds the limit (0), writeable mount is not allowed
>>> [1717713.446453] BTRFS error (device dm-8): open_ctree failed
>>>
>>> [chris@f25s ~]$ uname -r
>>> 4.9.8-200.fc25.x86_64
>>>
>>> I thought this was fixed. I'm still getting a one time degraded rw
>>> mount, after that it's no longer allowed, which really doesn't make
>>> any sense because those single chunks are on the drive I'm trying to
>>> mount.
>>
>> Well, there's Qu's patch at:
>> https://www.spinics.net/lists/linux-btrfs/msg47283.html
>> but it doesn't apply cleanly nor is easy to rebase to current kernels.
>>
>>> I don't understand what problem this proscription is trying to
>>> avoid. If it's OK to mount rw,degraded once, then it's OK to allow
>>> it twice. If it's not OK twice, it's not OK once.
>>
>> Well, yeah.  The current check is naive and wrong.  It does have a
>> purpose, just fails in this, very common, case.
>
> I guess the reasoning behind this is: Creating any more chunks on this
> drive will make raid1 chunks with only one copy. Adding another drive
> later will not replay the copies without user interaction. Is that true?
>
> If yes, this may leave you with a mixed case of having a raid1 drive
> with some chunks not mirrored and some mirrored. When the other drives
> goes missing later, you are loosing data or even the whole filesystem
> although you were left with the (wrong) imagination of having a
> mirrored drive setup...
>
> Is this how it works?
>
> If yes, a real patch would also need to replay the missing copies after
> adding a new drive.
>
The problem is that that would use some serious disk bandwidth without 
user intervention.  The way from userspace to fix this is to scrub the 
FS.  It would essentially be the same from kernel space, which means 
that if you had a multi-TB FS and this happened, you'd be running at 
below capacity in terms of bandwidth for quite some time.  If this were 
to be implemented, it would have to be keyed off of the per-chunk 
degraded check (so that _only_ the chunks that need it get touched), and 
there would need to be a switch to disable it.
