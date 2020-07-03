Return-Path: <SRS0=qDml=AO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733BEC433E0
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Jul 2020 13:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57DE420760
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Jul 2020 13:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgGCNbw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 3 Jul 2020 09:31:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:50130 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbgGCNbw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Jul 2020 09:31:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7BC82ACA0;
        Fri,  3 Jul 2020 13:31:51 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 974BADA87C; Fri,  3 Jul 2020 15:31:33 +0200 (CEST)
Date:   Fri, 3 Jul 2020 15:31:31 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org,
        Marcos Paulo de Souza <marcos@mpdesouza.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs: discard: reduce the block group ref when grabbing
 from unused block group list
Message-ID: <20200703133131.GB27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org,
        Marcos Paulo de Souza <marcos@mpdesouza.com>
References: <20200703070550.39299-1-wqu@suse.com>
 <4c44286d-bdaf-3598-e3b7-9844b92617b6@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c44286d-bdaf-3598-e3b7-9844b92617b6@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jul 03, 2020 at 09:01:42PM +0800, Qu Wenruo wrote:
> > group from unused_bgs list.
> > 
> > Reported-by: Marcos Paulo de Souza <marcos@mpdesouza.com>
> 
> My bad, the reported by tag should use his awesome suse mail address.
> 
> David, would you please fix this at merge time?

Yeah, no problem.
