Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46743C77B7F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 May 2023 15:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjECPY7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 May 2023 11:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjECPYw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2023 11:24:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CB459F0
        for <linux-btrfs@vger.kernel.org>; Wed,  3 May 2023 08:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=4TBnsJ2270O1HHhk48TUi2YVXEnVzA0VBTUTMSHIM04=; b=mm06DRS1NNuzExxchezhxtoBGn
        hJFNLZjRzOhz9KoIqs2M1fzTh1guVxVWvucnZ+248MLCqkHf7sQQC6eKcygj7pUav7LMXvknbfqRW
        vGxpl7fJzCgnm8CHO8saVIWqKiJgfnhjks4xhLidZLSvnvAnxPudUjSMrQGSY6rUe0RJFGBJ6SQXL
        zT+8jLhvlNPf1Pkark7VhpU+k/BEMc+XUFR+rl9rJYnKVfvW0QVB/YsAbxH63tbBH8Vi+OEtFJr4x
        t73pV/QC6AjbHVnbOpJM809lcE2szsT06rWmsw9J0dgsD09mYurVt9KrMtdEVlI6Cj3MO/PSkRcsJ
        RSQcqZzw==;
Received: from [2001:4bb8:181:617f:7279:c4cd:ae56:e444] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1puELV-004xbw-0n;
        Wed, 03 May 2023 15:24:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: simplify extent_buffer reading and writing v4
Date:   Wed,  3 May 2023 17:24:20 +0200
Message-Id: <20230503152441.1141019-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all,

currently reading and writing of extent_buffers is very complicated as it
tries to work in a page oriented way.  Switch as much as possible to work
based on the extent_buffer object to simplify the code.

I suspect in the long run switching to dedicated object based writeback
and reclaim similar to the XFS buffer cache would be a good idea, but as
that involves pretty big behavior changes that's better left for a
separate series.

Changes since v3:
 - rebased to the latest misc-next tree
 - remove a spurious ClearPageError call

Changes since v2:
 - fix a commit message typo
 - don't use simplify in commit message titles

Changes since v1:
 - fix a pre-existing bug clearing the uptodate bit for subpage eb
   write errors
 - clean up extent_buffer_write_end_io a bit more

Diffstat:
 compression.c |    4 
 compression.h |    2 
 disk-io.c     |  276 +++-----------------------
 disk-io.h     |    5 
 extent_io.c   |  606 ++++++++++++++--------------------------------------------
 extent_io.h   |    3 
 6 files changed, 197 insertions(+), 699 deletions(-)
