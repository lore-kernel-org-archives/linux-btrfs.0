Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53815 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753702AbaDXVrU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 17:47:20 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or newer?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <000001cf5ffb$84da9020$8e8fb060$@petrovi.no-ip.info>
Date: Thu, 24 Apr 2014 15:47:17 -0600
Cc: "'Marc MERLIN'" <marc@merlins.org>, <linux-btrfs@vger.kernel.org>
Message-Id: <E331F936-61DB-4D83-9203-0141827BC735@colorremedies.com>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <000501cf5fe1$55198590$ff4c90b0$@petrovi.no-ip.info> <20140424173317.GI7884@merlins.org> <002301cf5fee$346fefc0$9d4fcf40$@petrovi.no-ip.info> <20140424193117.GQ26949@merlins.org> <000001cf5ffb$84da9020$8e8fb060$@petrovi.no-ip.info>
To: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 24, 2014, at 2:26 PM, Пламен Петров <plamen@petrovi.no-ip.info> wrote:

>> -----Original Message-----
>> From: Marc MERLIN [mailto:marc@merlins.org]
>> You said using rootwait as recommended by Chris Mason did not help.
>> 
>> What output are you getting when you use this?
> 
> The image file attached to my previous mail applies to both rootwait and no-rootwait cases. Result is always a kernel panic for 3.14.x on BTRFS root. All other filesystem/kernel combos just work either way.

rootwait should mean it waits indefinitely for rootfs to appear, so why does it still kernel panic?

Is the root= parameter using UUID? If not can you try UUID instead of /dev/sda2? For Btrfs this is still the volume UUID, not subvolume UUID.



Chris Murphy

