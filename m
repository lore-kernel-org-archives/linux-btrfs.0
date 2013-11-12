Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:57975 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab3KLNmP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 08:42:15 -0500
Received: by mail-we0-f170.google.com with SMTP id p61so1957wes.15
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 05:42:14 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 4/5] Btrfs-progs: add type root to label property
Date: Tue, 12 Nov 2013 13:41:45 +0000
Message-Id: <1384263706-25549-5-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
References: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So that we can get the label of a mounted filesystem.

Before this change:

        $ btrfs prop get /mnt/btrfs label
        ERROR: object is not compatible with property

        $ btrfs prop get /dev/sdb3 label
        ERROR: dev /dev/sdb3 is mounted, use mount point
        ERROR: failed to set/get property for object.

After this change:

        $ btrfs prop get /mnt/btrfs label
        label=foobar

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 props.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/props.c b/props.c
index 763fd57..12fdc52 100644
--- a/props.c
+++ b/props.c
@@ -105,6 +105,7 @@ static int prop_label(enum prop_object_type type,
 const struct prop_handler prop_handlers[] = {
 	{"ro", "Set/get read-only flag of subvolume.", 0, prop_object_subvol,
 	 prop_read_only},
-	{"label", "Set/get label of device.", 0, prop_object_dev, prop_label},
+	{"label", "Set/get label of device.", 0,
+	 prop_object_dev | prop_object_root, prop_label},
 	{0, 0, 0, 0, 0}
 };
-- 
1.7.9.5

