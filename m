Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323D5C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 15:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F339120818
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 15:41:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F339120818
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388337AbeKPBuP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 20:50:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:55482 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726432AbeKPBuO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 20:50:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CED04ACFB;
        Thu, 15 Nov 2018 15:41:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DC5F7DAC4A; Thu, 15 Nov 2018 16:41:36 +0100 (CET)
Date:   Thu, 15 Nov 2018 16:41:36 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/9 v2] fix replace-start and replace-cancel racing
Message-ID: <20181115154136.GV24115@twin.jikos.cz>
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
> 
> Patches 1/9 and 9/9 are good to have fixes. Makes a function static and
> code readability good.
> 
> Testing: (I did some attempt to convert these into xfstests but need a
> mechanism where kernel thread can wait for user land script. I thought
> I could do it using ebfp, but needs more digging on how).
> As of now hand tested with using procfs to hold kernel thread at
> (wait_for_user(..)) until user land issues go.

This could be tricky to get implemented but would be of course useful. I
saw the crash about once a week so will watch if this still happens.

> Anand Jain (9):
>   btrfs: mark btrfs_dev_replace_start() as static
>   btrfs: replace go back to suspended if target missing
>   btrfs: replace back to suspend state if EXCL OP is running
>   btrfs: fix UAF due to race between replace start and cancel
>   btrfs: replace cancel is successful if scrub cancel is successful
>   btrfs: replace's scrub must not be running in replace suspended state
>   btrfs: quiten warn if the replace is canceled at finish
>   btrfs: user requsted replace cancel is not an error
>   btrfs: add explicit check for replace result no error

The above is merged to misc-next, except:

btrfs: quiten warn if the replace is canceled at finish
btrfs: user requsted replace cancel is not an error

with replies under the patches what could be improved. The changes can
be sent independently if you need to do that in several patches. Thanks.
