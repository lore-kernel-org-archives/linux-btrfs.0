Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C28C43334
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 Jun 2022 07:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbiFTHwW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 20 Jun 2022 03:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239493AbiFTHwU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Jun 2022 03:52:20 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B4EDEEF
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jun 2022 00:52:19 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6FAFC68AA6; Mon, 20 Jun 2022 09:52:16 +0200 (CEST)
Date:   Mon, 20 Jun 2022 09:52:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     dsterba@suse.com
Cc:     Nikolay Borisov <nborisov@suse.com>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: don't limit direct reads to a single sector
Message-ID: <20220620075216.GA12443@lst.de>
References: <20220616080224.953968-1-hch@lst.de> <a2dd54d7-ea9e-8647-261c-7d622f536f53@suse.com> <20220617155812.GB31552@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617155812.GB31552@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

David, I saw this patch is already in misc-next.  Do you want me to
send an incremental patch or a new revision with the limit?  Incremental
would look kinda silly, so I'd prefer the updated version.
