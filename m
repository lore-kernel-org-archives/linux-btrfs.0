Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:55600
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbbIPOsM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 10:48:12 -0400
Subject: Re: [PATCH V2] Btrfs: keep dropped roots in cache until transaction
 commit
To: Glyn Normington <gnormington@pivotal.io>, linux-btrfs@vger.kernel.org
References: <CAA-6JZq+bL31eD5sxaLjwt41G68BzPjt=MJi4hTEgwvMXy3_ZA@mail.gmail.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <55F98128.9060509@googlemail.com>
Date: Wed, 16 Sep 2015 16:48:08 +0200
MIME-Version: 1.0
In-Reply-To: <CAA-6JZq+bL31eD5sxaLjwt41G68BzPjt=MJi4hTEgwvMXy3_ZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Glyn :)

On 09/16/15 16:31, Glyn Normington wrote:
> We are seeing a very similar problem fwiw. Unfortunately we can't
> reproduce this reliably, but it is cropping up regularly. Here's a
> chore we are using to track our work on this: [2].
> 
> Here's the kernel log:
> 
> [610194.395845] WARNING: CPU: 3 PID: 29166 at
> /build/linux-lts-vivid-BZwsXG/linux-lts-vivid-3.19.0/fs/btrfs/super.c:260
> __btrfs_abort_transaction+0x54/0x130 [btrfs]()

This is an entirely different problem and may have long been fixed;
I count at least 6 patches for tx aborts in my 4.1++ tree alone.
We're talking about patches that I can guarantee you are not running.

If Pivotal needs some help with stable btrfs backport fixes I might be
able to resurrect my old 3.19 patch queue (check my Github!), but this
is close to Zombie Olympics.. :)

cheers
Holger

