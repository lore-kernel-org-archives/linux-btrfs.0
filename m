Return-Path: <SRS0=eL0R=TN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA0BC04AB1
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 May 2019 03:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94650208CB
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 May 2019 03:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557718831;
	bh=/QfadwX3fAap/KVMWWbJmnYIBmNvWh3eHFGS7KkQudI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=t6u5acFPWgE6dnlQp8UK+Ob45XqfsVZ7UTLDHb2rzakd28KJ/bmd8pa3VtrSknZEd
	 HOJfyaJLyznbncmnyKCwganHOQxb/8uohu+P3uFi1BFHIFKK+/n3hztp+7uqTqQUDw
	 YDzz9xzeQsBy46Mxg3cA5Go9qw2yTWEIDtPOxCaY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfEMDk1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 12 May 2019 23:40:27 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48009 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727202AbfEMDk0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 May 2019 23:40:26 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6D874221AD;
        Sun, 12 May 2019 23:40:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 12 May 2019 23:40:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=kFSE7bFFnbktj2ocg4ZHcDdWLHu2gnLS1nuSxzqjNPU=; b=zZvRWJQl
        xkUdwF6tDIU9fbhNKHVNYUzGQS/tFwET14dixGRBziVNh3UO+JFXoISc6kFQifJh
        pZO8VKIs1ah4DGz6f8Ex05DwB+ubJFtHYZs9/5UTaFIYTv9ybRyEIyalvEeG6vSZ
        yFTXcOdjuLhSXyzkUb1LFv/0gDZKnuWSLUiVY4vGN0CVg35g6MMnwQ9xxTIX0Fca
        G6dbPBs9dGQTEfcKzXVjmDtRvBVxpKd7+vMMFmfH3JpEOe0pmT/JWweH6HppOLPI
        lGKu0PgZCeB1sJlCYzgXESXFEtOW0siJ5DaTY/G4f+XEaIX9LlkBn88KGaMYH/bm
        Y5/WcZJgQnJe+g==
X-ME-Sender: <xms:KefYXO6L8dCj1xGW-eXQqEl5PCVTnSbjtdsqo2_1TQa3b9F4-uTL_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrleefgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfvohgsihhn
    ucevrdcujfgrrhguihhnghdfuceothhosghinheskhgvrhhnvghlrdhorhhgqeenucfkph
    epuddvgedrudeiledrudeirddukeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehtohgs
    ihhnsehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:KefYXBPY5UGHul880jFBuPKmtr9iDKJhC9J4EKSB0XAOtmSmvt5MQg>
    <xmx:KefYXEvh96D8Cs-MWHBBI7F8TIN4JLZ_XJF8GTW9m6vyG7RuPxooqg>
    <xmx:KefYXMZtSIhPPFHwJTZEQpI_owUKKfGurqB4N1lqoK4KnZdUQtV9-g>
    <xmx:KefYXARItqzB8vczWxsTP10gzA4XaADFLy-h9SHGyV8MZrCsoBTM8w>
Received: from eros.localdomain (124-169-16-185.dyn.iinet.net.au [124.169.16.185])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4822F8005A;
        Sun, 12 May 2019 23:40:22 -0400 (EDT)
From:   "Tobin C. Harding" <tobin@kernel.org>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] fs: btrfs: Don't leak memory when failing add fsid
Date:   Mon, 13 May 2019 13:39:12 +1000
Message-Id: <20190513033912.3436-3-tobin@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190513033912.3436-1-tobin@kernel.org>
References: <20190513033912.3436-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

A failed call to kobject_init_and_add() must be followed by a call to
kobject_put().  Currently in the error path when adding fs_devices we
are missing this call.  This could be fixed by calling
btrfs_sysfs_remove_fsid() if btrfs_sysfs_add_fsid() returns an error or
by adding a call to kobject_put() directly in btrfs_sysfs_add_fsid().
Here we choose the second option because it prevents the slightly
unusual error path handling requirements of kobject from leaking out
into btrfs functions.

Add a call to kobject_put() in the error path of kobject_add_and_init().
This causes the release method to be called if kobject_init_and_add()
fails.  open_tree() is the function that calls btrfs_sysfs_add_fsid()
and the error code in this function is already written with the
assumption that the release method is called during the error path of
open_tree() (as seen by the call to btrfs_sysfs_remove_fsid() under the
fail_fsdev_sysfs label).

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 fs/btrfs/sysfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 5a5930e3d32b..2f078b77fe14 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -825,7 +825,12 @@ int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
 	fs_devs->fsid_kobj.kset = btrfs_kset;
 	error = kobject_init_and_add(&fs_devs->fsid_kobj,
 				&btrfs_ktype, parent, "%pU", fs_devs->fsid);
-	return error;
+	if (error) {
+		kobject_put(&fs_devs->fsid_kobj);
+		return error;
+	}
+
+	return 0;
 }
 
 int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
-- 
2.21.0

