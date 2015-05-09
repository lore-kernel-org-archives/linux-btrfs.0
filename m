Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.digint.ch ([92.42.190.51]:60387 "EHLO mail.digint.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbbEIL6E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 May 2015 07:58:04 -0400
Received: from [10.0.1.10] (77-59-134-149.dclient.hispeed.ch [77.59.134.149])
	by mail.digint.ch (Postfix) with ESMTPSA id 0F1BC2F70065
	for <linux-btrfs@vger.kernel.org>; Sat,  9 May 2015 13:52:05 +0200 (CEST)
Message-ID: <554DF4E8.2010601@tty0.ch>
Date: Sat, 09 May 2015 13:52:08 +0200
From: Axel Burri <axel@tty0.ch>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs receive error recovery
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi btrfs team

I'm the developer of "btrbk" [1], which uses btrfs send/receive to
create backups. In case of errors, "btrfs receive" leaves the partially
received subvolume behind, causing some trouble for subsequent
incremental backups. As I can see in the wiki, "Delete partially
received subvolumes on error" is on the TODO list. Until then, what
would be the best way to check if the received subvolume needs to be
deleted?

As "btrfs receive" does always return an exit value of "1" on errors, I
cannot rely on this (e.g. if a file with the received name already
exists, I also get an exit code=1, but then I do NOT want to delete
anything).

Also, "btrfs subvolume show <partially-received-subvol>" does not
complain either.

Do you have any hints on how I can check for this? (and no, parsing
stderr messages is not an option)


Thanks in advance,

- Axel


[1] https://www.digint.ch/btrbk/
    https://github.com/digint/btrbk
