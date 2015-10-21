Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34149 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbbJUJxz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 05:53:55 -0400
Received: by wikq8 with SMTP id q8so85145690wik.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 02:53:54 -0700 (PDT)
Received: from centurion (77-173-215-182.ip.telfort.nl. [77.173.215.182])
        by smtp.gmail.com with ESMTPSA id x9sm9264671wjf.44.2015.10.21.02.53.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Oct 2015 02:53:52 -0700 (PDT)
Received: from [127.0.0.1] (localhost [IPv6:::1])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by centurion (Postfix) with ESMTPSA id 6379714212A
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 11:53:50 +0200 (CEST)
Message-ID: <562760DC.1050904@gmail.com>
Date: Wed, 21 Oct 2015 11:54:36 +0200
From: Dmitry Katsubo <dmitry.katsubo@gmail.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How to remove missing device on RAID1?
References: <CAM9fjH6M2yqSiqXbT4DBvHbQGq9Cdw-wzMvsYkztPSsQG=PLqQ@mail.gmail.com> <pan$55e2$eeada9c5$c7289131$4f093ca1@cox.net> <CAM9fjH6pcwZKWryNrJay_N98wmXWVXXqo3HJuupbJRE3MC9YKQ@mail.gmail.com> <BLU436-SMTP11853633E0AF118E66934D6A9390@phx.gbl>
In-Reply-To: <BLU436-SMTP11853633E0AF118E66934D6A9390@phx.gbl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-10-21 00:40, Henk Slager wrote:
> I had a similar issue some time ago, around the time kernel 4.1.6 was
> just there.
> In case you don't want to wait for new disk or decide to just run the
> filesystem with 1 disk less or maybe later on replace 1 of the still
> healthy disks with a double/bigger sized one and use current/older
> kernel+tools, you could do this (assuming the filesystem is not too
> full of course):
> - mount degraded
> - btrfs balance start -f -v -sdevid=1 -sdevid=1 -sdevid=1 <mountpoint>
>   (where missing disk has devid 1)

Am I right that one can "btrfs dev delete 1" after balance succeeded?

> After completion the (virtual/missing) device shall be fully unallocated
> - create /dev/loopX with sparse file of same size as missing disk on
> some other filesystem
> - btrfs replace start 1 /dev/loopX <mountpoint>
> - remove /dev/loopX from the filesystem
> - remount filesystyem without degraded
> And remove /dev/loopX

If would be nice if btrfs allows to delete device and perform rebalance
automatically (provided that left devices still have enough space to
sustain raidX prerequisite).

-- 
With best regards,
Dmitry
