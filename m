Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36827 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbcFDBeN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 21:34:13 -0400
Received: by mail-oi0-f66.google.com with SMTP id x130so20121647oia.3
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 18:34:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGQ70YdK0XZeDB_J7ugcQj-c=UPYimo=MUGPTNy8oOVpi8H9GA@mail.gmail.com>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
	<aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
	<CAJCQCtQ4i0PWisxi708EmrTuPHH7hNEkKfY28GjTG2s4Sk3DYQ@mail.gmail.com>
	<CAGQ70YdK0XZeDB_J7ugcQj-c=UPYimo=MUGPTNy8oOVpi8H9GA@mail.gmail.com>
Date: Fri, 3 Jun 2016 19:34:11 -0600
Message-ID: <CAJCQCtS72NnR0f=m6zbdH-9BUMUgaa7QNzvUJaUce2DduJZQJg@mail.gmail.com>
Subject: Re: Recommended why to use btrfs for production?
From: Chris Murphy <lists@colorremedies.com>
To: Martin <rc6encrypted@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 3, 2016 at 8:11 AM, Martin <rc6encrypted@gmail.com> wrote:
>> Make certain the kernel command timer value is greater than the driver
>> error recovery timeout. The former is found in sysfs, per block
>> device, the latter can be get and set with smartctl. Wrong
>> configuration is common (it's actually the default) when using
>> consumer drives, and inevitably leads to problems, even the loss of
>> the entire array. It really is a terrible default.
>
> Are nearline SAS drives considered consumer drives?

No, they should have configurable sct erc setting using smartctl.
Many, possibly most, consumer drives now do not support it, so often
the only workable way to use them in any kind of multiple device
scenario other than linear/concat or raid0 is to significantly
increase the scsi command timer - upwards or 2 or 3 minutes. So if
your use case cannot tolerate such delays, then the drives must be
disqualified.



-- 
Chris Murphy
