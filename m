Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:36190 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbcFDAsZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 20:48:25 -0400
Received: by mail-qk0-f171.google.com with SMTP id i187so56260762qkd.3
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 17:48:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <156f60b2-d666-d553-194b-c09de041d476@gmail.com>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
 <aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com> <CAJCQCtQ4i0PWisxi708EmrTuPHH7hNEkKfY28GjTG2s4Sk3DYQ@mail.gmail.com>
 <CAGQ70YdK0XZeDB_J7ugcQj-c=UPYimo=MUGPTNy8oOVpi8H9GA@mail.gmail.com> <156f60b2-d666-d553-194b-c09de041d476@gmail.com>
From: Nicholas D Steeves <nsteeves@gmail.com>
Date: Fri, 3 Jun 2016 20:48:24 -0400
Message-ID: <CAD=QJKgqHBaUJXupFgzXR6jgC_LVacY4ZO58SYZOcmmfG_hdiA@mail.gmail.com>
Subject: Re: Recommended why to use btrfs for production?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Martin <rc6encrypted@gmail.com>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3 June 2016 at 11:33, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> On 2016-06-03 10:11, Martin wrote:
>>>
>>> Make certain the kernel command timer value is greater than the driver
>>> error recovery timeout. The former is found in sysfs, per block
>>> device, the latter can be get and set with smartctl. Wrong
>>> configuration is common (it's actually the default) when using
>>> consumer drives, and inevitably leads to problems, even the loss of
>>> the entire array. It really is a terrible default.
>>
>>
>> Are nearline SAS drives considered consumer drives?
>>
> If it's a SAS drive, then no, especially when you start talking about things
> marketed as 'nearline'.  Additionally, SCT ERC is entirely a SATA thing, I
> forget what the equivalent in SCSI (and by extension SAS) terms is, but I'm
> pretty sure that the kernel handles things differently there.

For the purposes of BTRFS RAID1: For drives that ship with SCT ERC of
7sec, is the default kernel command timeout of 30sec appropriate, or
should it be reduced?  For SATA drives that do not support SC TERC, is
it true that 120sec is a sane value?  I forget where I got this value
of 120sec; it might have been this list, it might have been an mdadm
bug report.  Also, in terms of tuning, I've been unable to find
whether the ideal kernel timeout value changes depending on RAID
type...is that a factor in selecting a sane kernel timeout value?

Kind regards,
Nicholas
