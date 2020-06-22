Return-Path: <SRS0=j8o/=AD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DBFC433E1
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Jun 2020 16:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB33720738
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Jun 2020 16:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgFVQFa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 12:05:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:60822 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgFVQFa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jun 2020 12:05:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C6F63C23D;
        Mon, 22 Jun 2020 16:05:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 25C57DA82B; Mon, 22 Jun 2020 18:05:13 +0200 (CEST)
Date:   Mon, 22 Jun 2020 18:05:13 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] Fix enum values print in tracepoints
Message-ID: <20200622160512.GI27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200619122451.31162-1-nborisov@suse.com>
 <20200622142113.GF27795@twin.jikos.cz>
 <134b26bb-30ae-2b60-90fe-83703b307890@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <134b26bb-30ae-2b60-90fe-83703b307890@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jun 22, 2020 at 06:19:39PM +0300, Nikolay Borisov wrote:
> > I've looked at the result and it could really use the comments from
> > 190f0b76ca49 where the definitions switch the output and some whitespace
> > fixups in the new definitions.
> > 
> > Not all enums are converted, just search for use of __print_symbolic
> > inside the show_TYPE helpers (eg. show_ref_action, show_ref_type),
> > please add them too. Thanks.
> 
> I beg you to differ:
> 
> show_ref_action/show_ref_type/__show_root_type/__show_map_type/ - those
> are defined and they are OK as is, because defines don't emit separate
> symbols. However, when/if in the future those defines are switched to
> enums then the respective tracepoint code should be converted to using
> the EM macros as well.

I see, it's define vs enum.
