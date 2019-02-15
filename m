Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F95C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 17:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BFAF2190C
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 17:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbfBORSh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 12:18:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:40466 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725939AbfBORSg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 12:18:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C9DEAAD33;
        Fri, 15 Feb 2019 17:18:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 29431DA87D; Fri, 15 Feb 2019 18:19:59 +0100 (CET)
Date:   Fri, 15 Feb 2019 18:19:58 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 00/12] btrfs: Enhancement to tree block validation
Message-ID: <20190215171958.GG9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190215105044.17619-1-wqu@suse.com>
 <2ebcb996-dd7a-2662-811a-5526fccb03b7@suse.com>
 <18beb5f9-48f5-e519-6abf-08bd1509cde5@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <18beb5f9-48f5-e519-6abf-08bd1509cde5@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 15, 2019 at 09:18:03PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/2/15 下午9:10, Nikolay Borisov wrote:
> > 
> > 
> > On 15.02.19 г. 12:50 ч., Qu Wenruo wrote:
> >> Patchset can be fetched from github:
> >> https://github.com/adam900710/linux/tree/write_time_tree_checker
> >> Which is based on v5.0-rc1 tag.
> >> Also there is no conflict rebasing the patchset to misc-next.
> >>
> >> This patchset has the following 3 features:
> >> - Tree block validation output enhancement
> >>   * Output validation failure timing (write time or read time)
> >>   * Always output tree block level/key mismatch error message
> >>     This part is already submitted and reviewed.
> >>
> >> - Write time tree block validation check
> >>   To catch memory corruption either from hardware or kernel.
> >>   Example output would be:
> >>
> >>     BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
> >>     BTRFS error (device dm-3): write time tree block corruption detected
> > This is not good.  Those two error messages should be collapsed into
> > one. Otherwise it's hard to actually match them up.
> 
> That shouldn't be a problem, since the error won't happen so frequently
> there is no other error message that could interrupt these 2 lines.
> 
> > Better output will
> > be "Corrupt leaf detected during writing: root=..." and eliminate "write
> > time tree block corruption detected" line. Is that feasible?
> 
> Feasible, currently tree checker only get called in 3 locations:
> 1) read time full checker
> 2) mark dirty time basic checker
> 3) write time full checker
> 
> And they all have different internal bool to indicate the timing, so
> it's possible to output the timing.
> 
> But that needs to pass the internal bool down a long long way, for all
> the output help to accept an extra string.
> I'm not a big fan for that, and prefer a timing neutral tree checker.

I'd rather not merge the error messages, as we'll possibly add more
sanity checks to various functions so there could be a list of problems
and there's one final note about when it happened (read time/write
time).

Matching the lines together is desirable though, so if the block number
could be part of all messages, I hope this makes it usable for analysis.

Reading btree_readpage_end_io_hook, the message should be under the err:
label, as there are 3 other possible messages printed (bad block start,
fsid and level).
