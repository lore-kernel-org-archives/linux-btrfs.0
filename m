Return-Path: <SRS0=WhU1=6V=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436CCC38A2A
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 May 2020 13:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28D0720708
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 May 2020 13:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgEGNo3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 May 2020 09:44:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:54502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgEGNo2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 May 2020 09:44:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 552DBADCF;
        Thu,  7 May 2020 13:44:30 +0000 (UTC)
Date:   Thu, 7 May 2020 08:44:23 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/9] btrfs: Switch to iomap_dio_rw() for dio
Message-ID: <20200507134423.flccwz3wkeos5rjw@fiona>
References: <20200326210254.17647-1-rgoldwyn@suse.de>
 <20200326210254.17647-5-rgoldwyn@suse.de>
 <20200327081024.GA24827@infradead.org>
 <20200327161348.to4upflzczkbbpfo@fiona>
 <20200507061430.GA8939@infradead.org>
 <20200507113741.GJ18421@twin.jikos.cz>
 <20200507121037.GA25363@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507121037.GA25363@infradead.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On  5:10 07/05, Christoph Hellwig wrote:
> On Thu, May 07, 2020 at 01:37:41PM +0200, David Sterba wrote:
> > On Wed, May 06, 2020 at 11:14:30PM -0700, Christoph Hellwig wrote:
> > > What is the status of this series?  I haven't really seen it posted
> > > any time recently, and it would be sad to miss 5.8..
> > 
> > I've been testing it and reporting to Goldwyn, but there are still
> > problems that don't seem to be fixable for 5.8 target.
> 
> What are the issues, and how can we help to resolve them?

The issue we are facing is with generic/475

The problems is that in case of a device error, there are still remnants in
the inode reservation which causes the WARN_ON() during
btrfs_destroy_inode(). I am trying to figure out the precise conditions
that are causing these remnants in only some of the inodes.

-- 
Goldwyn
