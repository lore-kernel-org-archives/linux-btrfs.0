Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60228 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaJZH7v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Oct 2014 03:59:51 -0400
MIME-Version: 1.0
Message-ID: <trinity-716ca1fa-5a94-4624-9e01-8f4c4b500e46-1414310389248@3capp-gmx-bs26>
From: "Christian Tschabuschnig" <tschaboo@gmx.at>
To: linux-btrfs@vger.kernel.org
Subject: Does btrfs-restore report missing/corrupt files?
Content-Type: text/plain; charset=UTF-8
Date: Sun, 26 Oct 2014 08:59:49 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello,

currently I am trying to recover a btrfs filesystem which had a few subvolumes. When running
# btrfs restore -sx /dev/xxx .
one subvolume gets restored.

Would the restore utility report any corruption within this subvolume? May I assume that all data was recovered if there are no messages on STDERR?

In this particular case there were a few messages on STDERR but I believe they refer to the other subvolumes:
Check tree block failed, want=43702427648, have=4902726477564852953
Check tree block failed, want=43702427648, have=4902726477564852953
Check tree block failed, want=43702427648, have=9670034583150859267
Check tree block failed, want=43702427648, have=4902726477564852953
Check tree block failed, want=43702427648, have=4902726477564852953
read block failed check_tree_block
Error reading subvolume ./cur-root: 18446744073709551611
