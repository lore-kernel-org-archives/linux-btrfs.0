Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C815C10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 22:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70C0821473
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 22:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfDHWRS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 18:17:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:50392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726188AbfDHWRR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 18:17:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C43BAAD6D;
        Mon,  8 Apr 2019 22:17:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1AC20DA88B; Tue,  9 Apr 2019 00:18:24 +0200 (CEST)
Date:   Tue, 9 Apr 2019 00:18:23 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] Fixup and optimization for write time tree checker
Message-ID: <20190408221823.GD29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190404034708.3399-1-wqu@suse.com>
 <20190405154945.GX29086@twin.jikos.cz>
 <d17bb3bb-456f-0940-d95e-9cedc2ce4406@gmx.com>
 <76400324-5d49-2519-b005-b1a85f886750@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76400324-5d49-2519-b005-b1a85f886750@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Apr 06, 2019 at 09:57:35AM +0800, Qu Wenruo wrote:
> >>>
> >>> This patchset also introduces a new optimization, where original empty
> >>> leaf owner check can be pretty expensive and cause false alerts for
> >>> write time tree checker.
> >>> With this new optimization, write time tree checker can reuse the
> >>> existing btrfs_check_leaf_full().
> >>
> >> This on top of misc-next throws 6 'write time' errors:
> >>
> >> btrfs/101               [14:00:24][ 3963.736352] run fstests btrfs/101 at 2019-04-05 14:00:24
> >> [ 3970.417649] BTRFS error (device vdc): block=2446344192 write time tree block corruption detected
> > 
> > In my case, these tests just pass, so I haven't checked the dmesg.

I have a filter for log (it's mix of terminal and kernel log)

egrep -a '(run fstests|WARNING:|BUG:|RIP:|UBSAN:|^\s+[+-]|CPU:.*Comm:|write time|read time|blocked for more than|Linux version)'

so the unexpected output is not lost among other messages.

> Oh, those tests passes because of a bug in mainline.
> 
> 6dc4f100c175 ("block: allow bio_for_each_segment_all() to iterate over
> multi-page bvec") prevents us from breaking bio_for_each_segment_all()
> loop, thus not triggering transaction abort.
> 
> A nice finding digging into the report.

Indeed, thanks. The hidden for-in-for in the macro would bite us later.
