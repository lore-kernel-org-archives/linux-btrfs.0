Return-Path: <SRS0=o+k5=4Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 141AAC10F25
	for <linux-btrfs@archiver.kernel.org>; Sat,  7 Mar 2020 22:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1AB6206D7
	for <linux-btrfs@archiver.kernel.org>; Sat,  7 Mar 2020 22:42:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=mpdesouza.com header.i=@mpdesouza.com header.b="Xel2NIhY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgCGWmY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 7 Mar 2020 17:42:24 -0500
Received: from gateway31.websitewelcome.com ([192.185.143.39]:21467 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbgCGWmY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 7 Mar 2020 17:42:24 -0500
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 79F673D610
        for <linux-btrfs@vger.kernel.org>; Sat,  7 Mar 2020 16:42:23 -0600 (CST)
Received: from br540.hostgator.com.br ([108.179.252.180])
        by cmsmtp with SMTP
        id Ai9HjWUSYXVkQAi9Hjpnpn; Sat, 07 Mar 2020 16:42:23 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=mpdesouza.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VTmzJnSReW+OkhzXO8OcqhxOAl6C6OKacqH/t9r1Lgc=; b=Xel2NIhYpCvP1b6fU5xidK85kA
        itH0DihdsQmIhchT7KVJUkxqfi9eo3RQPpknSL3+4DkYd9DgD16qOLt7Ag4w1WKgQ8SWdya1XovRM
        0Xuffc02U78hCxkpYWxFJq1UTXytiiRAXx2g+TazAPJ7k0lF3ctQSKtnnGblnr0XzFg36L/z9mhdi
        lOwnIa7pjACmX3M6s0hmfQ2SJEGRXK5zZgg4/JaVMbNIM5l5nwNyKmDtU5JKoQiN/Lz1KyLzLl/Uo
        6ZfpYxQmNn8tVsB8Kvltws0PqT+XhgCytX4fygpJLf8WVhgYPINcHjG2xCf32wfZq0LuXE7tUXgrq
        RBhhN3wA==;
Received: from 189.26.190.248.dynamic.adsl.gvt.net.br ([189.26.190.248]:56604 helo=hephaestus.suse.cz)
        by br540.hostgator.com.br with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <marcos@mpdesouza.com>)
        id 1jAi9G-002tnS-UE; Sat, 07 Mar 2020 19:42:23 -0300
From:   Marcos Paulo de Souza <marcos@mpdesouza.com>
To:     dsterba@suse.com, linux-btrfs@vger.kernel.org
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH 0/2] btrfs-progs: Auto resize fs after device replace
Date:   Sat,  7 Mar 2020 19:45:14 -0300
Message-Id: <20200307224516.16315-1-marcos@mpdesouza.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - br540.hostgator.com.br
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mpdesouza.com
X-BWhitelist: no
X-Source-IP: 189.26.190.248
X-Source-L: No
X-Exim-ID: 1jAi9G-002tnS-UE
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 189.26.190.248.dynamic.adsl.gvt.net.br (hephaestus.suse.cz) [189.26.190.248]:56604
X-Source-Auth: marcos@mpdesouza.com
X-Email-Count: 2
X-Source-Cap: bXBkZXNvNTM7bXBkZXNvNTM7YnI1NDAuaG9zdGdhdG9yLmNvbS5icg==
X-Local-Domain: yes
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

These two patches make possible to resize the fs after a successful replace
finishes. The flag -a is responsible for doing it (-r is already use, so -a in
this context means "automatically").

The first patch just moves the resize rationale to utils.c and the second patch
adds the flag an calls resize if -a is informed replace finishes successfully.

Please review!

Marcos Paulo de Souza (2):
  btrfs-progs: Move resize into functionaly into utils.c
  btrfs-progs: replace: New argument to resize the fs after replace

 Documentation/btrfs-replace.asciidoc |  4 +-
 cmds/filesystem.c                    | 58 +--------------------------
 cmds/replace.c                       | 19 ++++++++-
 common/utils.c                       | 60 ++++++++++++++++++++++++++++
 common/utils.h                       |  1 +
 5 files changed, 83 insertions(+), 59 deletions(-)

-- 
2.25.0

