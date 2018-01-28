Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:47378 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751251AbeA1AjL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 19:39:11 -0500
Date: Sun, 28 Jan 2018 01:39:10 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: degraded permanent mount option
Message-ID: <20180128003910.GA31699@polanet.pl>
References: <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
 <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com>
 <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 27, 2018 at 15:22:38 +0000, Duncan wrote:

>> manages to mount degraded btrfs without problems.  They just don't try
>> to outsmart the kernel.
> 
> No kidding.
> 
> All systemd has to do is leave the mount alone that the kernel has 
> already done, instead of insisting it knows what's going on better than 
> the kernel does, and immediately umounting it.

Tell me please, if you mount -o degraded btrfs - what would
BTRFS_IOC_DEVICES_READY return?

This is not "outsmarting" nor "knowing better", on the contrary, this is "FOLLOWING the
kernel-returned data". The umounting case is simply a bug in btrfs.ko
that should change to READY state *if* someone has tried and apparently
succeeded mounting the not-ready volume.

Otherwise - how should any system part behave when you detach some drive? Insist
that "the kernel has already mounted it" and ignore kernel screaming
"the device is (not yet there/gone)"?


Just update the internal state after successful mount and this
particular problem is gone. Unless there is some race condition and the
state should be changed before the mount is announced to the userspace.

-- 
Tomasz Pala <gotar@pld-linux.org>
