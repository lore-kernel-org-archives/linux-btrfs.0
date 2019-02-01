Return-Path: <SRS0=NsLk=QI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A40C282D8
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Feb 2019 09:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F12F520844
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Feb 2019 09:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549012634;
	bh=6bLVUAxkWL86stg35hsCp9NdcfrKJDwXSrjvNO5rtMU=;
	h=Date:From:To:Subject:References:In-Reply-To:List-ID:From;
	b=KV3qI/BX6BMI6AGstSIOTmBUPrxbj0iApIoHiezcN/gxXWHD6+RDaYgFrBjqWuWse
	 TuyHNCXOioDZbYaTAQLbGW20mLZl+PEyZ5wah1r5QS4JFZ1bHllqrq4gPUWEjCCKzN
	 ucNaLZPcdnrID8h3RhB8w6gm5szApDxuhCYnKCpI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfBAJRM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Feb 2019 04:17:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfBAJRM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Feb 2019 04:17:12 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73E9420844;
        Fri,  1 Feb 2019 09:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549012630;
        bh=6bLVUAxkWL86stg35hsCp9NdcfrKJDwXSrjvNO5rtMU=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=caRQxXNiSFC0lOBl9QReM/sd3MsgPieGGePgI1VbSJ9tznz6gOa86O+9Fv5334m0g
         /RdbbKwNbQqKdrR6BlG7LReQm3ovcYiCMRuURSEJw6CjdVuYLd403lHyqMxhahsLPC
         A3F9faYwmd2NnoLviWm0gRoOmXLwz0jOmN3/kSwg=
Date:   Fri, 1 Feb 2019 10:17:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: no need to check return value of debugfs_create
 functions
Message-ID: <20190201091707.GC30619@kroah.com>
References: <20190104132520.GA22613@kroah.com>
 <20190104134449.GL23615@suse.cz>
 <20190114142104.GA12343@kroah.com>
 <20190124163601.GY2900@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124163601.GY2900@twin.jikos.cz>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 24, 2019 at 05:36:01PM +0100, David Sterba wrote:
> On Mon, Jan 14, 2019 at 03:21:04PM +0100, Greg Kroah-Hartman wrote:
> > On Fri, Jan 04, 2019 at 02:44:49PM +0100, David Sterba wrote:
> > > On Fri, Jan 04, 2019 at 02:25:20PM +0100, Greg Kroah-Hartman wrote:
> > > > When calling debugfs functions, there is no need to ever check the
> > > > return value.  The function can work or not, but the code logic should
> > > > never do something different based on this.
> > > > 
> > > > Cc: Chris Mason <clm@fb.com>
> > > > Cc: Josef Bacik <josef@toxicpanda.com>
> > > > Cc: David Sterba <dsterba@suse.com>
> > > > Cc: linux-btrfs@vger.kernel.org
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > ---
> > > >  fs/btrfs/sysfs.c | 10 ++--------
> > > >  1 file changed, 2 insertions(+), 8 deletions(-)
> > > > 
> > > > Meta-comment, why is there a btrfs debugfs directory at all?  All you
> > > > have here is a single "test" file that doesn't do anything except expose
> > > > a variable that never changes.  What is this directory and single file
> > > > for?  Can I just delete the whole thing?
> > > 
> > > As explained in the commit that introduces the function
> > > (1bae30982bc86ab66d61ccb):
> > > 
> > >   Help during debugging to export various interesting infromation and
> > >   tunables without the need of extra mount options or ioctls.
> > > 
> > >   Usage:
> > >   * declare your variable in sysfs.h, and include where you need it
> > >   * define the variable in sysfs.c and make it visible via
> > >     debugfs_create_TYPE
> > > 
> > >   Depends on CONFIG_DEBUG_FS.
> > > 
> > > It's there for developers, so don't delete it. Which also means the
> > > error code should be handled and not ignored.
> > 
> > If no one has used it, why keep it?
> 
> That no one can tell for sure, we don't get notified. I know that
> implementing the debugfs support was not all trivial and saved time.
> If this savs time to other developers, why delete it?

Because normally, we do not just "leave code around" in the kernel for
someone else to pick up at some unknown time in the future because they
might just happen to need it.

'git revert' is a wonderful thing, and simple, if people want to add
stuff back.

> > Anyway, if you want it there, that's fine, but no, the error message can
> > be ignored.  You should never have a different code flow if a debugfs
> > call fails or not.  So the patch I posted here is still correct and
> > should be applied.
> 
> I disagree with that. The usecase is for devleopers, who intentionally
> add own debugging information. It does not mean the code changes gets
> committed in the end, but the debugfs infrastructure is used and should
> work reliably at this point. This means that either the data get
> exported or there's an early exit when something goes wrong. Silent
> failure in this case can waste hours of testing or debugging.

There is no debugfs files or interaction at all here in btrfs.  So why
are you trying to create a directory that is never used, and if you
happen to have that fail, abort all of btrfs?

You should never have any "real" kernel code logic affected by what
debugfs happens to do, or not do.  It's a debugging interface, no one
should ever rely on it for a system to work properly.

And that's the main cleanup I did here, just call debugfs to create the
directory, and move on.  No need to worry if it worked or not (hint, it
almost allways will unless the system is out of memory, and at that
time, you have bigger problems).  The goal is to make it simpler to use
debugfs, and again, never have any problems that might happen in it
affect anything else in the kernel.

> I fail to see your logic to never rely on debugfs calls success/failure.
> Debugfs is a tool like any other, with narrow group of users and
> usecases but can be valuable.

Sure, but again, do not keep your system from working because debugfs
did something odd.

> If you need to extend return values or do other cleanups, then fine, but
> I'm not going to apply the patch in its current form as it would harm my
> own usecase, sorry.

What usecase is affected right now?  There is no usecase for this
directory at the moment :)

> > > I can enhance the comment so it's explained in-place and not too
> > > tempting to remove it. This is not the first time somebody wants to
> > > remove it
> > > (https://lore.kernel.org/linux-btrfs/d6715b5b-0aa3-3032-43c6-eccd907a60b8@redhat.com/),
> > 
> > If it keeps wanting to get removed, that's a big hint maybe you should :)
> 
> If there's a good explanation why it should be removed, then yes. If
> there's a reason to keep it, then no. So far I've seen drive-by attempts
> to remove some seemingly unused code by people who don't work in the
> area of the subsystem and may not understand its purpose.

We remove code that never gets used all over the place.  If you do use
it, great, put some users in the tree.  If you do not, then drop it and
it is simple to revert at some point in the future if you need it again.

thanks,

greg k-h
