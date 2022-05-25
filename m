Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998CFC433FE
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 May 2022 09:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbiEYJA7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 25 May 2022 05:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiEYJA6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 May 2022 05:00:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F1470350
        for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2022 02:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rq3oAyBXrOpACtdx/apZGp0h1vfSvFc7IP7LnmTkpQY=; b=aXDj4Rpf6eipoqz3kkXNDVVJ9L
        q/pak4lxnInvLfinBMyUb2W13z+6y+P8bIXdo3LWjAkOsF5n2oY6Wk6U2fLFhCMPAj99pXDCwAwIO
        2Wome6k58z10G9JPZobgywh3tc/0gNvhlkH+KXQDlLTiiuJ4gW2ecA0LF7KPSjLabBos+wBbclCxM
        NRZtWCbLeLjaH7p2z6FUCWo9Ese2Dt63ibVuYHNZyuDK7/lV2UxYz+XIfiHpsUGjDS7NYX6B+3Bt6
        hG3XICvLeW1FTNLNvFjMuj0r9+ZQO0Lt8zL2DHGicDy4wQ9ZvYB8mjd1ocGT2hNBJksNp3FrnI3Hg
        RuaCrufQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntmsu-00AVXQ-PE; Wed, 25 May 2022 09:00:52 +0000
Date:   Wed, 25 May 2022 02:00:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH DRAFT] btrfs: RAID56J journal on-disk format draft
Message-ID: <Yo3wRJO/h+Cx47bw@infradead.org>
References: <f6679e0b681f9b1a74dfccbe05dcb5b6eb0878f6.1653372729.git.wqu@suse.com>
 <20220524170234.GW18596@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524170234.GW18596@twin.jikos.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 24, 2022 at 07:02:34PM +0200, David Sterba wrote:
> Well, that does not sound encouraging. One option discussed in the past
> how to fix the write hole was to always do full RMW cycle. Having a "not
> fast journal at all" would require a format change and have probably a
> comparable performance drop.

So maybe I'm just dumb, but what is the problem with only using
raid56 for data, forbidding nowcow for it and thus avoiding the
problem entirely?
