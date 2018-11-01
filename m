Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62063C6786F
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 17:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27DB02064C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 17:16:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27DB02064C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbeKBCT5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 22:19:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:38176 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725843AbeKBCT5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 22:19:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8269DAF9A;
        Thu,  1 Nov 2018 17:16:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A7E08DAAFC; Thu,  1 Nov 2018 18:15:54 +0100 (CET)
Date:   Thu, 1 Nov 2018 18:15:54 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2] Btrfs: fix missing delayed iputs on unmount
Message-ID: <20181101171554.GS9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Omar Sandoval <osandov@osandov.com>, Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
References: <5d98091d3e089b4f74cb61fb2ed691e1f4dd1d6b.1541005462.git.osandov@fb.com>
 <20181101101532.GL9136@twin.jikos.cz>
 <2DCF4F92-0B05-420C-ADEB-3A7A69F6DB37@fb.com>
 <20181101150831.GM9136@twin.jikos.cz>
 <20181101152229.GN9136@twin.jikos.cz>
 <20181101152425.GB18005@vader>
 <20181101152948.GP9136@twin.jikos.cz>
 <20181101160056.GD18005@vader>
 <20181101164447.GQ9136@twin.jikos.cz>
 <7c60425a-0244-fef9-2b9d-aab204d04d4e@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c60425a-0244-fef9-2b9d-aab204d04d4e@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 06:50:03PM +0200, Nikolay Borisov wrote:
> 
> 
> On 1.11.18 г. 18:44 ч., David Sterba wrote:
> > On Thu, Nov 01, 2018 at 09:00:56AM -0700, Omar Sandoval wrote:
> >>> That was an assumption for the demonstration purposes, the wording was
> >>> confusing sorry.
> >>
> >> Oh, well in that case, that's exactly what kthread_park() is ;) Stop the
> >> thread and make wake_up a noop, and then we don't need to add special
> >> cases everywhere else.
> > 
> > The end result is equivalent and should be, I'm now weighing both
> > approaches. Explicit state tracking outside of the thread structures
> > seems more clear and in case we want to query the status, we can't after
> > kthread_stop is called. My current version below.
> > 
> 
> <snip>
> 
> > +static inline void btrfs_wake_up_transaction(struct btrfs_fs_info *fs_info)
> > +{
> > +	if (!test_bit(BTRFS_FS_CLOSING_SINGLE, &fs_info->flags)) {
> 
> Why do we need a separate flag for a predicate? If we use
> FS_CLOSING_START then waking up becomes a noop from the moment
> close_ctree is called.

Yeah it's not strictly necessary, it's a leftover from when I had a
WARN_ON in the wakeup helpers that triggered too often so another flag
was added just after the threads were stopped.
