Return-Path: <SRS0=lsqs=WZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2E6C3A59F
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Aug 2019 16:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3ACA205ED
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Aug 2019 16:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfH2QGF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 12:06:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:41826 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726973AbfH2QGF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Aug 2019 12:06:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 68978B69B;
        Thu, 29 Aug 2019 16:06:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A5CC0DA809; Thu, 29 Aug 2019 18:06:26 +0200 (CEST)
Date:   Thu, 29 Aug 2019 18:06:26 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: add BTRFS_DEV_ITEMS_OBJECTID in comment
 in print-tree
Message-ID: <20190829160626.GK2752@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20190828095619.9923-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828095619.9923-1-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 28, 2019 at 05:56:18PM +0800, Anand Jain wrote:
> So when searching for BTRFS_DEV_ITEMS_OBJECTID it hits. Albeit it is
> defined same as BTRFS_ROOT_TREE_OBJECTID.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

1-2 applied, thanks.
