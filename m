Return-Path: <SRS0=iEal=RZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C567CC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 18:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F3FA218FE
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 18:58:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfCVS6S (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 14:58:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:60192 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725998AbfCVS6S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 14:58:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 459B0AE8D
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2019 18:58:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 96BB7DA820; Fri, 22 Mar 2019 19:59:30 +0100 (CET)
Date:   Fri, 22 Mar 2019 19:59:30 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Defer setting new inode mode until after
 do_set_acl succeeds
Message-ID: <20190322185929.GB10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190321155706.16686-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321155706.16686-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 21, 2019 at 05:57:06PM +0200, Nikolay Borisov wrote:
> Currently a reference to inode->i_mode is passed directly to
> posix_acl_update_mode when setting an ACL which results in the inode's
> mode always being changed. In case of errors (e.g. in do_set_acl or
> even starting a transaction) the old mode needs to be re-assigned to
> ->i_mode. This mode recovery is done only in case do_set_acl fails,
> which leads to buggy behavior in case btrfs_start_transaction fails.
> 
> Fix it by simply setting the new mode to a temporary variable which is
> assigned to inode->i_mode's only when do_set_acl succeeds. This covers
> both failure cases explained above.
> 
> Fixes: db0f220e98eb ("btrfs: start transaction in btrfs_set_acl")
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> Changes since v1:
>  * Eliminated unrealted newline change (Johannes)
>  * Fixed logic of when i_mode is set, v1 was causing an uninitialised mode
>  to be assigned to inode->i_mode resulting in fs consistency problems. Fix this
>  by introducing a variable which is set to true when the i_mode needs to be 
>  changed. I know this variable could be eliminated by simply initialising 
>  mode = inode->i_mode and always assigning it in the if (!ret) branch but I 
>  find this somewhat subtle and rather be explicit with the boolean variable. 

Agreed. I folded the missing mode reset to the patch that introduced it
as the Fixes: reference would not work, and adjusted your patch to
simplify it again. Changelog adapted accordingly, only that it's not a
faix but simplification. Please check it once it's pushed to misc-next.

Reviewed-by: David Sterba <dsterba@suse.com>
