Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:52573 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab2G3Iq2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 04:46:28 -0400
Message-ID: <501649E3.6010600@jan-o-sch.net>
Date: Mon, 30 Jul 2012 10:46:27 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Konstantin Dmitriev <ksee.zelgadis@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: severe hardlink bug
References: <20100124015138.092c4959@simplux> <201001240909.44753.kreijack@libero.it> <20100124140837.5efcd526@simplux> <201001241415.47519.kreijack@inwind.it> <20100124142711.4afe8a81@simplux> <loom.20120729T205902-38@post.gmane.org>
In-Reply-To: <loom.20120729T205902-38@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Konstantin,

On Sun, July 29, 2012 at 21:02 (+0200), Konstantin Dmitriev wrote:
> Dipl.-Ing. Michael Niederle <mniederle <at> gmx.at> writes:
> 
>> I reinstalled over 700 packages - plt-scheme beeing the only one failing due to
>> the btrfs link restriction.
>>
> 
> I have hit the same issue - tried to run BackupPC with a pool on btrfs
> filesystem. After some time the error of "too many links (31)" appeared to me.
> Now I'm forced to migrate to some other filesystem...

Please give the patch set "btrfs: extended inode refs" by Mark Fasheh a try
(http://lwn.net/Articles/498226/). It eliminates the hard links per directory
limit (introducing a rather random, artificial limit of 64k instead).

-Jan
