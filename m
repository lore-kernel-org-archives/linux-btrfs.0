Return-Path: <SRS0=zDud=5F=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C8BC4332D
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 Mar 2020 14:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D56A320754
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 Mar 2020 14:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgCTOLo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 10:11:44 -0400
Received: from verein.lst.de ([213.95.11.211]:47780 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgCTOLn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Mar 2020 10:11:43 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 41AB168B05; Fri, 20 Mar 2020 15:11:42 +0100 (CET)
Date:   Fri, 20 Mar 2020 15:11:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/15] btrfs: read repair/direct I/O improvements
Message-ID: <20200320141142.GA25658@lst.de>
References: <cover.1583789410.git.osandov@fb.com> <20200320141041.GA25256@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320141041.GA25256@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 20, 2020 at 03:10:41PM +0100, Christoph Hellwig wrote:
> Btw, while you touch this code:
> 
> It seems like btrfs_dio_private.subio_endio is rather pointless,
> as it is always set to one function for reads and otherwise never
> set.  De-virtualizing this call could help making the code a little
> faster and easier to understand.

Doh, one of the later patches actually kills it.  Time for more coffee..
