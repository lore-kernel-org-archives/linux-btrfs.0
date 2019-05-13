Return-Path: <SRS0=eL0R=TN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4616EC04AA7
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 May 2019 17:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28B53208CA
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 May 2019 17:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731992AbfEMR7M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 13 May 2019 13:59:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:47166 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727660AbfEMR7M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 May 2019 13:59:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6B9A5ACF5;
        Mon, 13 May 2019 17:59:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6D8E9DA851; Mon, 13 May 2019 20:00:12 +0200 (CEST)
Date:   Mon, 13 May 2019 20:00:12 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: prevent send failures and crashes due to
 concurrent relocation
Message-ID: <20190513180012.GI3138@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190422154409.16323-1-fdmanana@kernel.org>
 <20190513163216.GF3138@twin.jikos.cz>
 <CAL3q7H4LD1F=D7ERBNTeSTBWUOTnTS-oyBoN3KVBV-uZ0t+QLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H4LD1F=D7ERBNTeSTBWUOTnTS-oyBoN3KVBV-uZ0t+QLg@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, May 13, 2019 at 05:43:55PM +0100, Filipe Manana wrote:
> On Mon, May 13, 2019 at 5:31 PM David Sterba <dsterba@suse.cz> wrote:
> >
> > On Mon, Apr 22, 2019 at 04:44:09PM +0100, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > > --- a/fs/btrfs/send.c
> > > +++ b/fs/btrfs/send.c
> > > @@ -6869,9 +6869,23 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
> > >       if (ret)
> > >               goto out;
> > >
> > > +     mutex_lock(&fs_info->balance_mutex);
> > > +     if (test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags)) {
> > > +             mutex_unlock(&fs_info->balance_mutex);
> > > +             btrfs_warn_rl(fs_info,
> > > +           "Can not run send because a balance operation is in progress");
> > > +             ret = -EAGAIN;
> > > +             goto out;
> > > +     }
> > > +     fs_info->send_in_progress++;
> > > +     mutex_unlock(&fs_info->balance_mutex);
> >
> > This would be better in a helper that hides that the balance mutex from
> > send.
> 
> Given the large number of cleanup patches that open code helpers that
> had only one caller, this somewhat surprises me.

Fair point, though I'd object that there are cases where the function
name says in short what happens without the implementation details and
this helps code readability. I struck me when I saw 'send_in_progress
protected by balance_mutex'. You can find functions that are called just
once, that's not an anti-pattern in general.

I'll take a fresh look later, the setup phase of btrfs_ioctl_send is not
exactly short so the added check does not stand out.
