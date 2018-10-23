Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE13C46475
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 14:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F14020665
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 14:06:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F14020665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbeJWW3j (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 18:29:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:47254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726277AbeJWW3j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 18:29:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 06331AD7E;
        Tue, 23 Oct 2018 14:06:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F1A7BDAA74; Tue, 23 Oct 2018 16:05:52 +0200 (CEST)
Date:   Tue, 23 Oct 2018 16:05:51 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/10] btrfs-progs: Pull free space tree related code
 from kernel
Message-ID: <20181023140551.GQ16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
 <1538405181-25231-6-git-send-email-nborisov@suse.com>
 <20181004182636.GE25437@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181004182636.GE25437@vader>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 11:26:36AM -0700, Omar Sandoval wrote:
> On Mon, Oct 01, 2018 at 05:46:16PM +0300, Nikolay Borisov wrote:
> > To help implement free space tree checker in user space some kernel
> > function are necessary, namely iterating/deleting/adding freespace
> > items, some internal search functions. Functions to populate a block
> > group based on the extent tree. The code is largely copy/paste from
> > the kernel with locking eliminated (i.e free_space_lock). It supports
> > reading/writing of both bitmap and extent based FST trees.
> 
> For some reason, a lot of this added code uses spaces instead of tabs,
> so I had to fix that in order to compare it to the kernel code (some of
> the functions were reordered, too).

That for noticing it, fixing whitespace damage on 300 lines makes me
really annoyed even if vim is a great help here. Patch applied but I'm
not doing that next time.
