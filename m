Return-Path: <SRS0=pm4w=3Q=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEE8C35240
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Jan 2020 02:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A65122071E
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Jan 2020 02:47:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FoRhfxbz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgA0CrZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 21:47:25 -0500
Received: from mail-qt1-f180.google.com ([209.85.160.180]:39460 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgA0CrZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Jan 2020 21:47:25 -0500
Received: by mail-qt1-f180.google.com with SMTP id e5so6324787qtm.6
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jan 2020 18:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G3gHsLGyThxtsAoVwHF8B9pxmbxKl20RDFTmByMp9Z0=;
        b=FoRhfxbz4BlbNixQYE5TriapScximDnKLj5BEqu15W/d8dDpCYhqZBXIxTgFU+/SfB
         H9VEfdFXQe+qs8Lz0bgDJLd5sVEuu6vdwDteyXOahyaww+3nQFMrTYFzQMHjX1GxpY5w
         EnnTxkdRT9O/Y0xttZzAeQsgIF8p+xlTF/v4Zyra7w2R5MYofuVMNbt2wK/w5rc9bbga
         K1Fv3wf+Zt+Sj3r/aQsLB4hrXuSiXcXYZpDjszeYyg/nHiwf9NVjv+Q8ralE9r8ezsLN
         CZPcIoQoD3Ww7UWLH9H4qRmpuubh5ubprWG52MH391M3c2JvDyrAUVMcKwZeDpPwPnyt
         /P6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G3gHsLGyThxtsAoVwHF8B9pxmbxKl20RDFTmByMp9Z0=;
        b=txqClnJs1sIlnBignYG/3Vnz+nBjoyu/+Pfl9IPzk54XDc3yEWx+fIxy5RCh3n0UPf
         I07lhXvJWJisfEcmFsMF3ix+iwBK9ZKUZomAV2XjQbmv68IEA6BhkR3PrjtcM3PUhZgk
         DWpCz3nFsCrkeYARQ7vXsbrqbN5DT+TfVO+a3TfQUbXn+AvQsC/oynKkfJskIvUYBdeG
         OhDKwBkPdQd9U6mXVZrJiB4M1zi0rf32pLsv5vVdfsVINZZ7rzTS3zLJ7tZs11pFGhYD
         SqTLdk7l0ExSo5yk2n/y92ozZg7GqWGmUKAnrLFew9UjusfoeM6CoOV3zdJd1kRf1pVn
         vGmw==
X-Gm-Message-State: APjAAAVc2k+twfX4zWinWSMBPO1BeN+89YGUtNY0IZWUzrIf99fbS5vA
        t/SmuXZsZDGI/1mXHdNU19o=
X-Google-Smtp-Source: APXvYqwzyjEnYJXdd5qQ4ndOwSNJHHJmB4JxH1tj/cBce8jpOraeBlEy8bTymlbql9F1axgRBDlaPw==
X-Received: by 2002:ac8:134b:: with SMTP id f11mr8132479qtj.336.1580093244033;
        Sun, 26 Jan 2020 18:47:24 -0800 (PST)
Received: from localhost.localdomain (200.146.53.109.dynamic.dialup.gvt.net.br. [200.146.53.109])
        by smtp.gmail.com with ESMTPSA id c184sm8643337qke.118.2020.01.26.18.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jan 2020 18:47:23 -0800 (PST)
From:   Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc:     dsterba@suse.com, josef@toxicpanda.com,
        linux-btrfs@vger.kernel.org,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH 5/5] VERSION: bump version
Date:   Sun, 26 Jan 2020 23:49:54 -0300
Message-Id: <20200127024954.16916-5-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200127024954.16916-1-marcos.souza.org@gmail.com>
References: <20200127024954.16916-1-marcos.souza.org@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

As a new symbol was created, bump the library version.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 VERSION | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/VERSION b/VERSION
index cce56663..4ef789b0 100644
--- a/VERSION
+++ b/VERSION
@@ -1 +1 @@
-v5.4.1
+v5.5
-- 
2.24.0

