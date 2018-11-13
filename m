Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E8EC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 17:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFFB4223AE
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 17:33:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFFB4223AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbeKNDci (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 22:32:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:56300 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730730AbeKNDci (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 22:32:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A1B72ABE4;
        Tue, 13 Nov 2018 17:33:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6B291DAD3E; Tue, 13 Nov 2018 18:33:16 +0100 (CET)
Date:   Tue, 13 Nov 2018 18:33:15 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/9 v2] fix replace-start and replace-cancel racing
Message-ID: <20181113173315.GG24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Nov 11, 2018 at 10:22:15PM +0800, Anand Jain wrote:
> v1->v2:
>   2/9: Drop writeback required
>   3/9: Drop writeback required
>   7/9: Use the condition within the WARN_ON()
>   6/9: Use the condition within the ASSERT()
> 
> Replace-start and replace-cancel threads can race to create a messy
> situation leading to UAF. We use the scrub code to write
> the blocks on the replace target. So if we haven't have set the
> replace-scrub-running yet, without this patch we just ignore the error
> and free the target device. When this happens the system panics with
> UAF error.
> 
> Its nice to see that btrfs_dev_replace_finishing() already handles
> the ECANCELED (replace canceled) situation, but for an unknown reason
> we aren't using it to cleanup the replace cancel situation, instead
> we just let the replace cancel ioctl thread to cleanup the target
> device and return and out of synchronous with the scrub code.
> 
> This patch 4/9, 5/9 and 6/9 uses the return code of btrfs_scrub_cancel()
> to check if the scrub was really running. And if its not then shall
> return an error to the user (replace not started error) so that user
> can retry replace cancel. And uses btrfs_dev_replace_finishing() code
> to cleanup after successful cancel of the replace scrub.
> 
> Further, a suspended replace, when tries to restart, and if it fails
> (for example target device missing, or excl ops running) it goes to the
> started state, and so the cli 'btrfs replace status /mnt' hangs with no
> progress. So patches 2/9 and 3/9 fixes that.
> 
> As the originals code idea of ECANCELED was limited to the situation of
> the error only and not user requested, there are unnecessary error log
> and warn log which 7/9 and 8/9 patches fixes.

This fixes quite a few problems, namely the crash in scrub_setup_ctx,
thanks. I'm going to add the patchset to for-next, the code looks good
on first glance.
