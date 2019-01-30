Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14374C282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 17:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFEFB21473
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 17:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732307AbfA3RKT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 12:10:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:38968 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728720AbfA3RKS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 12:10:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 818D4AFDF;
        Wed, 30 Jan 2019 17:10:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B0267DA78C; Wed, 30 Jan 2019 18:09:42 +0100 (CET)
Date:   Wed, 30 Jan 2019 18:09:41 +0100
From:   David Sterba <dsterba@suse.cz>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs/btrfs: On error always free subvol_name in btrfs_mount
Message-ID: <20190130170941.GX2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <87lg32p7y3.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lg32p7y3.fsf@xmission.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 30, 2019 at 07:54:12AM -0600, Eric W. Biederman wrote:
> 
> The subvol_name is allocated in btrfs_parse_subvol_options and is
> consumed and freed in mount_subvol.  Add a free to the error paths that
> don't call mount_subvol so that it is guaranteed that subvol_name is
> freed when an error happens.
> 
> Fixes: 312c89fbca06 ("btrfs: cleanup btrfs_mount() using btrfs_mount_root()")
> Cc: stable@vger.kernel.org
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: David Sterba <dsterba@suse.com>
> Cc: linux-btrfs@vger.kernel.org
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Added to 5.0-rc queue, thanks.
