Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74BFC433EF
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Apr 2022 04:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiDEFB0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 01:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiDEFBK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2022 01:01:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD821C1
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Apr 2022 21:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jySjR+ynWVogIFpbluAR+jwp0IT/dW87rSjH7LEahlk=; b=3XaozYmEIwhdanAboCr+s3Dzvt
        6VPu4KCbOCiMxvXVQLSZrrLSjV7scIxBgUi0qkOMg090aInbjJR5c59jYT+qmgcLNyHa4YPkvIEVJ
        P3We54m+HkG62j5cuf2zOlukdUMvf46ThWUivOQmngKWanF1CFWys1E7w2QCyRXg9sA2G80DKQlL7
        a3pQb3csiA4y0DgkVli80PKOrM9Zx6flEFU2aMIZ0NFJzxanDA0dfZCBdutXt4LGh3I5QkfXBoJb8
        sU1kV1ArhuDcNJoqzMjwf+fPIRn54gMEgBpZXBvPdguV+sn7RhD3qAWtPf3bZAy/I50J+yvt7jWZy
        M6382ZvA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nbbGs-00H7Cw-S3; Tue, 05 Apr 2022 04:58:26 +0000
Date:   Mon, 4 Apr 2022 21:58:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: replace a wrong memset() with memzero_page()
Message-ID: <YkvMcoK5m7tZ3GUM@infradead.org>
References: <8d6f911a0282eba76f9e05d6f1e7c6f091d4870b.1648199349.git.wqu@suse.com>
 <Yj3v+MnFOXeeAU9d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yj3v+MnFOXeeAU9d@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 25, 2022 at 09:38:16AM -0700, Christoph Hellwig wrote:
> > -	memset(kaddr + pgoff, 1, len);
> > +	memzero_page(page, pgoff, len);
> >  	flush_dcache_page(page);
> 
> memzero_page already takes care of the flush_dcache_page.

David, you've picked this up with the stay flush_dcache_page left in
place.  Plase try to fix it up instead of spreading the weird cargo cult
flush_dcache_page calls.
