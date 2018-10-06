Return-Path: <SRS0=jasM=MS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32EE2C64EB8
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C49782087D
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:30:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D/gcLurV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C49782087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbeJFRdP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Oct 2018 13:33:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33166 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbeJFRdP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Oct 2018 13:33:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=57wlrcvnvveWX2pmFFkuFLlrUsVaeKzvD1s81F+bwo8=; b=D/gcLurVb6oHoMZKDIiLyJ5zM
        ghnCeaJfHoxCt5jssv3RShkPUlvq2SoJ6C3k+U/oXDyix00Pcxw0T21SoCPAYP3TQrGiVYFmHerxd
        FliDyCNUudjh7/zdqsmnbHGEprCD5mUbVSUv6d4yZUVXOzgt2FnePqUqyNAbishhHNBFv42T7eIFB
        gmANwpDedwkBA8wklcrcfE4O04hulUzGJ20hLzFAOnECZ1Osl59FUBXy9qwACiuovxxs7tHRCOvps
        hMypaBxvTMf8izoCMn4kC17QyfZW8Q5R7VTK2bGiavSFxSySrHlyYWAz5KKeYmwMn4yK6agcE/9uv
        bOplC6Kqg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g8jqw-00082Q-LW; Sat, 06 Oct 2018 10:30:30 +0000
Date:   Sat, 6 Oct 2018 03:30:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        sandeen@redhat.com
Subject: Re: [PATCH 02/15] xfs: refactor clonerange preparation into a
 separate helper
Message-ID: <20181006103030.GA25747@infradead.org>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870028762.29072.5369530877410002226.stgit@magnolia>
 <20181005052809.GB12041@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005052809.GB12041@dastard>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 05, 2018 at 03:28:09PM +1000, Dave Chinner wrote:
> I've added:
> 
> --
> This rework also moves the invalidation of the destination range to
> the prep function so that it is done before the range is remapped.
> This ensures that nobody can access the data in range being remapped
> until the remap is complete.
> --
> 
> Sound OK?
> 
> Otherwise this looks fine.

Given that the patch will need a respin anyway I'd rather split the
move of the pagecache invalidation into a separate patch.
