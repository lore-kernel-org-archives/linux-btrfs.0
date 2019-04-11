Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D8BC10F13
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 18:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 416FC2083E
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 18:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfDKS1v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 14:27:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:42568 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726538AbfDKS1v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 14:27:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C3A3CB62E;
        Thu, 11 Apr 2019 18:27:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BF115DA85B; Thu, 11 Apr 2019 20:28:55 +0200 (CEST)
Date:   Thu, 11 Apr 2019 20:28:55 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     dsterba@suse.cz, robbieko <robbieko@synology.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Subject: Re: [PATCH v2] Btrfs: fix data bytes_may_use underflow with
 fallocate due to failed quota reserve
Message-ID: <20190411182854.GE3476@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>,
        robbieko <robbieko@synology.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
References: <1553572571-15614-1-git-send-email-robbieko@synology.com>
 <20190411175244.GB3476@twin.jikos.cz>
 <CAL3q7H53ZcxVqX80SEtY_=r9WBgm--RgYamP6q9n-sW073qr0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H53ZcxVqX80SEtY_=r9WBgm--RgYamP6q9n-sW073qr0Q@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 11, 2019 at 06:01:16PM +0000, Filipe Manana wrote:
> > [ 7731.355111] BTRFS info (device vda): disk space caching is enabled
> > [ 7731.358367] BTRFS info (device vda): has skinny extents
> > [ 7731.407393] BTRFS: device fsid 99c22651-33bd-4543-96df-da02cc320166 devid 1 transid 5 /dev/vdb
> > [ 7731.419081] BTRFS info (device vdb): disk space caching is enabled
> > [ 7731.420671] BTRFS info (device vdb): has skinny extents
> > [ 7731.421955] BTRFS info (device vdb): flagging fs with big metadata feature
> > [ 7731.426107] BTRFS info (device vdb): checking UUID tree
> > [ 7865.389231] BTRFS info (device vdb): disk space caching is enabled
> > [ 7865.393289] BTRFS info (device vdb): has skinny extents
> >  [02:17:19]- output mismatch (see /tmp/fstests/results//generic/102.out.bad)
> >     --- tests/generic/102.out   2018-10-08 09:51:53.890556726 +0000
> >     +++ /tmp/fstests/results//generic/102.out.bad       2019-04-09 02:17:19.460000000 +0000
> >     @@ -1,7 +1,7 @@
> >      QA output created by 102
> >      wrote 838860800/838860800 bytes at offset 0
> >      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> >     -wrote 838860800/838860800 bytes at offset 0
> >     +wrote 109707264/838860800 bytes at offset 0
> >      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> >      wrote 838860800/838860800 bytes at offset 0
> >     ...
> >     (Run 'diff -u /tmp/fstests/tests/generic/102.out /tmp/fstests/results//generic/102.out.bad'  to see the entire diff)
> 
> Unrelated to this patch.
> The test fails often for at least a few kernel releases now.

Ok noted, thanks. After checking more logs, the test indeed fails,
though I see only a few failures in past week so it was a conincidence
that it happened just around this patch.
