Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A41C71133
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 18:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B291E208E4
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 18:19:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qQHiANKv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B291E208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbeJPCFi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 22:05:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59546 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbeJPCFi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 22:05:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=i7YUa4vTAo4EF+2fMvPDq86Cyo9r04FcJ0JCR0CY7DE=; b=qQHiANKvY5m0A2khkroVRzUnN
        u8fQKhanyr+6z0mNXWpXlWIdrLrZ/bXLpJs43bnGtyokQTlYi0PHu+mSiB76QDaGCrzRutVzCv1/5
        ilmnId+VAqOKqx9J+CWapRY0oTDgwrSoJ7Kss4ne0E0POlIxkW2rXpX/s1vLFEaWZpV/Fi5dZwCJy
        40Q2FOeu4za52J/MurZGAJvNGlsx6IqB2k894ZBsIoP6vTJH5EUadUKJpCWtlZoj3EI5l65d6kKvR
        hSrsEDgvWORacuhb0gooYBrVszKYAkE6Rh0c8AmUoGhJ4BWPtploHfQqoEqNILrmW3rQhfrcnV7o2
        lUfRO8kUw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gC7SU-0003r3-BM; Mon, 15 Oct 2018 18:19:14 +0000
Date:   Mon, 15 Oct 2018 11:19:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, david@fromorbit.com,
        sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 10/25] vfs: create generic_remap_file_range_touch to
 update inode metadata
Message-ID: <20181015181914.GA14558@infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938921180.8361.13556945128095535605.stgit@magnolia>
 <20181014172131.GE30673@infradead.org>
 <20181015163001.GK28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181015163001.GK28243@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 09:30:01AM -0700, Darrick J. Wong wrote:
> I originally thought "touch" because it updates [cm]time. :)
> 
> Though looking at the final code, I think this can just be called from
> the end of generic_remap_file_range_prep, so we can skip the export and
> all that other stuff.

I though about that, but the locking didn't seem to quite work out
between xfs and ocfs.

Nevermind the big elephant of actually converting btrfs to the "VFS"
helper - I think if that doesn't work out it is rather questionable
how generic they actually are.
