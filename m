Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.mailbox.org ([80.241.60.215]:32925 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933681AbdD2VyU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Apr 2017 17:54:20 -0400
From: Christian Brauner <christian.brauner@ubuntu.com>
To: nazar@mokrynskyi.com, lakshmipathi.g@gmail.com, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 0/1] btrfs-progs: send: fail on first -ENODATA only
Date: Sat, 29 Apr 2017 23:54:04 +0200
Message-Id: <20170429215405.1123-1-christian.brauner@ubuntu.com>
In-Reply-To: <df7120cc-82a9-a90d-8832-e1767ba65d69@mokrynskyi.com,CAKuJGC88jCxHBz6eTNK-F-fsuBzw4jRsDucEYqgPRKrgR8TWWA@mail.gmail.com,20170428095530.yw74untb34oawlm2@mailbox.org>
References: <df7120cc-82a9-a90d-8832-e1767ba65d69@mokrynskyi.com,CAKuJGC88jCxHBz6eTNK-F-fsuBzw4jRsDucEYqgPRKrgR8TWWA@mail.gmail.com,20170428095530.yw74untb34oawlm2@mailbox.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christian Brauner (1):
  btrfs-progs: send: fail on first -ENODATA only

 cmds-receive.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

-- 
2.11.0

