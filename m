Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36230C433FE
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Mar 2022 00:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356844AbiCYAJk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 20:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357006AbiCYAJi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Mar 2022 20:09:38 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A1C45FC8;
        Thu, 24 Mar 2022 17:08:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D9CB4533EBF;
        Fri, 25 Mar 2022 11:08:02 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nXXUl-009VAR-VX; Fri, 25 Mar 2022 11:07:59 +1100
Date:   Fri, 25 Mar 2022 11:07:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] fstests: generic/373: change test to validate
 cross-vfsmount reflink
Message-ID: <20220325000759.GK1609613@dread.disaster.area>
References: <cover.1648153387.git.josef@toxicpanda.com>
 <57a8ad46edcacf08778b16c9eadb603a1638bf17.1648153387.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57a8ad46edcacf08778b16c9eadb603a1638bf17.1648153387.git.josef@toxicpanda.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=623d07e3
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=maIFttP_AAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=EJbU6E-E3oiJzknpgLYA:9 a=CjuIK1q_8ugA:10
        a=qR24C9TJY6iBuJVj_x8Y:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 24, 2022 at 04:24:32PM -0400, Josef Bacik wrote:
> We now allow cross-vfsmount reflinks so change the test to validate that
> cross-vfsmount reflinks work.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  tests/generic/373     | 8 ++++----
>  tests/generic/373.out | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
