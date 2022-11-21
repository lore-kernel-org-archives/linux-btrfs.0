Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B39C4332F
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Nov 2022 17:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiKURsE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 12:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiKURsC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Nov 2022 12:48:02 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D65A190
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Nov 2022 09:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=dPdcSIVS9jHq3C4PbcIHBLj5FSOalcJlgBW0VGPfhw4=; b=nOG5ynqetFwUQsgVq3/T2155Iw
        QazEVOPS82rDz8mjYz9Hx4/7B1YQiW0RzUV4QIEzczsyqChcrM+s54qmiCqikcDmmYJFxlJ9xl26W
        aDUOTXb050WjhXeSedP39RFuZDl1lEzWqlNBilfFRyZKR+3aDZTHP9cpWzfKxWGSp8KTo6DC4Lgou
        orItBssuN9ZeaC2JbzvDOpRb/sXA05BD4qyDSg8MePN75nJ4ByGxpTCdFTDjPPWEO/xxTydceydbt
        2n1IUVbgZz1wXt52l7+BD0SGXto7dhHCrBoQESnPukrMm9dQBuc1ephwBM+DgaTY4thI02Ddjmu6L
        FhQSH38g==;
Received: from [2001:4bb8:199:6d04:9a88:dc19:c657:d17f] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxAtd-00GUCs-Tt; Mon, 21 Nov 2022 17:47:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: minor sb clearing improvements
Date:   Mon, 21 Nov 2022 18:47:47 +0100
Message-Id: <20221121174749.387407-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all,

this series moves btrfs off the deprecated write_one_page API that
requires ->writepage to be implemented (in this case on the block
device inode), and while doing so also avoids a pointless sb read
for zoned file systems.

Diffstat:
 volumes.c |   50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)
