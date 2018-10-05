Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E94BC65BA7
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 05:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29B7B2084D
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 05:30:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29B7B2084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbeJEM1q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 08:27:46 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:1105 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727179AbeJEM1q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 08:27:46 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail07.adl2.internode.on.net with ESMTP; 05 Oct 2018 15:00:39 +0930
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1g8IhC-0003C3-66; Fri, 05 Oct 2018 15:30:38 +1000
Date:   Fri, 5 Oct 2018 15:30:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        sandeen@redhat.com
Subject: Re: [PATCH 04/15] xfs: update ctime and remove suid before cloning
 files
Message-ID: <20181005053038.GD12041@dastard>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870030069.29072.11055871953561649172.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153870030069.29072.11055871953561649172.stgit@magnolia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 05:45:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Before cloning into a file, update the ctime and remove sensitive
> attributes like suid, just like we'd do for a regular file write.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_reflink.c |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Because this fixes a security related problem, I'm going to push
this with the data corruption fixes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
