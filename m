Return-Path: <SRS0=zIKm=QA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2273DC282C3
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 16:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E78202184C
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 16:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbfAXQgh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:36:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:39232 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728587AbfAXQgg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Jan 2019 11:36:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BD022AC86;
        Thu, 24 Jan 2019 16:36:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 985A7DA6F5; Thu, 24 Jan 2019 17:36:01 +0100 (CET)
Date:   Thu, 24 Jan 2019 17:36:01 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: no need to check return value of debugfs_create
 functions
Message-ID: <20190124163601.GY2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org
References: <20190104132520.GA22613@kroah.com>
 <20190104134449.GL23615@suse.cz>
 <20190114142104.GA12343@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190114142104.GA12343@kroah.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 14, 2019 at 03:21:04PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Jan 04, 2019 at 02:44:49PM +0100, David Sterba wrote:
> > On Fri, Jan 04, 2019 at 02:25:20PM +0100, Greg Kroah-Hartman wrote:
> > > When calling debugfs functions, there is no need to ever check the
> > > return value.  The function can work or not, but the code logic should
> > > never do something different based on this.
> > > 
> > > Cc: Chris Mason <clm@fb.com>
> > > Cc: Josef Bacik <josef@toxicpanda.com>
> > > Cc: David Sterba <dsterba@suse.com>
> > > Cc: linux-btrfs@vger.kernel.org
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  fs/btrfs/sysfs.c | 10 ++--------
> > >  1 file changed, 2 insertions(+), 8 deletions(-)
> > > 
> > > Meta-comment, why is there a btrfs debugfs directory at all?  All you
> > > have here is a single "test" file that doesn't do anything except expose
> > > a variable that never changes.  What is this directory and single file
> > > for?  Can I just delete the whole thing?
> > 
> > As explained in the commit that introduces the function
> > (1bae30982bc86ab66d61ccb):
> > 
> >   Help during debugging to export various interesting infromation and
> >   tunables without the need of extra mount options or ioctls.
> > 
> >   Usage:
> >   * declare your variable in sysfs.h, and include where you need it
> >   * define the variable in sysfs.c and make it visible via
> >     debugfs_create_TYPE
> > 
> >   Depends on CONFIG_DEBUG_FS.
> > 
> > It's there for developers, so don't delete it. Which also means the
> > error code should be handled and not ignored.
> 
> If no one has used it, why keep it?

That no one can tell for sure, we don't get notified. I know that
implementing the debugfs support was not all trivial and saved time.
If this savs time to other developers, why delete it?

> Anyway, if you want it there, that's fine, but no, the error message can
> be ignored.  You should never have a different code flow if a debugfs
> call fails or not.  So the patch I posted here is still correct and
> should be applied.

I disagree with that. The usecase is for devleopers, who intentionally
add own debugging information. It does not mean the code changes gets
committed in the end, but the debugfs infrastructure is used and should
work reliably at this point. This means that either the data get
exported or there's an early exit when something goes wrong. Silent
failure in this case can waste hours of testing or debugging.

I fail to see your logic to never rely on debugfs calls success/failure.
Debugfs is a tool like any other, with narrow group of users and
usecases but can be valuable.

If you need to extend return values or do other cleanups, then fine, but
I'm not going to apply the patch in its current form as it would harm my
own usecase, sorry.

> > I can enhance the comment so it's explained in-place and not too
> > tempting to remove it. This is not the first time somebody wants to
> > remove it
> > (https://lore.kernel.org/linux-btrfs/d6715b5b-0aa3-3032-43c6-eccd907a60b8@redhat.com/),
> 
> If it keeps wanting to get removed, that's a big hint maybe you should :)

If there's a good explanation why it should be removed, then yes. If
there's a reason to keep it, then no. So far I've seen drive-by attempts
to remove some seemingly unused code by people who don't work in the
area of the subsystem and may not understand its purpose.
