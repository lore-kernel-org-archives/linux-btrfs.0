Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:42466 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaFZVNx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jun 2014 17:13:53 -0400
Received: by mail-ve0-f176.google.com with SMTP id db12so4375349veb.35
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 14:13:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E167B73E-CE42-459E-9171-C9CF1D001D79@colorremedies.com>
References: <CACQTm-go5jGan9kP-dVq7Oi4b+AGWuFkb0Nudc2i9V1SG-oc3Q@mail.gmail.com>
	<20140625074713.GE31096@carfax.org.uk>
	<E167B73E-CE42-459E-9171-C9CF1D001D79@colorremedies.com>
Date: Thu, 26 Jun 2014 23:13:52 +0200
Message-ID: <CAK5rZE4Jm1w_WwvE8to0Mwg7=9V+_E=mUT+RxrxmVTz_zJC8Yw@mail.gmail.com>
Subject: Re: btrfs data dup on single device?
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/25/14, Chris Murphy <lists@colorremedies.com> wrote:
> On Jun 25, 2014, at 1:47 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>   The question is, why? If you have enough disk media errors to make
>> it worth using multiple copies, then your storage device is basically
>> broken and needs replacing, and it can't really be relied on for very
>> much longer.

> Yeah basically -d dup tells me the user believes "I do not trust the media
> that much". Specifically they believe the media surface variability is what
> they are suspicious of, not the read/write head, actuator, or spindle, or
> motor. And a.) I don't know how they can possibly have reliable information
> to arrive at this kind of suspicion; b.) why bother with such crap
> hardware?
> Chris Murphy


Does "Dup Metadata" need to tell anything to anyone?

Regards, Imran
