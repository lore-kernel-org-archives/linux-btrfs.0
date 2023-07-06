Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8855EB64D9
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Jul 2023 12:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbjGFMqL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 08:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbjGFMp6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jul 2023 08:45:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168CD26AE
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Jul 2023 05:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=N7av2H7mWbThwlCCjpWU1A1H07bWGrAY91EG66DPCg0=; b=C/ROExBoikIne/ob+qOQPrKw2p
        GqN+wkf+5vXgtXHv4WZo1pcEzwBzQg1Ypfc8mzU0vvx1Fbw9WGKAevH5iiJ+jjgMWHJsBzh+6OVEW
        TEiERB+nQzg8xNUNdPNhj3cRQbPMIjTwKTvUtgaurR3xEdZmRwUtEwQ5EVfE59jzpGq2giWleo2Fy
        AwnX+gAGE1iquZKlL6exNEEfSn4K6Mmvpyt9g9ilm9z5kmYHT8DGA5SfHCEVAELP0aeKexGZKXD84
        x1srOEwt4uPCxm+ATpfnJln0sPXBYpkVtW55IQrNoACJaDgnA6nzemritLxYG1gsFt5Yry3I8+1a+
        aylxSNQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qHOMY-001g2U-2C;
        Thu, 06 Jul 2023 12:45:34 +0000
Date:   Thu, 6 Jul 2023 05:45:34 -0700
From:   "hch@infradead.org" <hch@infradead.org>
To:     Naohiro Aota <Naohiro.Aota@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: zoned: do not zone finish data relocation block
 group
Message-ID: <ZKa3bnLcoIYhlBRc@infradead.org>
References: <be28a2d61abdee6846100406b4398ee67c0d2e53.1687913786.git.naohiro.aota@wdc.com>
 <ZJu/zlldO9zfsjj9@infradead.org>
 <ucjwozqs7nlnjkwnesakilf6f22aplfefcvzaj6yylgqkb2mc5@62o3xpcjnyfw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ucjwozqs7nlnjkwnesakilf6f22aplfefcvzaj6yylgqkb2mc5@62o3xpcjnyfw>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jun 29, 2023 at 08:27:32AM +0000, Naohiro Aota wrote:
> No. When there are multiple writers, we may need to sacrifice a currently
> active block group to be zone finished for a new allocation. We choose a
> block group with the least free space left.
> 
> We wait for the existing ordered extents to be finished. But, there is a
> little chance the data relocation BG is finished before an ordered extent
> is created.

Can you expand on this case a bit more in comments and maybe also the
commit log?
