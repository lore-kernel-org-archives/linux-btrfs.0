Return-Path: <SRS0=CkC6=AA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF0EC433E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Jun 2020 13:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4BAF208C7
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Jun 2020 13:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgFSNTl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 09:19:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:35904 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgFSNTl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jun 2020 09:19:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C9DB1AE07;
        Fri, 19 Jun 2020 13:19:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DFB4ADA9B9; Fri, 19 Jun 2020 15:19:29 +0200 (CEST)
Date:   Fri, 19 Jun 2020 15:19:29 +0200
From:   David Sterba <dsterba@suse.cz>
To:     waxhead <waxhead@dirtcellar.net>
Cc:     DanglingPointer <danglingpointerexception@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs-dedupe broken and unsupported but in official wiki
Message-ID: <20200619131929.GE27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, waxhead <waxhead@dirtcellar.net>,
        DanglingPointer <danglingpointerexception@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <16bc2efa-8e88-319f-e90e-cf8536460860@gmail.com>
 <878f01ec-eb07-e8ba-bd32-143997bce422@dirtcellar.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878f01ec-eb07-e8ba-bd32-143997bce422@dirtcellar.net>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jun 18, 2020 at 10:59:10PM +0200, waxhead wrote:
> I have pointed this out before , but I would like to use the opportunity 
> again. I, as just a regular user of btrfs would feel more comfortable if 
> the dedupe tool was part of btrfs such as for example btrfs filesystem 
> dedupe -r /somewhere

I agree that something like that would be highly useful, and despite I
know about duperemove I don't use it often enough to remember how
exactly to use it for the simple usecase.
