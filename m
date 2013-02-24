Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:65502 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab3BXONv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Feb 2013 09:13:51 -0500
Message-ID: <512A2019.6000201@friedels.name>
Date: Sun, 24 Feb 2013 15:13:45 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Needed change in Wiki
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I don't see how to change the wiki, but it needs an update:

apt-get build-dep btrfs-tools
-or-
apt-get install uuid-dev libattr1-dev zlib1g-dev libacl1-dev e2fslibs-dev

here libblkid-dev is missing -at least for the latest git version of the 
btrfs-progs.

Greetings,
Hendrik
