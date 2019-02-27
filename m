Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D357C00319
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 17:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D61E2183F
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 17:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbfB0RSD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 12:18:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:38122 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727636AbfB0RSD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 12:18:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 909B9AB87;
        Wed, 27 Feb 2019 17:18:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7A088DA83C; Wed, 27 Feb 2019 18:19:23 +0100 (CET)
Date:   Wed, 27 Feb 2019 18:19:23 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix file corruption after snapshotting
Message-ID: <20190227171923.GA24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190204142810.1800-1-fdmanana@kernel.org>
 <20190218171109.GO9874@twin.jikos.cz>
 <CAL3q7H7LAxa0qKarywvRk3YmRS_86G2uyN1rfW0iAPZ9KqTtJQ@mail.gmail.com>
 <20190227124717.GF24609@twin.jikos.cz>
 <CAL3q7H7Ct-r-Vy737YA7jHmyz0R4dJ6M=5wCMnn7Uvz-Z5EASA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H7Ct-r-Vy737YA7jHmyz0R4dJ6M=5wCMnn7Uvz-Z5EASA@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 27, 2019 at 01:42:31PM +0000, Filipe Manana wrote:
> > > > So, how about calling writeback_inodes_sb in that case as a fallback?
> > >
> > > Thought about it, but the reason I didn't do it is that if you
> > > fallback to writeback_unodes_sb, you'll never have the error reported
> > > to the user.
> > > It's very unlikely the user will do an fsync on the snapshot version
> > > of the file, specially if it's a RO snapshot, which would be the only
> > > way to report the error.
> > >
> > >
> > > > I'd really like to avoid returning failure from
> > > > btrfs_start_delalloc_flush so the extra overhead of the writeback (in a
> > > > theoretical error case anyway) should be ok.
> > >
> > > Me too, as long as the error is reported (a message in syslog/dmesg is
> > > very likely to be missed).
> >
> > I probably don't understand. EROFS could be ignored and ENOMEM can be
> > worked around. I don't see what needs to be reported to the user.
> 
> For the same reason we don't ignore the error from the initial flush
> done in the ioctl (at create_snapshot()).
> If the flush fails and we ignore the error, we risk getting a snapshot
> with a corrupted version of files,
> without the user knowing about it.
> 
> Yes, I know here, inside the transaction commit it means ending up in
> an abort and turning the fs into RO mode,
> which is very inconvenient.

create_snapshot is quite different, because the error happens outside of
a transaction.  If it fails at btrfs_start_delalloc_snapshot, it goes
directly to a cleanup and back to userspace. Then it can be restarted
if necessary, the filesystem is still operable (unlike the whole system
that could have the memory exhausted if this was the reason of the
failure).

> It's a choice.

So the way I choose is by the overall impact and try to avoid the abort
if possible.

> Anyway, an updated v2 that ignores any error was just sent.
> This is probably something where different people will always have a
> different preference.
