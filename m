Return-Path: <SRS0=QcMt=BH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C74CC433E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jul 2020 01:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D368E20809
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jul 2020 01:24:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dxuuu.xyz header.i=@dxuuu.xyz header.b="HS24nG6i";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="T7nL78F1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgG1BYY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 Jul 2020 21:24:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39523 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726247AbgG1BYX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Jul 2020 21:24:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 255B05C01A9;
        Mon, 27 Jul 2020 21:24:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Jul 2020 21:24:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=hBmKFp+mBWns+KdlluDYGtC/Gh
        i9US9oBq3ZVQ/PxQU=; b=HS24nG6iqerXKuhLZRQFUV4HARHLfDMMjwp5B8l11y
        ybj4MJZf7/kG8UA0f8oNKqAnNn+xfTYQKjGEoiBMVwZXr7CwFWwkUqi6lQnCSAyl
        01iKmRFXbS9dHJImUtyjZycqh4SODLrc7CmZEBW7UGkKauspWGfy71MPHZT/9MKG
        +vkWfHJoEUPl0vNRd0TzKmR8Jj/YTa+N8WW8JGYhvFXXrsGpXPflMpL5DkyKxFNj
        0A32+YC763KW6nR437oddrcB4BlywIIzKYSHXswMJRMDO4uczqHdc4KjE+rISpdm
        pf2zeZwJxgsO76iMsV9tlc8WMed+E90gNbJ4dD7NHskQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hBmKFp+mBWns+Kdll
        uDYGtC/Ghi9US9oBq3ZVQ/PxQU=; b=T7nL78F1dEvM1DNAicwg83cW6AqGryQgv
        jJla2UMd+zxJ8hLa0dLzwcPXsFav5337vfAaMp+ZkMugujqQlE53h7gWMq/F7wct
        m4i3WRErQ/ouCgKXTNSDrEEEz5wcJJnw0HxdrcXNQW6J8oydGuf1Rx+9zj87Q++h
        kr8vPkVjUue4r8X/fdWjdZO86V72oUg2yIPHPMQkrg1AIJEAkqx26xHqjUZhvUpY
        pCYaTgcSWATOJImhtK65EOrFrUYTAuCpXyfLqEZydLlUP+Gz7WpNYXVuIUBrhVrt
        plumFYDKG0Tmu5PGrLi/T3CYOdheyqknCBuNakhOkvBjVpJg0itKw==
X-ME-Sender: <xms:RX4fX-3daS7CSHo8Dn5ks1fiVjwicxl8C_eTOBgBgv9HpXTDuBC2Fg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedriedugdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdefhedmnecujfgurhephffvuf
    ffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceougiguhes
    ugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnheptdffveekheekveejjeeigfeghf
    eijeeluefgkeeiuddvgeevfeejhedtfeevtdejnecuffhomhgrihhnpegvughithhorhgt
    ohhnfhhighdrohhrghenucfkphepjeefrdelfedrvdegjedrudefgeenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdig
    hiii
X-ME-Proxy: <xmx:RX4fXxGI6EQSW8OHKoVkJLvug4J9DTJWJAw6kSu-Z6EKM1s4Brc6hQ>
    <xmx:RX4fX26NTWZRC3oduwS8__fPKY_To8QGNKpzhroor4nNzfHsWVtzOw>
    <xmx:RX4fX_13YUb12abkOlxBz02OW6sSXeyxlDEGBjgkfm2bbV1er1L5BQ>
    <xmx:Rn4fXwxMtfeRaVeG_t-6fuR3mBOpc6eZh7plcH3cq64sD59nEcRi5w>
Received: from localhost.localdomain (c-73-93-247-134.hsd1.ca.comcast.net [73.93.247.134])
        by mail.messagingengine.com (Postfix) with ESMTPA id 35C37328005E;
        Mon, 27 Jul 2020 21:24:21 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     linux-btrfs@vger.kernel.org
Cc:     Daniel Xu <dxu@dxuuu.xyz>, kernel-team@fb.com
Subject: [PATCH] btrfs-progs: Add basic .editorconfig
Date:   Mon, 27 Jul 2020 18:24:09 -0700
Message-Id: <20200728012409.130252-1-dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Not all contributors work on projects that use linux kernel coding
style. This commit adds a basic editorconfig [0] to assist contributors
with managing configuration.

[0]: https://editorconfig.org/

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 .editorconfig | 10 ++++++++++
 .gitignore    |  1 +
 2 files changed, 11 insertions(+)
 create mode 100644 .editorconfig

diff --git a/.editorconfig b/.editorconfig
new file mode 100644
index 00000000..2829cfbe
--- /dev/null
+++ b/.editorconfig
@@ -0,0 +1,10 @@
+[*]
+end_of_line = lf
+insert_final_newline = true
+trim_trailing_whitespace = true
+charset = utf-8
+indent_style = space
+indent_size = 8
+
+[*.py]
+indent_size = 4
diff --git a/.gitignore b/.gitignore
index aadf9ae7..1c70ec94 100644
--- a/.gitignore
+++ b/.gitignore
@@ -65,6 +65,7 @@
 /cscope.in.out
 /cscope.po.out
 .*
+!.editorconfig

 /Documentation/Makefile
 /Documentation/*.html
--
2.27.0

