Return-Path: <SRS0=WhU1=6V=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611A9C38A2A
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 May 2020 20:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 387762075E
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 May 2020 20:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgEGU6P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 May 2020 16:58:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:40312 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgEGU6O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 May 2020 16:58:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D22FFB272;
        Thu,  7 May 2020 20:58:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 456BADA732; Thu,  7 May 2020 22:57:24 +0200 (CEST)
Date:   Thu, 7 May 2020 22:57:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: Mark qgroup inconsistent if we're
 inherting snapshot to a new qgroup
Message-ID: <20200507205724.GN18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200402063735.32808-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402063735.32808-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 02, 2020 at 02:37:35PM +0800, Qu Wenruo wrote:
> Anyway, user shouldn't use qgroup inheritance during snapshot creation,
> and should add qgroup relationship after snapshot creation by 'btrfs
> qgroup assign', which has a much better UI to inform user about qgroup
> inconsistent and kick in rescan automatically.

If users shouldn't do something, there needs to be a documentation,
warning and deprecation of the interface at least. If it's there,
somebody will use it.

I'll apply the patch despite the qgroup_flags concerns as it's not
critical.
