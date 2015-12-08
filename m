Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:48643
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965277AbbLHPhr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 10:37:47 -0500
Subject: Re: Scrub: no spae left on device
To: Marc MERLIN <marc@merlins.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20151208150638.GL27889@merlins.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <5666F947.5010902@googlemail.com>
Date: Tue, 8 Dec 2015 16:37:43 +0100
MIME-Version: 1.0
In-Reply-To: <20151208150638.GL27889@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/08/15 16:06, Marc MERLIN wrote:
> Howdy,
> 
> Why would scrub need space and why would it cancel if there isn't enough of
> it?
> (kernel 4.3)
> 
> /etc/cron.daily/btrfs-scrub:
> btrfs scrub start -Bd /dev/mapper/cryptroot
> scrub device /dev/mapper/cryptroot (id 1) done
> 	scrub started at Mon Dec  7 01:35:08 2015 and finished after 258 seconds
> 	total bytes scrubbed: 130.84GiB with 0 errors
> btrfs scrub start -Bd /dev/mapper/pool1
> ERROR: scrubbing /dev/mapper/pool1 failed for device id 1 (No space left on device)
> scrub device /dev/mapper/pool1 (id 1) canceled

Scrub rewrites metadata (apparently even in -r aka readonly mode), and that
can lead to temporary metadata expansion (stuff gets COWed around); it's
a bit surprising but makes sense if you think about it. The fact that you
ENOSPCed means that the fs was probably already fully allocated.

If it bothers you, a subsequent balance with -musage=10 should vacuum things
up. Alternatively just keep using the filesystem; eventually the empty metadata
chunks should be collected, on the next remount at the latest.

tl;dr: Never allocate all the chunks. Yes, this needs more graceful handling.

-h

