Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D66ECDE47
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 18:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D1DB2085A
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 18:08:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D1DB2085A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387747AbeKFD2u (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 22:28:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:39570 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387640AbeKFD2u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 22:28:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CBC98B060;
        Mon,  5 Nov 2018 18:07:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7E51BDAF91; Mon,  5 Nov 2018 19:07:43 +0100 (CET)
Date:   Mon, 5 Nov 2018 19:07:42 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v9 0/6] Btrfs: implement swap file support
Message-ID: <20181105180741.GE9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org
References: <cover.1538072009.git.osandov@fb.com>
 <20181019154318.GK16290@twin.jikos.cz>
 <20181022211327.GA10074@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181022211327.GA10074@vader>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 22, 2018 at 02:13:27PM -0700, Omar Sandoval wrote:
> > > Omar Sandoval (6):
> > >   mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
> > >   mm: export add_swap_extent()
> > >   vfs: update swap_{,de}activate documentation

> > >   Btrfs: prevent ioctls from interfering with a swap file
> > >   Btrfs: rename get_chunk_map() and make it non-static
> > >   Btrfs: support swap files
> > 
> > Patches 1 and 2 now going through Andrew's tree, the btrfs part will be
> > delayed and not merged to 4.20. This is a bit unfortuante, I was busy
> > with the non-feature patches and other things, sorry.
> 
> That's perfectly fine with me, than

The 3 btrfs patches are now in misc-next.

Setting up the swap file needs the extra steps to make sure it's a NOCOW
file and preallocated, that's just 2 more commands using common tools.
The surprise may come on an a multi-device filesystem when the chunks
get spread over more devices and the user has no control over that.
Reducing the file size until it fits is a workaround, tough not totally
reliable.

I've explored the error cases (balance, dev delete, adding more
swapfiles). Also a stress test (make -j on kernel). The OOM killer was
able to get the system back after each round after which I added one
more swapfile, until the system was effectively dead.

So the stability seems to be ok, we will need to document the usecase,
constraints and how to properly set up the swapfile, and that's about
it. Thanks.
