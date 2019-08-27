Return-Path: <SRS0=Pg1I=WX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF582C3A5A3
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Aug 2019 14:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD7B3217F5
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Aug 2019 14:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbfH0ONU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 10:13:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:47490 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726125AbfH0ONU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Aug 2019 10:13:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8DD85B0F2
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2019 14:13:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D694EDA809; Tue, 27 Aug 2019 16:13:42 +0200 (CEST)
Date:   Tue, 27 Aug 2019 16:13:41 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: Make btrfs_find_name_in_backref return
 btrfs_inode_ref struct
Message-ID: <20190827141341.GJ2752@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190827114630.2425-1-nborisov@suse.com>
 <20190827114630.2425-2-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827114630.2425-2-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 27, 2019 at 02:46:28PM +0300, Nikolay Borisov wrote:
>  			ret = btrfs_find_name_in_backref(log_eb, log_slot, name,
> -							 namelen, NULL);
> +							 namelen) != NULL;

Isn't there a less confusing and obscure way to do that?
