Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2262CC001B0
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Jul 2023 15:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjGXPGw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 11:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjGXPGv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2023 11:06:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0F012E
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2023 08:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XMfigVi0zhN1IaEzSnpgtjrS3UMpyIGW7F+V2plKp2Y=; b=Ewm/KfEK9tWJvD1DLLdUjmocP+
        tHNayeVjZpN3/nxuKHzR5irK/CO1//jgrKu84dRKQMv6+gZqHXJPK2tyoZlWDurY9IHZjtlZtPajD
        zS1UjloUsM1YB3IO0KnuhytlPcusozCXPuIjlG2HXH9aFx/9Kt5ldYwAyyXCmuSlW+eyva/T7QUCu
        RquwocsYnaYmELiKY0drFB+xwZPUPPN7plwLRc89oUHcl5/WdIjgv5UUrTrZZ53pYcQqCASsRefYW
        OaZ28I3wo1lZqO3g52CnUCpXpK10qwWIkJiV3/Oh1a2ipM5fGm7FKlybjd7IK5RABRuVLkNmvcRvp
        deRci8UA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qNx98-004gUb-19;
        Mon, 24 Jul 2023 15:06:50 +0000
Date:   Mon, 24 Jul 2023 08:06:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/8] btrfs: zoned: reserve zones for an active
 metadata/system block group
Message-ID: <ZL6TioS4YxPUJEdg@infradead.org>
References: <cover.1690171333.git.naohiro.aota@wdc.com>
 <df9fa11d7d8299b04b99d7276a764bfa318f5734.1690171333.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df9fa11d7d8299b04b99d7276a764bfa318f5734.1690171333.git.naohiro.aota@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> +static int reserved_zones(struct btrfs_fs_info *fs_info)
> +{
> +	const u64 flags[] = {BTRFS_BLOCK_GROUP_METADATA, BTRFS_BLOCK_GROUP_SYSTEM};
> +	int reserved = 0;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(flags); i++) {
> +		u64 profile = btrfs_get_alloc_profile(fs_info, flags[i]);
> +
> +		switch (profile) {
> +		case 0: /* single */
> +			reserved += 1;
> +			break;
> +		case BTRFS_BLOCK_GROUP_DUP:
> +			reserved += 2;
> +			break;
> +		default:
> +			ASSERT(0);
> +			break;
> +		}
> +	}
> +
> +	return reserved;
> +}

Shouldn't we just store the number of reserved zones in fs_info instead
of recalculating this over and over?

