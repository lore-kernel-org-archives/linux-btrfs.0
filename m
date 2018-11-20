Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51899C04EBC
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 13:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 650CB206BB
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 13:36:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 650CB206BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbeKUAFJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 19:05:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:53066 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725876AbeKUAFJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 19:05:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 42227ACCD;
        Tue, 20 Nov 2018 13:35:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7C43FDA8A7; Tue, 20 Nov 2018 14:35:39 +0100 (CET)
Date:   Tue, 20 Nov 2018 14:35:39 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND 0/9 v2] fix warn_on for replace cancel
Message-ID: <20181120133539.GJ24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1542714976-28502-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542714976-28502-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 20, 2018 at 07:56:14PM +0800, Anand Jain wrote:
> These two patches were sent as part of
>    [PATCH 0/9 v2] fix replace-start and replace-cancel racing
> before but as these aren't integrated so I am sending these again.
> 
> The patch [1] which is in misc-next, calls btrfs_dev_replace_finishing()
> after replace is canceled, so the ret argument passed to the
> btrfs_dev_replace_finishing() is -ECANCEL, which is not a real error.
> So these patches quieten the warn and error log if its -ECANCEL.
> 
> These should be integrated otherwise we see the WARN_ON and btrfs_error()
> after replace cancel.
> 
> [1] 
> 08bdfc3a0611 btrfs: fix use-after-free due to race between replace start and cancel
> 
> Anand Jain (2):
>   btrfs: quieten warn if the replace is canceled at finish
>   btrfs: user requsted replace cancel is not an error

Thanks, patches added to misc-next, right after the other dev-replace
patches.
