Return-Path: <SRS0=3R9D=U6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E7AC0650E
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Jul 2019 17:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD958205F4
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Jul 2019 17:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbfGARxD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Jul 2019 13:53:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:50724 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727270AbfGARxD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Jul 2019 13:53:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 95B16B0BA;
        Mon,  1 Jul 2019 17:53:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 461E2DA8A9; Mon,  1 Jul 2019 19:53:45 +0200 (CEST)
Date:   Mon, 1 Jul 2019 19:53:45 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Graham Cobb <g.btrfs@cobb.uk.net>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: scrub: Fix scrub cancel/resume not to skip
 most of the disk
Message-ID: <20190701175345.GO20977@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Graham Cobb <g.btrfs@cobb.uk.net>,
        linux-btrfs@vger.kernel.org
References: <2c415510-8d46-065d-6b38-b8514a8ffcc1@cobb.uk.net>
 <20190618080825.15336-1-g.btrfs@cobb.uk.net>
 <9edea292-d787-9911-d067-348c522b8b3b@cobb.uk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9edea292-d787-9911-d067-348c522b8b3b@cobb.uk.net>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jun 25, 2019 at 09:17:43PM +0100, Graham Cobb wrote:
> On 18/06/2019 09:08, Graham R. Cobb wrote:
> > When a scrub completes or is cancelled, statistics are updated for reporting
> > in a later btrfs scrub status command and for resuming the scrub. Most
> > statistics (such as bytes scrubbed) are additive so scrub adds the statistics
> > from the current run to the saved statistics.
> > 
> > However, the last_physical statistic is not additive. The value from the
> > current run should replace the saved value. The current code incorrectly
> > adds the last_physical from the current run to the previous saved value.
> > 
> > This bug causes the resume point to be incorrectly recorded, so large areas
> > of the disk are skipped when the scrub resumes. As an example, assume a disk
> > had 1000000 bytes and scrub was cancelled and resumed each time 10% (100000
> > bytes) had been scrubbed.
> > 
> > Run | Start byte | bytes scrubbed | kernel last_physical | saved last_physical
> >   1 |          0 |         100000 |               100000 |              100000
> >   2 |     100000 |         100000 |               200000 |              300000
> >   3 |     300000 |         100000 |               400000 |              700000
> >   4 |     700000 |         100000 |               800000 |             1500000
> >   5 |    1500000 |              0 | immediately completes| completed
> > 
> > In this example, only 40% of the disk is actually scrubbed.
> > 
> > This patch changes the saved/displayed last_physical to track the last
> > reported value from the kernel.
> > 
> > Signed-off-by: Graham R. Cobb <g.btrfs@cobb.uk.net>
> 
> Ping? This fix is important for anyone who interrupts and resumes scrubs
> -- which will happen more and more as filesystems get bigger. It is a
> small fix and would be good to get out to distros.

Sorry for the delay. The analysis and fix are correct, patch added to
devel. Thanks.
