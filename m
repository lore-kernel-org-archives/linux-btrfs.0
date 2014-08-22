Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54951 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149AbaHVQHe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 12:07:34 -0400
Received: from [63.139.181.48] (port=51894 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1XKrNF-00022m-GD by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 09:07:33 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <marc@merlins.org>)
	id 1XKr7d-0002BR-Qr
	for linux-btrfs@vger.kernel.org; Fri, 22 Aug 2014 08:51:25 -0700
Date: Fri, 22 Aug 2014 08:50:40 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Unclean shutdowns cause google-chrome profile to be corrupted in
 various ways
Message-ID: <20140822155040.GU3875@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Someone just told me yesterday they had the same problem, so I filed a
bug:
https://bugzilla.kernel.org/show_bug.cgi?id=83041

Fairly often (over 20 times for me so far with various kernel versions),
when I reboot after a crash, my google-chrome profile is damaged in one
of 2 ways:
1) open tabs don't reopen
2) google-chrome says that my profile is corrupted.

In both cases rsyncing ~/.config/google-chrome from the last hourly
snapshot has fixed the problem every time.

Given that, I would say that google-chrome does not have a bug of half
unclean states since the state present in a snapshot has always worked
for me, but that's anecdotal, not proof.

But if my kernel hangs due to a bug that isn't btrfs' fault and I need
to power off and back on, after reboot my google-chrome profile is
almost always broken in some way.
This with a samsung evo 840 SSD which I believe does reasonable enough
things on power shutdowns, although I can't prove that.

File formats are some kind of raw data and sqlite 3.x
~/.config/google-chrome-beta/Profile 1:
Last Session:                     data
Last Tabs:                        data
Login Data:                       SQLite 3.x database

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
