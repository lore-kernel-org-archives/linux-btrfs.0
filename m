Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D5CC10F00
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 18:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 982DD218CD
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 18:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388062AbfB1SmB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 13:42:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:38234 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbfB1SmB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 13:42:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 18D8BAE3C;
        Thu, 28 Feb 2019 18:42:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D112DDA944; Thu, 28 Feb 2019 19:43:18 +0100 (CET)
Date:   Thu, 28 Feb 2019 19:43:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove indirect function calls from zstd
Message-ID: <20190228184316.GR31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190227212128.38491-1-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190227212128.38491-1-dennis@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 27, 2019 at 04:21:28PM -0500, Dennis Zhou wrote:
> While calling functions inside zstd, we don't need to use the
> indirection provided by the workspace_manager. Forward declarations are
> added to maintain the function order of btrfs_compress_op.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>

Reviewed-by: David Sterba <dsterba@suse.com>
