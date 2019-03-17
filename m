Return-Path: <SRS0=swP/=RU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EC2C43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 17 Mar 2019 12:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3CCD21019
	for <linux-btrfs@archiver.kernel.org>; Sun, 17 Mar 2019 12:51:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=lesimple.fr header.i=@lesimple.fr header.b="v0WHStM1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfCQMv6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 17 Mar 2019 08:51:58 -0400
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:44460 "EHLO
        mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726204AbfCQMv5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Mar 2019 08:51:57 -0400
Received: from nas.speed47.net (lfbn-lil-1-519-34.w81-254.abo.wanadoo.fr [81.254.103.34])
        by box.speed47.net (Postfix) with ESMTPSA id B000F300D;
        Sun, 17 Mar 2019 13:51:55 +0100 (CET)
Authentication-Results: box.speed47.net; dmarc=fail (p=none dis=none) header.from=lesimple.fr
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=lesimple.fr; s=mail01;
        t=1552827115; bh=WAij4WX4rGcG4zUb7B3RVooH2V82kvRncdJsHlPOA7U=;
        h=From:To:Cc:Subject:Date;
        b=v0WHStM1sbE4RTTzd+RVhM9tD8b2Ri3Nocfwkv8kpybLZCcuOY8AFmJNJLq42PLpu
         iRt0kD0RXSxD4StPIEGcPvkv44CWJeAnTVpnD5IsRA5U4aCXNVSI5e1jPApggrVaZI
         P/p4xQXryfNHQXwwO7AruT11c/dMylHH0CRLHEMA=
Received: (nullmailer pid 26311 invoked by uid 500);
        Sun, 17 Mar 2019 12:51:55 -0000
From:   stephane_btrfs@lesimple.fr
To:     linux-btrfs@vger.kernel.org
Cc:     =?UTF-8?q?St=C3=A9phane=20Lesimple?= <stephane_btrfs@lesimple.fr>
Subject: [PATCH 0/1] btrfs-progs: fi usage: implement raid56
Date:   Sun, 17 Mar 2019 13:51:49 +0100
Message-Id: <20190317125150.26265-1-stephane_btrfs@lesimple.fr>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Stéphane Lesimple <stephane_btrfs@lesimple.fr>

For several years now, we've been missing RAID56
code in the `filesystem usage' btrfs subcommand.

This is my try at implementing it. I don't have
any production array using raid5 or raid6 yet, but
I've tried different combinations of devloop test
filesystems with different number of devices with
different sizes. And the reported informations
always seem correct.

Comments are obviously welcome.

The diff can also be seen at:
https://github.com/kdave/btrfs-progs/compare/devel...speed47:raid56

Stéphane Lesimple (1):
  btrfs-progs: fi usage: implement raid56

 cmds-fi-usage.c | 96 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 36 deletions(-)

-- 
2.17.1

