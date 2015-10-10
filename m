Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:56992 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbbJJX6R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Oct 2015 19:58:17 -0400
Subject: Re: btrfs says no errors, but booting gives lots of errors
To: covici@ccs.covici.com
References: <8042.1444481164@ccs.covici.com> <56191CC2.9000505@googlemail.com>
 <11640.1444488108@ccs.covici.com> <561932EF.2090005@bouton.name>
 <5619385C.7040103@googlemail.com> <16953.1444496102@ccs.covici.com>
 <56198B7B.90806@bouton.name> <27402.1444518173@ccs.covici.com>
 <56199D79.4000204@bouton.name> <28329.1444519978@ccs.covici.com>
Cc: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <5619A615.3090503@bouton.name>
Date: Sun, 11 Oct 2015 01:58:13 +0200
MIME-Version: 1.0
In-Reply-To: <28329.1444519978@ccs.covici.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 11/10/2015 01:32, covici@ccs.covici.com a écrit :
> [...]
> I don't know if the file in question had the correct data, I only did a
> directory listing, but this makes no sense -- I did an rsync just before
> booting and got all kinds of errors and the only difference is the file
> system, this is what I am saying.

What makes no sense is that the same filesystem both shows the file is
there and isn't. If there was data corruption or buggy behaviour at
least it should be somehow consistent.
What is more likely is that the rsync was incomplete and didn't transfer
some data needed by systemd: did you transfer (from the top of my head)
extended attributes, special files, device files ? By default rsync
doesn't do that.

Lionel
