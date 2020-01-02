Return-Path: <SRS0=UIME=2X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B7AC2D0DC
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 14:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E3342085B
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 14:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgABOop (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 09:44:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:35908 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728425AbgABOop (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Jan 2020 09:44:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7447BB145;
        Thu,  2 Jan 2020 14:44:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 759FDDA790; Thu,  2 Jan 2020 15:44:35 +0100 (CET)
Date:   Thu, 2 Jan 2020 15:44:35 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: discard before adding to the free space cache
Message-ID: <20200102144435.GG3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
References: <20191209193846.18162-1-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209193846.18162-1-dennis@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 09, 2019 at 11:38:46AM -0800, Dennis Zhou wrote:
> Returning free space to the free space cache lets it immediately be
> reused. So discard before returning the free space otherwise we can race
> here.
> 
> Fixes: 55e734b728c0 ("btrfs: Don't discard unwritten extents")

Unstable commit id as the patch is still in misc-next, so I'm going to
fold the fix to the original patch. Thanks.
