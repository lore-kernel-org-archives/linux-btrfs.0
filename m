Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:56894 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933800Ab3BTPNf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 10:13:35 -0500
Received: by mail-ee0-f50.google.com with SMTP id e51so4143830eek.23
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 07:13:34 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 20 Feb 2013 16:13:33 +0100
Message-ID: <CA+4EQ5dZN5YdvsJG+jO1LH8SghH_iedLYo7DN3zk1+m7o0QC9A@mail.gmail.com>
Subject: btrfs doesn't report proper error when removing subvolume
From: Petr Bena <benapetr@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

petrb@bots-bnr1:/mnt$ btrfs subvolume delete ext2_saved/
Delete subvolume '/mnt/ext2_saved'
ERROR: cannot delete '/mnt/ext2_saved'

this is not really very descriptive. It would be really cool if it
told me why it can't delete it.

For example:


Permission denied. Cannot delete ...
Disk write error. Cannot delete

Descriptive error messages won't hurt ;) or is it so big deal to find
out the reason?
