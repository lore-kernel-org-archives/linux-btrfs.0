Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37803 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaBYGg7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 01:36:59 -0500
Received: from svh-gw.merlins.org ([173.11.111.145]:39112 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WIBdN-0000x5-1e by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 22:36:59 -0800
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WIBdM-0005JX-2u
	for linux-btrfs@vger.kernel.org; Mon, 24 Feb 2014 22:36:52 -0800
Date: Mon, 24 Feb 2014 22:36:52 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20140225063652.GD3521@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: 3.14.0rc3: did not find backref in send_root
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I got this during a btrfs send:
BTRFS error (device dm-2): did not find backref in send_root. inode=22672, offset=524288, disk_byte=1490517954560 found extent=1490517954560

I'll try a scrub when I've finished my backup, but is there anything I
can run on the file I've found from the inode?

gargamel:/mnt/dshelf1/Sound# btrfs inspect-internal inode-resolve  -v 22672 file.mp3
ioctl ret=0, bytes_left=3998, bytes_missing=0, cnt=1, missed=0
file.mp3

Anything else?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
