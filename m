Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:44477 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751159AbeA1IGK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Jan 2018 03:06:10 -0500
Received: by mail-lf0-f68.google.com with SMTP id v188so5580056lfa.11
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jan 2018 00:06:09 -0800 (PST)
Subject: Re: degraded permanent mount option
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <1516975360.4083556.1249069832.1B287A04@webmail.messagingengine.com>
 <5d342036-0de0-9bf7-3e9e-4885b62d8100@gmail.com>
 <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
 <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com>
 <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <7c95b4ae-f65e-b31d-f907-5eae5c60c49a@gmail.com>
Date: Sun, 28 Jan 2018 11:06:06 +0300
MIME-Version: 1.0
In-Reply-To: <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

27.01.2018 18:22, Duncan пишет:
> Adam Borowski posted on Sat, 27 Jan 2018 14:26:41 +0100 as excerpted:
> 
>> On Sat, Jan 27, 2018 at 12:06:19PM +0100, Tomasz Pala wrote:
>>> On Sat, Jan 27, 2018 at 13:26:13 +0300, Andrei Borzenkov wrote:
>>>
>>>>> I just tested to boot with a single drive (raid1 degraded), even
>>>>> with degraded option in fstab and grub, unable to boot !  The boot
>>>>> process stop on initramfs.
>>>>>
>>>>> Is there a solution to boot with systemd and degraded array ?
>>>>
>>>> No. It is finger pointing. Both btrfs and systemd developers say
>>>> everything is fine from their point of view.
>>
>> It's quite obvious who's the culprit: every single remaining rc system
>> manages to mount degraded btrfs without problems.  They just don't try
>> to outsmart the kernel.
> 
> No kidding.
> 
> All systemd has to do is leave the mount alone that the kernel has 
> already done,

Are you sure you really understand the problem? No mount happens because
systemd waits for indication that it can mount and it never gets this
indication.
