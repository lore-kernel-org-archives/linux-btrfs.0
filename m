Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F0B9C0015E
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Jun 2023 09:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjF1JZk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 05:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236538AbjF1JIj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2023 05:08:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF825358B
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Jun 2023 02:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ORexjxzTAcz8qLe3Y9H1JFPbZpkVVZn/uQRNDK6Cutg=; b=gkv9P9esZg5ojbvzaqrppbFYQ7
        NkV7stI8ZByXmA9aFVMUZibfk8iHLcIlpMoZlRlZG9rPv76NF9agJTnNRLD0fUTF52n3vzYUhwYYE
        HQ9JnySGJr/PjxQGmRBugFX1yOUAKrCRIZFJUqNVN2sY1TiJexJU4rexFoyKNMtgDRoec6WqcJCtY
        ey9RPsNLhfwurJT/yJrImJgsb4uQFEHIIaDQHP3P0nkF8lIeH7P6GcKmW+VxhjN4HUFrnCFJHL0z4
        Cf7+xlPRzdSLcdCsZr5BQOqlQnKm1rAhKYNJ/2XwqAxR2IPnAFIC0SvZ5aI76JG71f6HePLriMhEJ
        33UWuAvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qENNm-00EqSQ-24;
        Wed, 28 Jun 2023 05:06:22 +0000
Date:   Tue, 27 Jun 2023 22:06:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: zoned: do not zone finish data relocation block
 group
Message-ID: <ZJu/zlldO9zfsjj9@infradead.org>
References: <be28a2d61abdee6846100406b4398ee67c0d2e53.1687913786.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be28a2d61abdee6846100406b4398ee67c0d2e53.1687913786.git.naohiro.aota@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 28, 2023 at 09:57:00AM +0900, Naohiro Aota wrote:
> If a block group dedicated to the data relocation is zone finished, there
> is a chance that finishing it before an ongoing write IO reaches the
> device. As a result, the write IO fail.

Why is that the case?  Isn't the zone finish only called when the
last ordered_extent completes?

