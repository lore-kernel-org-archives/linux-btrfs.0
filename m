Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34427 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab3HXUaG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Aug 2013 16:30:06 -0400
Received: by mail-wi0-f175.google.com with SMTP id cb5so509500wib.2
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Aug 2013 13:30:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0e13ab74252d33d24ad58591b7b0f6fb@lixil.net>
References: <25d36b2410416c9a767766fb9be313b6@lixil.net>
	<093e4c7d21b5e734c86fc4bb1703a69e@lixil.net>
	<0e13ab74252d33d24ad58591b7b0f6fb@lixil.net>
Date: Sat, 24 Aug 2013 16:30:04 -0400
Message-ID: <CAPs0BijKPr7Df-42dQC=ydA9xzEaEvk1XMFP-dYKqBuzrNvmAA@mail.gmail.com>
Subject: Re: Help interpreting RAID1 space allocation
From: Sandy McArthur <sandymac@gmail.com>
To: Joel Johnson <mrjoel@lixil.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 24, 2013 at 2:02 PM, Joel Johnson <mrjoel@lixil.net> wrote:
> On 2013-08-24 11:24, Joel Johnson wrote:
>>
>> Should I file a few bugs to capture the related issues? Here are the
>> discrete issues that seem to be present from a user point of view:
>
>
> After writing this, I figured I'd experiment with the current state and try
> to properly delete and add the sdd device. However, I was surprised to find
> that I'm not allowed to remove one of the two drives in a RAID1. Kernel
> message is "btrfs: unable to go below two devices on raid1" Not allowing it
> by default makes some sense, however a --force flag or something would be
> beneficial. I understand that the preferred method is to add the replacement
> device first and then delete the old one (or do a direct replace), however
> the system I'm using for testing only has three SATA ports, the first is
> used for the system drive, and the second and third have the two drives I'm
> using for my btrfs testing - I have no way to add a third drive for the
> filesystem before removing one first. This is still with the filesystem
> mounted with the degraded mount option set.

If you have an USB enclosure you could connect another drive via USB
temporarily.
That said my biggest btrfs problem happened while I had some drives on
SATA and others on USB.

-- 
Sandy McArthur
