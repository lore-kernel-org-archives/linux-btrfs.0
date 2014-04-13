Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:38951 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaDMOQX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 10:16:23 -0400
Received: by mail-ve0-f170.google.com with SMTP id pa12so6745001veb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Apr 2014 07:16:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7616233.4PhybLsPIr@merkaba>
References: <4392627.HWimVooIO4@tethys>
	<7616233.4PhybLsPIr@merkaba>
Date: Sun, 13 Apr 2014 10:16:22 -0400
Message-ID: <CAFvQSYT=1z4iENu8xLnBLvVTqUzYfZazY1acnFvUEz_FO-Gf4w@mail.gmail.com>
Subject: Re: Rebalance makes BTRFS 10x slower
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> I also found this to be the case as I rebalanced the root filesystem of my
> Debian installation on this ThinkPad T520 on an Intel SSD 320.

Same here, I ran balance on kernel-3.12 some time ago and after
balancing performance dropped noticeable and stayed there.
When booting natively I can see the HDD activity led lid for 10+
seconds (Samsung 830 SSD), working with the same system in virtualbox
using direct device access is a real pain.

Non of the measures I took (re-balance, fstrim, defraging all files on
the volume, ...) had mentionable impact.

Regards, Clemens
