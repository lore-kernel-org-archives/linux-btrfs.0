Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40226 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaC3A2j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Mar 2014 20:28:39 -0400
Received: from 24-182-54-115.dhcp.crcy.nv.charter.com ([24.182.54.115]:40228 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WU3c7-00027D-Fr by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sat, 29 Mar 2014 17:28:39 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WU3c5-0002Qa-Nl
	for linux-btrfs@vger.kernel.org; Sat, 29 Mar 2014 17:28:37 -0700
Date: Sat, 29 Mar 2014 17:28:37 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs file content missmatch incrementally sending subvolumes
 containing systemd journal files
Message-ID: <20140330002837.GQ22552@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had someone asking me about this bug:
Btrfs file content missmatch incrementally sending subvolumes containing systemd journal files
https://bugzilla.kernel.org/show_bug.cgi?id=66941

Specifically:
Just to note, I have also this issue with other files:
jkarlson/.config/chromium/Default/Archived History
jkarlson/.local/share/Trash/files/wheezy-x86_64.img
jkarlson/.local/share/evolution/addressbook/system/log.0000000001
jkarlson/.local/storage/vm-images/wheezy-x86_32.img
jkarlson/.local/storage/vm-images/wheezy-x86_64.img
jkarlson/.local/storage/vm-images/windows-2008-server.img

This is a bit worrisome since it affects sqlite3 too apparently
(firefox/chrome).

Do others know the status of this?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
