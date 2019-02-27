Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDEEC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 18:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E90972183F
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 18:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbfB0Sfb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 13:35:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:49512 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726356AbfB0Sfb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 13:35:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AC2D0ABC3;
        Wed, 27 Feb 2019 18:35:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4167BDA83C; Wed, 27 Feb 2019 19:36:50 +0100 (CET)
Date:   Wed, 27 Feb 2019 19:36:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.cz>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: zstd ensure reclaim timer is properly cleaned
 up
Message-ID: <20190227183650.GC31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190222195348.2728-1-dennis@kernel.org>
 <20190227164441.GY24609@twin.jikos.cz>
 <20190227182916.GA18373@dennisz-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190227182916.GA18373@dennisz-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 27, 2019 at 01:29:16PM -0500, Dennis Zhou wrote:
> > I've noticed while reading the code, why do you use the indirect call
> > here? The wsm.ops points to btrfs_zstd_compress so free_workspace is
> > always zstd_free_workspace.
> > 
> > The compiler is usually smart to replace such things by direct call if
> > the type has not escaped, but this is not true for btrfs_compress_op so
> > the indirect function call must be preserved.
> 
> I don't have a strong reason to use the indirect call here. It was just
> to make it consistent for everyone to use the indirection. This at least
> is in the cleanup path, so I don't think performance is that important?

It's not just that, the timer uses it too and there are indirect calls
of the alloc_workspace callback. The indirection is not used by lzo nor
zlib code, so I don't see what 'everyone' you mean. In the generic
compression code it makes sense, I see that.

> But I don't feel strongly for or against calling zstd_free_workspace()
> directly.

I feel strongly about not using the indirection when not necessary :)
