Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B829EECAAD3
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Sep 2022 09:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiIGJNF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Sep 2022 05:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIGJNB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Sep 2022 05:13:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BC5B0885
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Sep 2022 02:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6eoInaj21QdwMGURUzcmFow6nOEVRNLWO78cqz/RRy8=; b=2M4ksgYQrSRy60FfG/CpulI/5c
        d7GfYNjp7ffN6i4LAnkzO70CsgJQbwisXhuQUEL0SD3ktkVMte/RAgKfJIUznlYb1fkrBbkos8h9J
        dn878R9rKbMz8/2nX2BhIH77MdLKWKw46JaqafwHgpCpznu+lhq4Kr9KyzLJm/upL6SLV0vfl9i7k
        xH+eIOMTFEmYHCEwQQ7hIuMbpzTo2wBo+2ncVPbs0dZ1cQDx6EkN5CS7fIjMzH/bspRl/k+36cyWx
        ajThn6L6FsD2cEYmEiF1iCvPq/ukYDC10t/pMZgWcvKIYBJJeApBene0U0DXGJu104G3HHuzVhVLr
        yFX+It6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVr79-004ihT-MQ; Wed, 07 Sep 2022 09:12:55 +0000
Date:   Wed, 7 Sep 2022 02:12:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/10] btrfs: make lseek and fiemap much more efficient
Message-ID: <Yxhgl/p7xF1UfqHO@infradead.org>
References: <cover.1662022922.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1662022922.git.fdmanana@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On a related question:  have you looked into using iomap for fiemap
seek in btrfs?  This won't remove the need for fixing some of the
underlying algorithmic complexity, but it should allow to shed some
boilerplate code and reuse bits used by other disk based file systems.
