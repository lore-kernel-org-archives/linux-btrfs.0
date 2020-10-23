Return-Path: <SRS0=6VRt=D6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F4B0C388F9
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Oct 2020 11:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 474D124182
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Oct 2020 11:12:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OMKi+iP3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462773AbgJWLMQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 07:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462745AbgJWLMP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Oct 2020 07:12:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D111FC0613CE
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2020 04:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cPbbMZ9v+Zri7j8F1x5ABu+SXml0X/q0hJ+eKNEvbUU=; b=OMKi+iP3SqZlqFFqh9Td/z1pIR
        ABdu7bD1dS+KyEuVVM4D5PD1TXmCJ/VcDzq0ukPlHFudJQtXDOvZU5GDv/EOCu4M8NXMjCNX0MWHS
        DsDSQSv0wBp0evmrXnLxOSAWCQ2ToX1jmv2cDSJOhHARMT1bTIByta9/pAIYLbwzB0IiwQJxGVCGB
        o7i2jlA0GIZxmYJOWzFMjAx8XPl/XgpzZb6Nmsa2rbVUbHecW/4ffW+fPwhvYdi4iid/R5pFbZcah
        MRDvmRbGfb0oy2LmmwLLDCB7hCq0GM/gHNMSFvozhWsoHhUiBqdxwbcqMDK+OrPitpt5K+W7LVmOq
        tdpqshMw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kVuzU-0005pH-SN; Fri, 23 Oct 2020 11:12:12 +0000
Date:   Fri, 23 Oct 2020 12:12:12 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org, josef@toxicpanda.com, dsterba@suse.com
Subject: Re: [PATCH v9 1/3] btrfs: add btrfs_strmatch helper
Message-ID: <20201023111212.GA22167@infradead.org>
References: <cover.1603347462.git.anand.jain@oracle.com>
 <75264e50d49f3c68cc14dc87510c8f3767390dcf.1603347462.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75264e50d49f3c68cc14dc87510c8f3767390dcf.1603347462.git.anand.jain@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> +	if ((strncmp(stripped, golden, len) == 0) &&
> +	    (strlen(skip_spaces(stripped + len)) == 0))

No need for the inner braces.
