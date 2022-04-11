Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900DEC433EF
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Apr 2022 12:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343792AbiDKMZq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 08:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235625AbiDKMZn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Apr 2022 08:25:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B071143AFF
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2022 05:23:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC1FC61624
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2022 12:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0092C385A3;
        Mon, 11 Apr 2022 12:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649679807;
        bh=I1VZmfYuU80NvaCZC+AAvLMouCAlUbaZpw+iuZ2CqIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VQEjttVRw50GVSTO4Klttxb4kgHFnxp5bRLUUIY1cqqzpfl+wKM4gJF/EIuZ0cg1d
         qgaHAeSb4iiNrJgp4668dfYi6Ktie1cXZcyRsuXxIpk1rqitW1QbX+IZabXBdM2ivd
         1QiZiW/95FgAHqS3R65ZsQEJqtvl+cRHNk6PxE4s=
Date:   Mon, 11 Apr 2022 14:23:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] btrfs: make submit_one_bio() to return void
Message-ID: <YlQdvFjBq8ESu3Yz@kroah.com>
References: <cover.1649657016.git.wqu@suse.com>
 <e4bb98b5884a77114ef0334dee6677e6e6260ea7.1649657016.git.wqu@suse.com>
 <YlPWXw+cWtMG0kE8@infradead.org>
 <32af072b-ab06-9a89-ad6b-0503106cef94@suse.com>
 <YlQb9pH6dQ1zL8ix@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlQb9pH6dQ1zL8ix@infradead.org>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 11, 2022 at 05:15:50AM -0700, Christoph Hellwig wrote:
> On Mon, Apr 11, 2022 at 03:20:47PM +0800, Qu Wenruo wrote:
> > > This really should go into patch 1.
> > > 
> > Stable tree won't be happy about the size.
> 
> Really?  I've never really seen stable maintainers complain about
> the size of a patch.  Especially if it is almost 100% removal of buggy
> code.

That sounds like a great patch to take for stable kernels :)
