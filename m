Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBE8C433EF
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 May 2022 15:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237967AbiECPL0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 May 2022 11:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237928AbiECPLK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2022 11:11:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1123A5F4
        for <linux-btrfs@vger.kernel.org>; Tue,  3 May 2022 08:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=174/Oo7CzbK+x8nvO0fOFXK94+CdhASYr3xkJTThaLM=; b=o9OHBp6eWr5exLwYsI8AnjsZeL
        k8SPWpG7RjcaKdc8X8OT3qecJ3xe6pfDXCQDODdbQY3XhOZ0wHD2qJ5TQ1Ub8c6la+UxMtz6tl+dq
        EE4d5xatdpQwSPESVGnoGN369YFdrX30hIzGkW+pEEQ3Togfn+rDWomqjSLVriF5+I3IovvQwZ7rx
        BZENToQG0lVFsoNnsaCXaw3ejGhlEtRDwUftrdVJsybYoSpz+fWsaKdMhJhxefVPfzaBVpol/i6ua
        5s2KcQlI/CTz1Hj5qUhTbXdtW0TR55XD3lKCClrn12g3RuJOocvFZ40qiieuhcLxYzXYajp5wkaAg
        JB+BfJig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nlu7l-006Pac-PY; Tue, 03 May 2022 15:07:37 +0000
Date:   Tue, 3 May 2022 08:07:37 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 13/13] btrfs: remove btrfs_inode::io_failure_tree
Message-ID: <YnFFOd6SAPj3goAe@infradead.org>
References: <cover.1651559986.git.wqu@suse.com>
 <4c9d27f81cc9b2c004239f1501cbb28e421f0ad2.1651559986.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c9d27f81cc9b2c004239f1501cbb28e421f0ad2.1651559986.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Please fold this into the previous patch that removes all uses of the
tree.
