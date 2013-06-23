Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1207.opentransfer.com ([98.130.1.227]:39995 "EHLO
	mail1207.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3FWWsQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Jun 2013 18:48:16 -0400
Message-ID: <1372027293.1052.12.camel@miguel-MacBookPro>
Subject: btrfs send/receive issues
From: Miguel =?ISO-8859-1?Q?Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
To: linux-btrfs@vger.kernel.org
Date: Sun, 23 Jun 2013 23:41:33 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I want to do a backup of a btrfs subvolume from one disk to another
disk, both with btrfs filesystems, using the btrfs  send receive
functionality. I do 

cd /media/miguel/btrfs_backup/
mkdir backups
sudo btrfs send /mnt/@backup2 | sudo btrfs receive /media/miguel/btrfs_backup/backups/

and this works fine, the @backup2 subvolume is created
at /media/miguel/btrfs_backup/backups/. Then I try to send a second
snapshot taken after @backup2 :

sudo btrfs send -p /mnt/@backup2 /mnt/@backup3 | sudo btrfs receive /media/miguel/btrfs_backup/backups/

And I get:

At subvol /mnt/@backup3
At snapshot @backup3
ERROR: open backups/@backup2 failed. No such file or directory

But @backup2 is a subvolume in /media/miguel/btrfs_backup/backups/ 

I'm I doing something wrong ?

best,
-- 
Miguel Negrão
http://www.friendlyvirus.org/miguelnegrao



