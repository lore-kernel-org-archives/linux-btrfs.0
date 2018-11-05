Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2398BC0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 16:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEECB20700
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 16:34:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CEECB20700
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387452AbeKFBzB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 20:55:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:52886 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387407AbeKFBzB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 20:55:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E2968B081;
        Mon,  5 Nov 2018 16:34:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7D092DAF91; Mon,  5 Nov 2018 17:34:18 +0100 (CET)
Date:   Mon, 5 Nov 2018 17:34:18 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Subject: Re: [PATCH v4] Btrfs: fix deadlock on tree root leaf when finding
 free extent
Message-ID: <20181105163418.GB9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
References: <20181022090946.1150-1-fdmanana@kernel.org>
 <20181024091303.20324-1-fdmanana@kernel.org>
 <20181024113717.fcz4klha7isb7r56@MacBook-Pro-91.local>
 <CAL3q7H5_1T9doxVu-GRCU9-uZVi5q=yw+K+YVqK-As+fJbT6nQ@mail.gmail.com>
 <20181024123959.icp7ssu5sjhqg6c3@MacBook-Pro-91.local>
 <CAL3q7H7dZm8s2Ey185Xw=bsjG6fZBeEWjQu+He2kQ5JYMPCHWg@mail.gmail.com>
 <20181105162849.GA9136@twin.jikos.cz>
 <CAL3q7H45e7B9acpDnx-R5hNxu+033Tfx4yD_ynZ_cY3hPfLryg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H45e7B9acpDnx-R5hNxu+033Tfx4yD_ynZ_cY3hPfLryg@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 05, 2018 at 04:30:35PM +0000, Filipe Manana wrote:
> On Mon, Nov 5, 2018 at 4:29 PM David Sterba <dsterba@suse.cz> wrote:
> >
> > On Wed, Oct 24, 2018 at 01:48:40PM +0100, Filipe Manana wrote:
> > > > Ah ok makes sense.  Well in that case lets just make btrfs_read_locked_inode()
> > > > take a path, and allocate it in btrfs_iget, that'll remove the ugly
> > > >
> > > > if (path != in_path)
> > >
> > > You mean the following on top of v4:
> > >
> > > https://friendpaste.com/6XrGXb5p0RSJGixUFYouHg
> > >
> > > Not much different, just saves one such if statement. I'm ok with that.
> >
> > Now in misc-next with v4 and the friendpaste incremental as
> >
> > https://github.com/kdave/btrfs-devel/commit/efcfd6c87d28b3aa9bcba52d7c1e1fc79a2dad69
> 
> Please don't add the incremental. It's buggy. It was meant to figure
> out what Josef was saying. That's why I haven't sent a V5.

Ok dropped, I'll will wait for a proper patch.
