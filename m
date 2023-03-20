Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C8FC7618A
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 Mar 2023 06:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjCTGOP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 20 Mar 2023 02:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjCTGOO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Mar 2023 02:14:14 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF0A1CBE4
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Mar 2023 23:14:13 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A481D68AFE; Mon, 20 Mar 2023 07:14:10 +0100 (CET)
Date:   Mon, 20 Mar 2023 07:14:10 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <jth@kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: defer all write I/O completions to process context
Message-ID: <20230320061410.GD18708@lst.de>
References: <20230314165910.373347-1-hch@lst.de> <2502ff6d-a1fa-a8f4-fcc4-2d86660c089c@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2502ff6d-a1fa-a8f4-fcc4-2d86660c089c@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 17, 2023 at 10:39:41AM +0000, Johannes Thumshirn wrote:
> But I have a general question, which even might sound pretty dumb. As we're
> out of IRQ/atomic contexts now, do we even need spinlocks or would a mutex
> suffice as well?

Once we're not acquiring a lock from any atomic context, it could
become a mutex.  That being said spinlocks are the smaller and simpler
data structure, and tend to perform better for short criticial sections.
So unless we have a good reason to change any specific lock, I would
not change the locking primitive.
