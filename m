Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from milliways.jots.org ([198.204.250.45]:57650 "EHLO
	milliways.jots.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830AbaKTRFF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 12:05:05 -0500
Received: from webmail.jots.org (localhost.localdomain [127.0.0.1])
	by milliways.jots.org (Postfix) with ESMTP id 011C72BC13BF
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 11:57:51 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 20 Nov 2014 11:57:50 -0500
From: "Ken D'Ambrosio" <ken@jots.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs send erroring...
Message-ID: <282a8749999cb6fed86f4ecd15152db0@webmail.jots.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!  Trying to do a "btrfs send", and failing with:

root@khamul:~# btrfs send /biggie/BACKUP/ | btrfs receive /tmp/sdd1/
At subvol /biggie/BACKUP/
At subvol BACKUP
ERROR: rename o2046806-17126-0 -> volumes/ccdn-ch2-01 failed. No such 
file or directory

Judging by disk capacity, it hits this about 40% of the way through.  As 
my disk has subvolumes on it, which are underneath /biggie/BACKUP/, is 
there a different way I should go about "sending" an entire disk?

Thanks!

-Ken
