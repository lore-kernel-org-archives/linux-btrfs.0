Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93D1C10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 17:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82A2B20880
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 17:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbfDHRBM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 13:01:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:33492 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726726AbfDHRBM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 13:01:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A5C25AE5E
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Apr 2019 17:01:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4790FDA88B; Mon,  8 Apr 2019 19:02:14 +0200 (CEST)
Date:   Mon, 8 Apr 2019 19:02:14 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/4] property fixes and cleanups
Message-ID: <20190408170214.GB29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20190403165134.12378-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190403165134.12378-1-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 04, 2019 at 12:51:30AM +0800, Anand Jain wrote:
> Both mainline and misc-5.2 fails the test case that transaction 
> generation number must be unaltered if the property validation fails.
> 
> For example:
> btrfs in dump-super /dev/sdb | grep ^generation; \
> btrfs prop set /btrfs compression lz; sync; \
> btrfs in dump-super /dev/sdb | grep ^generation
> generation		53
> ERROR: failed to set compression for /btrfs: Invalid argument
> generation		54
> 
> Which the patch in the mailing list fixes and based on misc-5.2
>   [PATCH 4/4 RESEND] btrfs: fix property validate fail should not increment
> 
> But, now I notice that the reason for which the original code failed
> is different from the reason for which misc-5.2 failed. Former failed
> because the malformed 'lz' was only abled to be caught by handle->apply(),
> and in latter we were calling the start_transaction() too early before the
> handle->validation() which few of the patches in misc-5.1 did. My bad.
> 
> As per your misc-5.2 branch please drop the following patches as I have
> better fixes as in this patch.
> 
> 584aebf26bbf btrfs: merge btrfs_setxattr and do_setxattr
> ab54ee38fff7 btrfs: don't create transaction in btrfs_setxattr
> 0cbf560f72e1 btrfs: start transaction in btrfs_xattr_handler_set
> db0f220e98eb btrfs: start transaction in btrfs_set_acl
> 56e9e992c00a btrfs: start transaction in btrfs_set_prop_trans
> 3e2299ea6a8b btrfs: refactor btrfs_set_prop and add btrfs_set_prop_trans
> 737e67ce0f3f btrfs: merge _btrfs_set_prop helpers
> 
> And please apply the patches as in this set.
> 
> Anand Jain (4):
>   btrfs: rename __btrfs_set_prop to btrfs_set_prop_trans
>   btrfs: rename __btrfs_set_acl to do_set_acl
>   btrfs: fix zstd compression parameter
>   btrfs: fix vanished compression property after failed set

I'm going to send the two fixes independently to 5.1 as they affect
current code. Regarding the increased transaction, I don't want to drop
the patches that move transaction around just yet, as they're 100
patches deep in the devel queue.

The validation should happen before the transaction, the code currently
does a few nested calls so this might need further cleanups but I'd
rather go that way than to deleting what's in misc-next and starting
again.

If deleting the current misc-next patches appears to be a better option
in the end, then I'll do that.
