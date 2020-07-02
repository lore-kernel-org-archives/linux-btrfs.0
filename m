Return-Path: <SRS0=RJN2=AN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17280C433E0
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jul 2020 08:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED0DF20720
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jul 2020 08:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgGBI0Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 04:26:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:47900 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgGBI0P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Jul 2020 04:26:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 63D70ADC1;
        Thu,  2 Jul 2020 08:26:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4642DDA781; Thu,  2 Jul 2020 10:25:58 +0200 (CEST)
Date:   Thu, 2 Jul 2020 10:25:58 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Waiman Long <longman@redhat.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 11/53] btrfs: use kfree() in
 btrfs_ioctl_get_subvol_info()
Message-ID: <20200702082558.GH27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Waiman Long <longman@redhat.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200702012202.2700645-1-sashal@kernel.org>
 <20200702012202.2700645-11-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702012202.2700645-11-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 01, 2020 at 09:21:20PM -0400, Sasha Levin wrote:
> From: Waiman Long <longman@redhat.com>
> 
> [ Upstream commit b091f7fede97cc64f7aaad3eeb37965aebee3082 ]
> 
> In btrfs_ioctl_get_subvol_info(), there is a classic case where kzalloc()
> was incorrectly paired with kzfree(). According to David Sterba, there
> isn't any sensitive information in the subvol_info that needs to be
> cleared before freeing. So kzfree() isn't really needed, use kfree()
> instead.

I don't think this patch is necessary for any stable tree, it's meant
only to ease merging a tree-wide patchset to rename kzfree.  In btrfs
code there was no point using it so it's plain kfree.
