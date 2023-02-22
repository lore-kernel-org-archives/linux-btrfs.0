Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2001FC636D6
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Feb 2023 14:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjBVOhg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Feb 2023 09:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjBVOhf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2023 09:37:35 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4B27EC4
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2023 06:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hLaywsVLsS4WX1CuWC7sQbkWWe
        og/dfQyR/THGBIbo6cKNY9cMs7TGE903NnPd87W9hg30puXO6OdZ/4axSJt21El/9fmSDl/h/h2Sr
        3YcmIoO+2Q777VaPpR0yyr7W1M7qSA2fTip/Q/jkDGqWjVFGeK0Kd/OpaSRJstlCohw4ZSB7mKG6m
        ZDIy3YSm2pn6abkkh0WB2ls1vjwQC0TmF37YmVtmXn7Sc70CegWaxiSXFtju1V4C2FEDrt/+GPS3M
        nSxSoO5sSEthZrJoqTCFxpU9vnKd6ZyB7p+DZrqRaqaCmPL8tQOtcm9ytiaaEV2FBo4MqQ6O/EZkQ
        3w8y5AvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pUqFS-00Chbs-TY; Wed, 22 Feb 2023 14:37:34 +0000
Date:   Wed, 22 Feb 2023 06:37:34 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 2/2] btrfs: fix dio continue after short write due to
 buffer page fault
Message-ID: <Y/YorlbGK4Uuc/Ho@infradead.org>
References: <cover.1677026757.git.boris@bur.io>
 <b064d09d94fb2a15ad72427962df400e37788d0c.1677026757.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b064d09d94fb2a15ad72427962df400e37788d0c.1677026757.git.boris@bur.io>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
