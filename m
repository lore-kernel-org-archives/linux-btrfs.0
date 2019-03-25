Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB2AC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 19:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC49E20850
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 19:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbfCYTV2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 15:21:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:44264 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729473AbfCYTV2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 15:21:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 13A72AF32;
        Mon, 25 Mar 2019 19:21:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 050F5DA98F; Mon, 25 Mar 2019 20:22:39 +0100 (CET)
Date:   Mon, 25 Mar 2019 20:22:38 +0100
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Filipe Manana <fdmanana@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] btrfs: Perform locking/unlocking in
 btrfs_remap_file_range()
Message-ID: <20190325192238.GP10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Filipe Manana <fdmanana@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190225190744.21664-1-rgoldwyn@suse.de>
 <20190225190744.21664-3-rgoldwyn@suse.de>
 <CAL3q7H4JXORsxn5LB2ZK2Mg2wSyZcSgq3P4zFavN-nLQyn2V-A@mail.gmail.com>
 <20190226125717.6seq2y7vjbh5hyud@merlin>
 <20190227145242.GO24609@twin.jikos.cz>
 <20190227150624.GP24609@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190227150624.GP24609@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 27, 2019 at 04:06:24PM +0100, David Sterba wrote:
> So the unchecked access to inode flags does not happen, I did not have a
> clear picture of the change. The locks are only moved outside of _prep
> to the caller.
> 
> The lock/unlock look better in the same function, they're close toe each
> other on the same page, so ok from me.

I've applied the patch and only left the locking changes, as discussed.
