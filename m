Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA8AECDE46
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 18:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42A98207DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 18:44:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42A98207DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbeJYDOD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 23:14:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:48130 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726685AbeJYDOD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 23:14:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 49AD2AF05;
        Wed, 24 Oct 2018 18:44:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6634ADABAA; Wed, 24 Oct 2018 20:44:43 +0200 (CEST)
Date:   Wed, 24 Oct 2018 20:44:43 +0200
From:   David Sterba <dsterba@suse.cz>
To:     robbieko <robbieko@synology.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: super-recover: fix double free fs_devices
 memory
Message-ID: <20181024184443.GA16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, robbieko <robbieko@synology.com>,
        linux-btrfs@vger.kernel.org
References: <1539332723-5868-1-git-send-email-robbieko@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539332723-5868-1-git-send-email-robbieko@synology.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 04:25:23PM +0800, robbieko wrote:
> From: Robbie Ko <robbieko@synology.com>
> 
> super-recover collects btrfs devices information using existed
> functions scan_one_devices().
> 
> Problem is fs_devices is freed twice. One in __open_ctree_fd() when
> error happens and the other in btrfs_close_devices(recover.fs_devices)
> when root is NULL.
> 
> Commit "30fd6f2e92695c355c8f76b8887cd4fade60cdac" add force-close
> all opened device before program exit, to avoid memory leak in all
> btrfs sub-command.
> Therefore, there is an unnecessary freed of fs_devices in
> btrfs_recover_superblocks.
> 
> Fix this problem by remove unnecessary freed of fs_devices.
> 
> Signed-off-by: Robbie Ko <robbieko@synology.com>

The fix for the double free has been in the devel branch, but thanks
anyway.
