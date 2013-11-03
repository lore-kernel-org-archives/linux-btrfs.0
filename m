Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout08.t-online.de ([194.25.134.20]:55926 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3KCLvQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Nov 2013 06:51:16 -0500
Date: Sun, 3 Nov 2013 12:50:24 +0100
From: "Matthias G. Eckermann" <matthias.g.eckermann@t-online.de>
To: David Madden <dhm@mersenne.com>, linux-btrfs@vger.kernel.org
Subject: Re: OK to take hourly snapshots, then cull older ones?
Message-ID: <20131103115024.GA5139@t-online.de>
Reply-To: "Matthias G. Eckermann" <matthias.g.eckermann@t-online.de>
References: <525CBF0D.1020609@mersenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <525CBF0D.1020609@mersenne.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello David and all,

On Mon, Oct 14, 2013 at 21:05 David Madden wrote:

> I'd like to use BTRFS to do something like the old NetApp
> snapshot system: every hour or so, there'd be a snapshot,
> then the 23 of the snapshots during a day would be
> deleted, leaving just a day snapshot, then after a month,
> 6 of 7 snapshots would be deleted, leaving just a week
> snapshot, and so on.

This is implemented in "Snapper", see:
	http://snapper.io/
It's by default delivered with openSUSE and SUSE Linux
Enterprise, binaries are available for "everything else"
as well.
 
> Is this a reasonable thing to do in a cron job with a
> BTRFS filesystem?  Apart from running out of space, are
> there any resources that might get used up?  Has anybody
> done this for a year or two in an active filesystem, and
> encountered success or weirdness?

Space is _the_ main issue. If you want automated comparison
of snapshots, you'll also need some CPU time in addition.

Enjoy.

so long -
	MgE

