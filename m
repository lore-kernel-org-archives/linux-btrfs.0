Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43074 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab3L1RTs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Dec 2013 12:19:48 -0500
Received: from bgl93-4-82-235-219-215.fbx.proxad.net ([82.235.219.215]:52962 helo=gandalfthegreat.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1VwxYB-0004od-NL by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Dec 2013 09:19:48 -0800
Received: from merlin by gandalfthegreat.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@gandalfthegreat.merlins.org>)
	id 1VwxY8-00023b-0k
	for linux-btrfs@vger.kernel.org; Sat, 28 Dec 2013 09:19:44 -0800
Date: Sat, 28 Dec 2013 09:19:43 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Is anyone using btrfs send/receive for backups instead of rsync?
Message-ID: <20131228171943.GE19863@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, I have a nightly cronjob that rsyncs my SSD to my HD on my
laptop.

Of course, running rsync on an entire FS every night is slow, especially
if I happen to try to use the laptop at the same time.

Obviously, that's what btrfs send/receive is supposed to fix:
https://btrfs.wiki.kernel.org/index.php/Design_notes_on_Send/Receive
http://lwn.net/Articles/506244/

It's been around for about 1.5 years now, so I was curious if others had
converted to it for backups when indeed the wiki has the CYA 'if you use
for backups, you get what you deserve' :)

Is it still being worked on, or kind of frozen/good as is?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
