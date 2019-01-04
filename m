Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFFDC43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 15:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0E0C2070C
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 15:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfADPOF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 10:14:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:53788 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725939AbfADPOF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 10:14:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AF489AEF8;
        Fri,  4 Jan 2019 15:14:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 61E02DA7CE; Fri,  4 Jan 2019 16:13:35 +0100 (CET)
Date:   Fri, 4 Jan 2019 16:13:35 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v14] Add cli and ioctl to forget scanned device(s)
Message-ID: <20190104151335.GO23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1546579914-14971-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546579914-14971-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 04, 2019 at 01:31:51PM +0800, Anand Jain wrote:
> v14:
>  Splits refactoring part of btrfs_free_stale_devices() into a new patch
> 
> Anand Jain (2):
>   btrfs: refactor btrfs_free_stale_devices() to get return value
>   btrfs: introduce feature to forget a btrfs device

Added as topic branch to for-next, thanks.
