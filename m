Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82EE6C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54508206B7
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547472640;
	bh=4gB7XwOMACJCe52+XR2rZsNt8DKp1imswRYIghkN48I=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=olJm3xXg6SEXe2PNCMwx7yCPx63Cqs7RXKPSIa9Is/c7O8tv0PmvUpJTKeEi33oBF
	 CxtBD4/PyLsPqgjCjUGTHIOn1SgR8wvVMkR24mg/pBD8MVRXaUSQy+qczBaFiOEm7l
	 OIHwr5j+LHD3I9TVmIpPkWY7p6i/pb4A9d6gbf2I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfANNaj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:30:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbfANNaj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 08:30:39 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7958120651;
        Mon, 14 Jan 2019 13:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547472638;
        bh=4gB7XwOMACJCe52+XR2rZsNt8DKp1imswRYIghkN48I=;
        h=From:To:Cc:Subject:Date:From;
        b=nlSRV2kaf7P9YXkd57cX5MxQYmZeEA+7jDZs8S3wiVfzTOPRrsAEbUNoTg81IIB9T
         sJB7B7VUHpsAHUAbcyRW4GaBWBSxc0J66uYkkp92L3zIgLExkTfkdYtfDsbo8FtKvx
         IXilWsvcGcBkHlF9vZ5Md3H7O4YXsLH7/jovQQRA=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     ddis@suse.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 1/3] Btrfs-progs: fix mount point detection due to partial prefix match
Date:   Mon, 14 Jan 2019 13:30:24 +0000
Message-Id: <20190114133024.18320-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When attempting to find the mount point of a path we can end up returning
an incorrect mount point. This happens because we consider a mount point
valid for the given path even if it matches only partially the patch.
Consider the following example, which makes btrfs receive fail:

  $ truncate -s 1G disk1
  $ truncate -s 1G disk2

  $ losetup /dev/loop1 disk1
  $ losetup /dev/loop2 disk2

  $ mkfs.btrfs -f /dev/loop1
  $ mkfs.btrfs -f /dev/loop2

  $ mount /dev/loop1 /mnt
  $ mkdir /mnt/ddis
  $ mkdir /mnt/ddis-not-a-mount
  $ mount /dev/loop2 /mnt/ddis

  $ echo "some data" > /mnt/ddis/file
  $ btrfs subvolume snapshot -r /mnt/ddis /mnt/ddis/snap

  $ btrfs send -f /tmp/send.data /mnt/ddis/snap
  $ btrfs receive -f /tmp/send.data /mnt/ddis-not-a-mount
  At subvol snap
  ERROR: chown  failed: No such file or directory

In that example btrfs receive passes the path "/mnt/ddis-not-a-mount" to
find_mount_root() which picks "/mnt/ddis" as the mount point instead of
"/mnt". The wrong decision happens because "/mnt/ddis" is the longest
string found that is a prefix of "/mnt/ddis-not-a-mount", however it
shouldn't be considered valid because what follows the substring "ddis"
in the given path is not a path separator ("/") nor the null character
('\0'). So fix find_mount_root() to check for the presence of a path
separator or a null byte character after if finds a mount point string
that matches the given path.

A test case will follow soon in a separate patch.

Reported-by: David Disseldorp <ddis@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 3a4bc92a..6616630b 100644
--- a/utils.c
+++ b/utils.c
@@ -2064,7 +2064,8 @@ int find_mount_root(const char *path, char **mount_root)
 
 	while ((ent = getmntent(mnttab))) {
 		len = strlen(ent->mnt_dir);
-		if (strncmp(ent->mnt_dir, path, len) == 0) {
+		if (strncmp(ent->mnt_dir, path, len) == 0 &&
+		    (path[len] == '/' || path[len] == '\0')) {
 			/* match found and use the latest match */
 			if (longest_matchlen <= len) {
 				free(longest_match);
-- 
2.11.0

