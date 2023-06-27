Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 452CBEB64D9
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Jun 2023 06:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjF0GNe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Jun 2023 02:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjF0GNd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2023 02:13:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C10910DA
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Jun 2023 23:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=pxlTJg5+fA37N6iclIofRkdM2PTG/h1qZFC0lP/3N4w=; b=VfOSTNWCEsuvG/WlxHjFoTp0om
        IdxTWsjsKYMM3MJ3HrxFsP4NrBADvFyhR3fSM+/cXBtdEAxeXjl9QHFUjTg8R9zaWjYtN7W03q5tW
        gaZl7SsEB0ryEemwKN5M0VEDp46vyaQg2Z09VWTSh8kTApCXgr6X4dtf659m8MJNyyhImfpP+smh/
        1CB2bsTSRrNcBXpwvBeFQBTcYGaRCLJtqj7VvnNsCYYxwuIE6HZqu1rZLZrFz2qC+x8xvWpUJcBRH
        Jm6C8hDtyB8fr+wNVhtRxtQDLa7J1oJujzCEElLlsqC8in3kUmiLQd+TVxDP4MFlhKhKQD7r3fTSY
        eWqwnaNA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qE1xA-00C5HE-26;
        Tue, 27 Jun 2023 06:13:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: btrfs_map_block tidyups
Date:   Tue, 27 Jun 2023 08:13:22 +0200
Message-Id: <20230627061324.85216-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all,

Dan reported a static type checker complained about the num_mirror_ret
output argument in btrfs_map_block, so the first patch cleans that up.
The second one simplifies a conditional right next to it.

Diffstat:
 volumes.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)
