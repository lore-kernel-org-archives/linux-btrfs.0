Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18DBC64ED8
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Feb 2023 13:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjB0NkK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 Feb 2023 08:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjB0NkK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2023 08:40:10 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CD720D02
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Feb 2023 05:39:39 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 208A167373; Mon, 27 Feb 2023 14:39:13 +0100 (CET)
Date:   Mon, 27 Feb 2023 14:39:12 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com
Subject: Re: [PATCH] btrfs: move all btree initialization into
 btrfs_init_btree_inode
Message-ID: <20230227133912.GA16298@lst.de>
References: <20230219181022.3499088-1-hch@lst.de> <02026707-320e-5c2d-b35e-23290dfc36cc@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02026707-320e-5c2d-b35e-23290dfc36cc@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks Anand.  The fix looks good to me.  The error handling is a bit
confsing and hopefully we can get it fixed up eventually.

Just curious how you found the error as I didn't see anything in
xfstest runs.
