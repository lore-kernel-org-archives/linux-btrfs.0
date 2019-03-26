Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C66C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96EB920700
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:10:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y3Dc2c8l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732141AbfCZTKC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:10:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39404 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfCZTKC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 15:10:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rPw576aKvoCAii2fC0/u+vcA6/cwIDBjek6v+kw+Ozw=; b=Y3Dc2c8lfOAKvWdLjg1Y8YDYl
        xfw/Xb1wiQNjZTJSA8eRQyB5iAz4mYTlFjnV5SWOC78Ji/vj/2l9IZHF/bcDdc86DK/yxUchsc8aV
        F86ztiYusZC5GYxf62BeKdmRYVBOLat8N66aI+FadZDubOM7QE/Ugn4vo6s/RYKeAk9SNis7/WoaQ
        ZUvpXUFDkMHdS5gv40wPaC/8NOltrS4BDk9t+TpC9xod8/U14jtKgRnP66boCQMe2INFPR6E9OJye
        fFaphD1pWEStCEvVh3n9n71LUqhvm8H9KrBwPKhrelFeZi5rF9NSTmuInx89QLy3o85UZKPHR3yHb
        nMJLdf9aw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h8rST-0000qN-H1; Tue, 26 Mar 2019 19:10:01 +0000
Date:   Tue, 26 Mar 2019 12:10:01 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 01/15] btrfs: create a mount option for dax
Message-ID: <20190326191001.GP10344@bombadil.infradead.org>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326190301.32365-2-rgoldwyn@suse.de>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 02:02:47PM -0500, Goldwyn Rodrigues wrote:
> This sets S_DAX in inode->i_flags, which can be used with
> IS_DAX().
> 
> The dax option is restricted to non multi-device mounts.
> dax interacts with the device directly instead of using bio, so
> all bio-hooks which we use for multi-device cannot be performed
> here. While regular read/writes could be manipulated with
> RAID0/1, mmap() is still an issue.
> 
> Auto-setting free space tree, because dealing with free space
> inode (specifically readpages) is a nightmare.
> Auto-setting nodatasum because we don't get callback for writing
> checksums after mmap()s.

Congratulations on getting the bear to dance.  But why?

To me, the point of btrfs is all the cool stuff it does with built-in
checksumming and snapshots and RAID and so on.  DAX doesn't let you do
any of that, so why would somebody want to use btrfs to manage DAX?

