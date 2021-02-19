Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2869BC433E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Feb 2021 19:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB62764E77
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Feb 2021 19:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhBSTC5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Feb 2021 14:02:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:33502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229932AbhBSTCz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Feb 2021 14:02:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C4A47ACCF;
        Fri, 19 Feb 2021 19:02:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4C604DA6FC; Fri, 19 Feb 2021 20:00:15 +0100 (CET)
Date:   Fri, 19 Feb 2021 20:00:15 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix return code for failed replace start
Message-ID: <20210219190015.GJ1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <48194115537d723d04bba0505411525b77f3e73b.1601402292.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48194115537d723d04bba0505411525b77f3e73b.1601402292.git.anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 30, 2020 at 10:46:14AM +0800, Anand Jain wrote:
> When replace-starts with no-background and fails for the reason that
> a BTRFS_FS_EXCL_OP is in progress, we still return the value 0 and also
> leak the target device open, because in cmd_replace_start() we missed
> the goto leave_with_error for this error.
> 
> So the test case btrfs/064 in its seqres.full output reports...
> 
>   Replacing /dev/sdf with /dev/sdc
>   ERROR: /dev/sdc is mounted
> 
> instead of...
> 
>   Replacing /dev/sdc with /dev/sdf
>   ERROR: ioctl(DEV_REPLACE_START) '/mnt/scratch': add/delete/balance/replace/resize operation in progress
> 
> for the failed replace attempts in the test case
> 
> Fix it by adding a goto leave_with_error for this error which also fixes
> the device open leak.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Added to devel, thanks.
