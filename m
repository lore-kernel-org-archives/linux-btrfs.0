Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7935C433F5
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Apr 2022 07:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245204AbiDKHQ0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 03:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244947AbiDKHQZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Apr 2022 03:16:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0EC2AD4;
        Mon, 11 Apr 2022 00:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VE69n5JstuVVRalza8+d3h/gNCcf7Izwpe+yje9qvvE=; b=xFjyy7/NZVkL/9AvHLALgx1Qrc
        7FtzG4qb9TxCr2Ibo5S04TiAcPqfIL4ngHwSdf2B6+wlT5Vd3PZuU2nApBVN6JkLGUyUFRlEf6a/Q
        neNtpulu3LTzHYPzSQIubpDjnY8Fqi09GSe19UVBVgb9eNjW3GgsLLTM5Vw7UsrTa3kMOZpmzsMbC
        itkrqOXusSpeGgCKkElOR80YmgRMd9NeFgOZwMfyuDQfQPQcf7bii1l8IUqL93+s2lB2VCR3f3H8G
        SlC0QzSaOSIocCzcGyDVLbPcy91EKiq1iMF4oEwQ/q1fupdDuayjjbbJc+BpMxHj5J43tX61uOdor
        hclSEODQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ndoFW-0078ZF-EV; Mon, 11 Apr 2022 07:14:10 +0000
Date:   Mon, 11 Apr 2022 00:14:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs: avoid double clean up when submit_one_bio()
 failed
Message-ID: <YlPVQtbeJ9qQVDzg@infradead.org>
References: <cover.1649657016.git.wqu@suse.com>
 <6b8983dd0a3a28155fa7d786bae0a8bf932cdbab.1649657016.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b8983dd0a3a28155fa7d786bae0a8bf932cdbab.1649657016.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 11, 2022 at 02:12:49PM +0800, Qu Wenruo wrote:
> +	/*
> +	 * Above submission hooks will handle the error by ending the bio,
> +	 * which will do the cleanup properly.
> +	 * So here we should not return any error, or the caller of
> +	 * submit_extent_page() will do cleanup again, causing problems.
> +	 */
> +	return 0;

This should not return anything.  Similar to how e.g. submit_bio
works it needs to be a void return.  And yes, that will properly
fix all the double completion issues.
