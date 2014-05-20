Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52042 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaETCGJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 22:06:09 -0400
Received: from p10053-ipngn5802marunouchi.tokyo.ocn.ne.jp ([153.163.201.53]:29048 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WmZRR-0002uE-63 by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 19:06:09 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WmZRO-0003sj-RS
	for linux-btrfs@vger.kernel.org; Mon, 19 May 2014 19:06:06 -0700
Date: Mon, 19 May 2014 19:06:06 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs diff between snapshosts
Message-ID: <20140520020606.GA10656@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As a followup on the discussion we had on how to do a live data switch
on a partition without unmounting it since it's busy, it came back to
how do you know what changed between 2 snapshots.

btrfs send giving a file list of what was added/modified/removed is the
long term answer, and Filipe is working on patches that will offer this
in the future (thanks Filipe).

In the meantime, I found a hack/script that gives a partial diff between
2 snapshots, called it btrfs-diff but then remembered that there isn't a
page for it.

So, I made one, along with example usage:
http://marc.merlins.org/perso/btrfs/post_2014-05-19_Btrfs-diff-Between-Snapshots.html

Hope this helps.

As another temp hack, I tried to look at a quick way to parse btrfs send
output to just spit out filenames, but that wasn't too trivial (as in
with sed/perl).

If someone has something better, please share :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
