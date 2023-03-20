Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B57C6FD1D
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 Mar 2023 06:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjCTGM7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 20 Mar 2023 02:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjCTGM5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Mar 2023 02:12:57 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C991E9CC
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Mar 2023 23:12:56 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D623168AFE; Mon, 20 Mar 2023 07:12:53 +0100 (CET)
Date:   Mon, 20 Mar 2023 07:12:53 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <jth@kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 09/10] btrfs: remove irq_disabling for ordered_tree.lock
Message-ID: <20230320061253.GC18708@lst.de>
References: <20230314165910.373347-1-hch@lst.de> <20230314165910.373347-10-hch@lst.de> <36f29a8d-f939-a4c3-414f-091131f9aa92@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36f29a8d-f939-a4c3-414f-091131f9aa92@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 17, 2023 at 10:36:35AM +0000, Johannes Thumshirn wrote:
> On 14.03.23 18:00, Christoph Hellwig wrote:
> > The per-inode ordered extent list is not only accessed from process
> 
> s/not// ?

Yes.
