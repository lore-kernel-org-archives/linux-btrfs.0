Return-Path: <SRS0=p7dB=RE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2216FC43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 16:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E967420850
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 16:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388913AbfCAQkh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Mar 2019 11:40:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:59878 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728449AbfCAQkh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Mar 2019 11:40:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 34D8FADD7;
        Fri,  1 Mar 2019 16:40:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 452BCDA851; Fri,  1 Mar 2019 17:41:56 +0100 (CET)
Date:   Fri, 1 Mar 2019 17:41:56 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND 1/2] btrfs-progs: check for no result before using
 results
Message-ID: <20190301164156.GT31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1548929141-10695-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548929141-10695-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 31, 2019 at 06:05:40PM +0800, Anand Jain wrote:
> User space understands the ioctl BTRFS_IOC_DEV_REPLACE command status
> using the struct btrfs_ioctl_dev_replace_args::result, and so userspace
> initializes this to BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT, so exclude
> this value in checking for the error.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

1 and 2 applied, thanks.
