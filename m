Return-Path: <SRS0=jasM=MS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034E6C65BD0
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFF882148C
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:41:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ubcspm8q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFF882148C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbeJFRoV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Oct 2018 13:44:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33834 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbeJFRoV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Oct 2018 13:44:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VgAczyPVElIZf4Z4AYIxma9rBLPt7lRvQ+NbAMyAeG0=; b=Ubcspm8qkvnj6+KENEba2q++u
        o1xpDSTo0OprGY0ZLrbBQ1LW8mfX7XS4m1dDX5L5wkIGatpJY21WaS96soBTOYtZmiFW8vPu/eWCc
        s27zAl47os0cwwi96f10DiqdenvSdqd42Pwm+PzW5ToBvGtrBkeern0wWKkhk3m4IFvrUWK7JcMBP
        clI8XUePcDeTydwXgm3iOO+II30OPckMRabCr1GeCgJEXBeFWta921OBM5SYJTrAZ1s+ZlqPPNYg4
        oXYNR6SlIpu7ElwJW5SIwVqbHAZfCFY5uTe8oGBHjI+Bu2IGjkrfbH2fjPWKU6OL2xtai9vaRKCp+
        rUXTJ21Vg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g8k1e-0002jj-M6; Sat, 06 Oct 2018 10:41:34 +0000
Date:   Sat, 6 Oct 2018 03:41:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, sandeen@redhat.com
Subject: Re: [PATCH 08/15] vfs: change clone and dedupe range function
 pointers to return bytes completed
Message-ID: <20181006104134.GF25747@infradead.org>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870033496.29072.3660384210745578982.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153870033496.29072.3660384210745578982.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 05:45:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Change the clone_file_range and dedupe_file_range functions to return
> the number of bytes they operated on.  This is the precursor to allowing
> fs implementations to return short clone/dedupe results to the user,
> which will enable us to obey resource limits in a graceful manner.

For clone this doesn't make any sense, as we don't allow 'short clones'.
