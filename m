Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:52499 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbcCEPjA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 10:39:00 -0500
Subject: Re: balance hangs and starts again on reboot
To: Marc Haber <mh+linux-btrfs@zugschlus.de>, linux-btrfs@vger.kernel.org
References: <20160304173125.GA1902@torres.zugschlus.de>
 <56D9CF63.3060603@googlemail.com> <20160305141707.GC1902@torres.zugschlus.de>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56DAFD91.2090805@googlemail.com>
Date: Sat, 5 Mar 2016 16:38:57 +0100
MIME-Version: 1.0
In-Reply-To: <20160305141707.GC1902@torres.zugschlus.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/05/16 15:17, Marc Haber wrote:
>> Then try to balance in small increments.
> 
> -dusage=5 and incrementing? Or what do you mean with "in small
> increments"?

Exactly, yes. Sorry for not being more clear.

FWIW I've been balancing a lot recently (both for stress testing and
cleaning up a few filesystems) and have never run into this particular
stall, but only ever do filtered balances. Also I wouldn't be surprised
at all if this is yet another problem where md does something in a way
that btrfs doesn' expect, and things go wrong.

-h

