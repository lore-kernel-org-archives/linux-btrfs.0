Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA18C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 18:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3F58218E2
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 18:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfABS2h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 13:28:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:57742 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727749AbfABS2h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 13:28:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A3845AF13;
        Wed,  2 Jan 2019 18:28:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1C7DBDA781; Wed,  2 Jan 2019 19:28:07 +0100 (CET)
Date:   Wed, 2 Jan 2019 19:28:07 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: do not overwrite error return value in the
 balance ioctl
Message-ID: <20190102182806.GF23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181214194541.21891-1-fdmanana@kernel.org>
 <9c378108-591d-e275-8898-3c67d97156fa@oracle.com>
 <CAL3q7H6NEJiAW8RYRdt8f3svhE3wZg92FoQH+bzFo2aE9ozKPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H6NEJiAW8RYRdt8f3svhE3wZg92FoQH+bzFo2aE9ozKPA@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 17, 2018 at 09:24:43AM +0000, Filipe Manana wrote:
> On Mon, Dec 17, 2018 at 8:25 AM Anand Jain <anand.jain@oracle.com> wrote:
> >
> >
> >
> > On 12/15/2018 03:45 AM, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > If the call to btrfs_balance() failed we would overwrite the error
> > > returned to user space with -EFAULT if the call to copy_to_user() failed
> > > as well. Fix that by calling copy_to_user() only if btrfs_balance()
> > > returned success.
> > >
> > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > ---
> > >   fs/btrfs/ioctl.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > > index abe45fd97ab5..4ad7288f77d0 100644
> > > --- a/fs/btrfs/ioctl.c
> > > +++ b/fs/btrfs/ioctl.c
> > > @@ -4707,7 +4707,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
> > >       ret = btrfs_balance(fs_info, bctl, bargs);
> > >       bctl = NULL;
> > >
> > > -     if (arg) {
> > > +     if (ret == 0 && arg) {
> > >               if (copy_to_user(arg, bargs, sizeof(*bargs)))
> > >                       ret = -EFAULT;
> > >       }
> > >
> >
> > This changes the BTRFS_IOC_BALANCE_V2 semantics.
> >
> > Originally, if BTRFS_IOC_BALANCE_V2 is failed/canceled we do update
> > bargs [1] and copy to user land, but after this patch we copy only
> > if the ioctl is successful. I doubt if David is OK with that.
> 
> I thought about that. But that logic, if it's really in use by someone
> (something) out there then they must be treating -EFAULT differently
> from any other error.
> Because if copy_to_user() fails it means it didn't copy all bytes it
> was so supposed to (its return value is number of bytes not copied),
> so the arguments structure ends up in an inconsistent state.

The balance ioctl as used in btrfs-progs expects valid contents of the
bargs even if the ioctl returns negative value, with errno set to
ECANCELED:

https://github.com/kdave/btrfs-progs/blob/master/cmds-balance.c#L458

So the condition would need to take that into account

	if ((ret == 0 || ret == -ECANCELED) && arg)

I haven't found any other error that would need to be whitelisted here.
