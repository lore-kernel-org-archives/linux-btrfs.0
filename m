Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A6BBC65BA7
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 05:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE86920834
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 05:28:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE86920834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbeJEMZq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 08:25:46 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50160 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727558AbeJEMZq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 08:25:46 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail07.adl2.internode.on.net with ESMTP; 05 Oct 2018 14:58:39 +0930
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1g8IfH-0003Bf-3S; Fri, 05 Oct 2018 15:28:39 +1000
Date:   Fri, 5 Oct 2018 15:28:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@redhat.com, Zorro Lang <zlang@redhat.com>,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 03/15] xfs: zero posteof blocks when cloning above eof
Message-ID: <20181005052839.GC12041@dastard>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870029414.29072.6572683664719818617.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153870029414.29072.6572683664719818617.stgit@magnolia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 05:44:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're reflinking between two files and the destination file range
> is well beyond the destination file's EOF marker, zero any posteof
> speculative preallocations in the destination file so that we don't
> expose stale disk contents.  The previous strategy of trying to clear
> the preallocations does not work if the destination file has the
> PREALLOC flag set.
> 
> Uncovered by shared/010.
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Bugzilla-id: https://bugzilla.kernel.org/show_bug.cgi?id=201259
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_reflink.c |   33 +++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
