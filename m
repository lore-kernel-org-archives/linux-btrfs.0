Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33470 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbbDGPHX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 11:07:23 -0400
Received: by iebmp1 with SMTP id mp1so49300928ieb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 08:07:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK1hC9vDQ4j3CZ=7T30-Sg+Q8FYFOzntgmz57WMWRU5WELpDnA@mail.gmail.com>
References: <CAK1hC9skBYrM7nPyU-2mCuey6VkFOGMUCi0umYduX3ePNJ2mpg@mail.gmail.com>
	<CAK1hC9tBAvqOhGLGcX=1Ls2QwtaB6fe6Wzf89vH4=Y+kvxHR_Q@mail.gmail.com>
	<20150407110354.GH13864@carfax.org.uk>
	<CAK1hC9vDQ4j3CZ=7T30-Sg+Q8FYFOzntgmz57WMWRU5WELpDnA@mail.gmail.com>
Date: Tue, 7 Apr 2015 09:07:23 -0600
Message-ID: <CAJCQCtSogifUMSoc0r8KGLaRaadvzPXBzy+yQ40brCEEUz4WxA@mail.gmail.com>
Subject: Re: btrfs subvolume & default subvolume
From: Chris Murphy <lists@colorremedies.com>
To: arnaud gaboury <arnaud.gaboury@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 7, 2015 at 5:08 AM, arnaud gaboury <arnaud.gaboury@gmail.com> wrote:
> May you please tell why your recommendation is better
> than my settings, if I thereafter make root as the default sub-volume?

For what it's worth, the bootloader ignores the default subvolume and
so does the mount command anytime you use subvol= or subvol=id mount
options. I don't recommend relying on changing default subvolume to
something else on any volume used as root, it just gets confusing.

It makes sense for data drives, where you have a main subvolume that
you pretty much always want to mount by default, and then every so
often you can mount subvolid=5 to make a snapshot of that subvolume.
Yet a normal mount would always mount that main subvolume, not the top
level.

-- 
Chris Murphy
