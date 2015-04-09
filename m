Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38723 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbbDIOyA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 10:54:00 -0400
Date: Thu, 9 Apr 2015 07:53:35 -0700
From: Marc MERLIN <marc@merlins.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Paul Harvey <csirac2@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <20150409145335.GS1211@merlins.org>
References: <537844F2.1040507@gmail.com>
 <CAL3q7H7ovr1Ai54ptt+0qofU_T4TZYG15LT4e2K3zN2VHoDD9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H7ovr1Ai54ptt+0qofU_T4TZYG15LT4e2K3zN2VHoDD9w@mail.gmail.com>
Subject: Re: BTRFS corruption w/kernel 3.13 while using docker -s btrfs
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for trying btrfs, it's great for snapshots in docker, but
outside of the 2 helpful comments you already got, do yourself a favour
and use a newer kernel.

Btrfs moves fast, and 3.13 is way too old. The number of bugs (including
corruption bugs) that has been fixed since then is too long to list.

Try getting something newer than 3.16.2 at least, and if you're building
your own, 3.19.3 + this patch
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/42241
(btrfs: simplify insert_orphan_item / 381cf6587f8a8a8e981bc0c1aaaa8859b51dc756 )

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
