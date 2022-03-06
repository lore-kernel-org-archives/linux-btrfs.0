Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870A8C433F5
	for <linux-btrfs@archiver.kernel.org>; Sun,  6 Mar 2022 18:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbiCFSRJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 6 Mar 2022 13:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbiCFSRI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Mar 2022 13:17:08 -0500
Received: from smtp.tiscali.it (michael.mail.tiscali.it [213.205.33.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45E4765D36
        for <linux-btrfs@vger.kernel.org>; Sun,  6 Mar 2022 10:16:16 -0800 (PST)
Received: from venice.bhome ([78.12.27.75])
        by michael.mail.tiscali.it with 
        id 36FE270011dDdji016FEbN; Sun, 06 Mar 2022 18:15:14 +0000
x-auth-user: kreijack@tiscali.it
From:   Goffredo Baroncelli <kreijack@tiscali.it>
To:     linux-btrfs@vger.kernel.org
Cc:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.cz>,
        Sinnamohideen Shafeeq <shafeeqs@panasas.com>,
        Paul Jones <paul@pauljones.id.au>, Boris Burkov <boris@bur.io>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 0/2][V12] btrfs-progs: allocation_hint disk property
Date:   Sun,  6 Mar 2022 19:15:10 +0100
Message-Id: <cover.1646590206.git.kreijack@inwind.it>
X-Mailer: git-send-email 2.35.1
Reply-To: Goffredo Baroncelli <kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tiscali.it; s=smtp;
        t=1646590514; bh=NbmQd56zjKG9v6nocAr0lPRlfzrUFmOYvH+DaiEL2u4=;
        h=From:To:Cc:Subject:Date:Reply-To;
        b=PTQHluA8a/Cd2WzNjB4Qd51wmzeDotgztag9rENjf1tAhueadW9v29gc0SVgLyW4j
         WfJIeK+fuBKS/4Ib7xLkWEvkHi8D6JZOdE3VVqLGJfNgeuG5NqxUwpE7tw7HlM7JVC
         xeNR3jzugAhXRDIAwx653KyWotW20rJUuWb9+4q0=
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

This patches set is the userspace portion of the serie
"[PATCH V12] btrfs: allocation_hint".

Look this patches set for further information.

Changelog:
V12:
- removed support for major_minor: now even to query the allocation_hint
property requires root privileges.
V11:
- find the correct /sys/fs/btrfs/<UUID> directory using the
devinfo/major_minor sysfs file.
- update the man page to the .rst file format

G.Baroncelli

Goffredo Baroncelli (2):
  btrfs-progs: new "allocation_hint" property.
  Update man page for allocator_hint property.

 Documentation/btrfs-property.rst |  21 ++++
 cmds/property.c                  | 162 +++++++++++++++++++++++++++++++
 kernel-shared/ctree.h            |  13 +++
 3 files changed, 196 insertions(+)

-- 
2.35.1

