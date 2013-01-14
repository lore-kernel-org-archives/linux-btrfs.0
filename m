Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58724 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab3ANLnu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 06:43:50 -0500
Received: by mail-lb0-f175.google.com with SMTP id gg13so2816946lbb.20
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2013 03:43:49 -0800 (PST)
Message-ID: <50F3EF72.4010603@gmail.com>
Date: Mon, 14 Jan 2013 11:43:46 +0000
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.ru>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs for files > 10GB = random spontaneous CRC failure.
References: <50F3E93D.7000707@gmail.com> <20130114172510.3874e898@natsu>
In-Reply-To: <20130114172510.3874e898@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14/01/13 11:25, Roman Mamedov wrote:
> Hello,
>
> On Mon, 14 Jan 2013 11:17:17 +0000
> Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:
>
>> this point I was a bit spooked up that my controllers are failing or
> Which controller manufacturer/model?
>
Well, this is a "home server" (which I preffer to tinker on). Two 
controllers were used, mother board build in, and crappy Adaptec pcie one.

00:11.0 SATA controller: Advanced Micro Devices [AMD] nee ATI 
SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
02:00.0 RAID bus controller: Adaptec Serial ATA II RAID 1430SA (rev 02)


ps. MoBo is: ASUS M4A79T Deluxe
