Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm18.bullet.mail.gq1.yahoo.com ([98.136.217.1]:46165 "EHLO
	nm18.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122Ab3HFEqG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 00:46:06 -0400
Message-ID: <5200BD5C.8090901@yahoo.fr>
Date: Tue, 06 Aug 2013 09:09:48 +0000
From: Sobhan Mohammadpour <sobhanmohammadpour1@yahoo.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs mounts as read-only
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

yesterday btrfs was complaining about empty space so i booted into a
livecd removed some pkgmanager cache and some snapshots and rebooted but
while rebooting the init couldn't unmount the filesystem (it tried for
some minutes) so it just ignored it now when i boot i get
http://bpaste.net/show/120045/ in dmesg,the filesystem get mounted as
readonly
