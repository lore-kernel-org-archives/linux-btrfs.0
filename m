Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:65332 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaAJAIX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 19:08:23 -0500
Received: by mail-ob0-f177.google.com with SMTP id vb8so3987742obc.8
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 16:08:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52CF2F9D.4080504@chinilu.com>
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>
	<20140109104247.GH15634@carfax.org.uk>
	<3A9CDBC9-ACFF-43E3-AFB9-33A6FFE7FB35@colorremedies.com>
	<BAY172-W37E3465B365B9EA9C2AA4FB0B00@phx.gbl>
	<75CB34F7-0BC3-47B7-8817-94F74BC5FD18@colorremedies.com>
	<52CF2F9D.4080504@chinilu.com>
Date: Thu, 9 Jan 2014 19:08:22 -0500
Message-ID: <CAFvQSYRDbdDaJDAUVuUq9pqh+EryJO_=jZGjEEedSOVj71SS+g@mail.gmail.com>
Subject: Re: How does btrfs handle bad blocks in raid1?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi George,

> I really suspect a lot of bad block issues can be avoided by monitoring
> SMART data.  SMART is working very well for me with btrfs formatted drives.
> SMART will detect when sectors silently fail and as those failures
> accumulate, SMART will warn in an obvious way that the drive in question is
> at end of life.  So I think the whole bad block issue should ideally be
> handled at a lower level than filesystem with modern hard drives.

At least my original request was about cheap flash media, where you
don't have the luxury that you can "trust" the hardware behaving
properly. In fact, it might be benefitial for a SD card to not report
ECC errors - most likely the user won't notice a small glitch playing
back music - but he definitively will when the smartphone reports read
errors and stopping playback which will cause that card to be RMAd.

Also, wouldn't your argument be also valid for checksums - why
checksum in software, when in theory the drive + controllers should do
it anyway ;)

Regards, Clemens
