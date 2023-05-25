Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89311C7EE2C
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 May 2023 08:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240475AbjEYI6u (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 May 2023 04:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240451AbjEYI6s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2023 04:58:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A23C197
        for <linux-btrfs@vger.kernel.org>; Thu, 25 May 2023 01:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OKoxhPES8HEQNRrYW9TaZiZrE1
        nU3O8BhxSvK4fVCHzOvcxi/1HqFeejrhRdPnItsMappIhUjzHFTRwlP3lZ5dOJttYdMi1/bDkZ8Z4
        q2CBckw7TQO62djlZXJ9r8RfCliJs89BXtPs5EDfyTwH41Qdx86mgJRZK3tLbtwAhRklV8bx1bu/U
        t57jFV2gneYinyP8jR/Uj9S9084y1jx7Bi23XxrcqkP2Sg8euh/LLFieTXZZY7tjA76PSzb2w5Iio
        DfDfDDZ4126QcJA97t8/a28Y2pgCe0RDvQdUsnUkdrsA1vC3hZUiY09J8wHFYdUjbQIJLV4aCYT5h
        9XgfWDag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q26o3-00G4XE-0I;
        Thu, 25 May 2023 08:58:47 +0000
Date:   Thu, 25 May 2023 01:58:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/9] btrfs: open code set_extent_defrag
Message-ID: <ZG8jRwdyiwNYAhTw@infradead.org>
References: <cover.1684967923.git.dsterba@suse.com>
 <14705ec263c747043811d070f32c77a6ab838336.1684967923.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14705ec263c747043811d070f32c77a6ab838336.1684967923.git.dsterba@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
