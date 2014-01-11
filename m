Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:34028 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751149AbaAKBFk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jan 2014 20:05:40 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck does not fix
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52D08812.3040707@friedels.name>
Date: Fri, 10 Jan 2014 18:05:33 -0700
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com>
References: <52C7127F.3060902@friedels.name> <6E517D5F-B921-47E7-82E7-27865077C43D@colorremedies.com> <52C87B67.1040503@friedels.name> <F9C2788F-B057-4C3F-A490-8F8A19C37F97@colorremedies.com> <52CC65C9.3090605@friedels.name> <52D08812.3040707@friedels.name>
To: Hendrik Friedel <hendrik@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 10, 2014, at 4:53 PM, Hendrik Friedel <hendrik@friedels.name> wrote:

> Hello,
> 
> I was wondering whether I am doing something wrong in the way I am asking/what I am asking.
> My understanding is, that btrfsck is not able to fix this error yet. So, I am surprised, that noone is interested in this, apparently?


I don't know what the error messages mean, or why they aren't being fixed. It's known btrfs repair doesn't fix everything yet and can sometimes make problems worse.

Kernel version?
It mounts OK with no kernel messages?

What do you get for:
btrfs fi show
btrfs fi df <mp>

btrfs device stats </dev or mountpoint>

If there are any errors reported for device stats, what do you get for smartctl -x /dev/X


Chris Murphy