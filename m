Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22AE3C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 18:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E001C2086C
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 18:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbfDASno (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 14:43:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:44160 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728863AbfDASno (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 14:43:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B94A4AE60
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2019 18:43:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 45E9EDA823; Mon,  1 Apr 2019 20:44:53 +0200 (CEST)
Date:   Mon, 1 Apr 2019 20:44:52 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 13/15] btrfs: Optimize unallocated chunks discard
Message-ID: <20190401184452.GA29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190327122418.24027-1-nborisov@suse.com>
 <20190327122418.24027-14-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327122418.24027-14-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 27, 2019 at 02:24:16PM +0200, Nikolay Borisov wrote:
> Currently unallocated chunks are always trimmed. For example
> 2 consecutive trims on large storage would trim freespace twice
> irrespective of whether the space was actually allocated or not between
> those trims.
> 
> Optimise this behavior by exploiting the newly introduced alloc_state
> tree of btrfs_device. A new CHUNK_TRIMMED bit is used to mark
> those unallocated chunks which have been trimmed and have not been
> allocated afterwards. On chunk allocation the respective underlying devices'
> physical space will have its CHUNK_TRIMMED flag cleared. This avoids
> submitting discards for space which hasn't been changed since the last
> time discard was issued.

This means during one mount, right? Because the state is not recorded
on-disk anywhere. This also means that a complete unmount / mount
followed by trim will do the discard on the freed blocks again. I don't
thik there's anything wrong with that, just that this should be put to
the docs.
