Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6745C43444
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 14:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73077205C9
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 14:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfAQOa5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 09:30:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:56768 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725878AbfAQOa5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 09:30:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F34F1AF64;
        Thu, 17 Jan 2019 14:30:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 21E2FDA83D; Thu, 17 Jan 2019 15:30:22 +0100 (CET)
Date:   Thu, 17 Jan 2019 15:30:21 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] btrfs: honor path->skip_locking in backref code
Message-ID: <20190117143021.GR2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20190116160057.22040-1-josef@toxicpanda.com>
 <ef892414-ea36-271b-35f5-b4f753ff7bea@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ef892414-ea36-271b-35f5-b4f753ff7bea@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 17, 2019 at 09:04:13AM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/1/17 上午12:00, Josef Bacik wrote:
> > qgroups will do the old roots lookup at delayed ref time, which could be
> > while walking down the extent root while running a delayed ref.  This
> > should be fine, except we specifically lock eb's in the backref walking
> > code irrespective of path->skip_locking, which deadlocks the system.
> > Fix up the backref code to honor path->skip_locking, nobody will be
> > modifying the commit_root when we're searching so it's completely safe
> > to do.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>

What can we use from https://patchwork.kernel.org/patch/10725371/ to
add to the changelog? Is the deadlock caused by fb235dc06fac? The fix
applies to stable 4.19+ directly and to 4.14 with context fixups.
Thanks.
