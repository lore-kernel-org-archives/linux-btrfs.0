Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33296 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbcABT5y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jan 2016 14:57:54 -0500
Received: by mail-io0-f173.google.com with SMTP id q21so125618457iod.0
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jan 2016 11:57:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1451764030.3014437.481190514.24FF8F10@webmail.messagingengine.com>
References: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net>
	<CAJCQCtSCJ91FaJ20g-+TKMwGkXeQdEkn1yDf6w+H3=V_8_xshA@mail.gmail.com>
	<1451679613.2761176.480641362.3ADA17DB@webmail.messagingengine.com>
	<1451729336.2917121.480913242.132825EE@webmail.messagingengine.com>
	<13CBB600-0779-40B7-BD20-ED571A3336D7@rasmusa.net>
	<3147B5E0-34C1-40F5-953A-7A40D1F28C51@rasmusa.net>
	<1451764030.3014437.481190514.24FF8F10@webmail.messagingengine.com>
Date: Sat, 2 Jan 2016 12:57:54 -0700
Message-ID: <CAJCQCtSyYDgtUsPcTig11bGWq=f8rksTYXMtmW_FwdsRGCA=gQ@mail.gmail.com>
Subject: Re: Add big device, remove small device, read-only
From: Chris Murphy <lists@colorremedies.com>
To: Rasmus Abrahamsen <btrfs@rasmusa.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 2, 2016 at 12:47 PM, Rasmus Abrahamsen <btrfs@rasmusa.net> wrote:
> The scrub was frozen. I tried to cancel it but it had become read-only.
> I rebooted and am now looking into what btrfsck can do for me

Stay away from btrfs check --repair until it's a last restort. As in,
you have to have all data scraped off the volume before you decide to
use it. It's gotten a lot better at not making things worse, but I
still don't trust it.


-- 
Chris Murphy
