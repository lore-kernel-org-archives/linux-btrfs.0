Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:51658 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab3FJGbw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 02:31:52 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 863A53A0B1C
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 08:21:37 +0200 (CEST)
Received: from localhost (unknown [123.109.194.100])
	by mail.virtall.com (Postfix) with ESMTPSA id 67BCD3A0ABA
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 08:21:36 +0200 (CEST)
Date: Mon, 10 Jun 2013 15:21:27 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs quota examples?
Message-ID: <20130610152127.38fb8a50@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to use btrfs quotas, but I'm unable to find reliable
documentation on its usage.

Let's start with an empty subvolume:

- assign 200 MB space to it:

# btrfs qgroup limit 200m /mnt/btrfs-backup/tester/


- see the usage:

# btrfs qgroup show /mnt/btrfs-backup/tester/
0/803 0 0


- let's add a 100 MB file:

# dd if=/dev/urandom of=bigfile bs=1M count=100


- sync the FS to make sure quota is updated:

# btrfs filesystem
sync /mnt/btrfs-backup/ FSSync '/mnt/btrfs-backup/'


- see current quota usage:

# btrfs qgroup show /mnt/btrfs-backup/backuppc/tester/
0/803 104882176 104882176


Now, my questions:

- what do both 104882176 104882176 numbers represent?

- how can I verify the quota assigned to any given subvolume? I've assigned 200 MB, but how can I verify that number?


-- 
Tomasz Chmielewski
http://wpkg.org
