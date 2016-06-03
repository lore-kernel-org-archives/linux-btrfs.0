Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35200 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377AbcFCPd6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 11:33:58 -0400
Received: by mail-io0-f194.google.com with SMTP id k19so10681713ioi.2
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 08:33:57 -0700 (PDT)
Subject: Re: Recommended why to use btrfs for production?
To: Martin <rc6encrypted@gmail.com>, Chris Murphy <lists@colorremedies.com>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
 <aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
 <CAJCQCtQ4i0PWisxi708EmrTuPHH7hNEkKfY28GjTG2s4Sk3DYQ@mail.gmail.com>
 <CAGQ70YdK0XZeDB_J7ugcQj-c=UPYimo=MUGPTNy8oOVpi8H9GA@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <156f60b2-d666-d553-194b-c09de041d476@gmail.com>
Date: Fri, 3 Jun 2016 11:33:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAGQ70YdK0XZeDB_J7ugcQj-c=UPYimo=MUGPTNy8oOVpi8H9GA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-03 10:11, Martin wrote:
>> Make certain the kernel command timer value is greater than the driver
>> error recovery timeout. The former is found in sysfs, per block
>> device, the latter can be get and set with smartctl. Wrong
>> configuration is common (it's actually the default) when using
>> consumer drives, and inevitably leads to problems, even the loss of
>> the entire array. It really is a terrible default.
>
> Are nearline SAS drives considered consumer drives?
>
If it's a SAS drive, then no, especially when you start talking about 
things marketed as 'nearline'.  Additionally, SCT ERC is entirely a SATA 
thing, I forget what the equivalent in SCSI (and by extension SAS) terms 
is, but I'm pretty sure that the kernel handles things differently there.
