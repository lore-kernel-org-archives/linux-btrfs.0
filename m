Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37054 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727501AbeGSPFq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 11:05:46 -0400
Date: Thu, 19 Jul 2018 16:22:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: Verify every chunk has corresponding block
 group at mount time
Message-ID: <20180719142213.GR26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-6-wqu@suse.com>
 <20180705151804.GH3126@twin.jikos.cz>
 <fc9a063d-27d9-dbe7-db6f-b780cf59a6f6@suse.de>
 <20180716131622.GI3126@twin.jikos.cz>
 <153199b2-0e2b-cbe7-7c35-f42e470e9a4e@gmx.com>
 <20180717123329.GX3126@twin.jikos.cz>
 <1e42f435-c769-015f-8039-0d68a5d8e1af@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1e42f435-c769-015f-8039-0d68a5d8e1af@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 17, 2018 at 09:32:27PM +0800, Qu Wenruo wrote:
> On 2018年07月17日 20:33, David Sterba wrote:
> > On Mon, Jul 16, 2018 at 09:57:43PM +0800, Qu Wenruo wrote:
> >>>>> -EUCLEAN ?
> >>>>
> >>>> Either works for me.
> >>>
> >>> That's not just a cosmetic change, there's a semantic difference between
> >>> the error codes, I maybe make that more explicit and not expect that this
> >>> is obvious.
> >>>
> >>> ENOENT does not make much sense in this context, the caller (mount in
> >>> this case) cannot do anything about a code that says 'some internal
> >>> structure not found'.
> >>
> >> The point here is, if every self-checker should only return -EUCLEAN, it
> >> won't really indicate what's going wrong, except points to some
> >> self-checker (and such self-checkers are growing larger than our
> >> expectation already).
> >>
> >> My practice here is, put some human readable and meaningful error
> >> message. No matter what we choose to return, the error message should
> >> tell us what's going wrong.
> >>
> >> In this case, I don't really care the return value. If it's explicitly
> >> needed to return -EUCLEAN, I could make all existing checker (from
> >> tree-checker to chunk/bg/dev-extent checker) to return -EUCLEAN if
> >> anything is wrong (and save several "ret = -EUCLEAN" lines).
> >> The return value doesn't really have much meaning nowadays, it's the
> >> error message important now.
> > 
> > Ok, I see what you mean. The message is important as it's otherwise
> > almost impossible to find where exactly the mount fails.
> > 
> > The error messages perhaps fall into several categories:
> > 
> > 1) transient errors, some failure that happens before the filesystem state
> >    is fully examined
> > 
> > this is namely ENOMEM, or EINTR eg. returned by kthread_run
> 
> This standard is a little misleading, or did I misunderstand your category?
> 
> From the example error number, I could only find ENOMEM so
> straightforward for end user/developer that we don't need any error
> message to explain them.
> Or this category is just for error no need of error message? (or can be
> handled by btrfs-progs without any need of user interruption/decision?)

Yes, that's the point that there does not need to be any message. The
error code should be selfexplanatory.

> > maybe also a failure on a multi-device filesystem when the devices
> > haven't been scanned yet
> > 
> > 2) clearly some corruption/consistency condtion, with enough information
> >    available to decide
> > 
> > like a missing tree, most of the tree-checker would fall into this
> > category
> 
> This is pretty clear.
> 
> > 
> > 3) same as the previous one, but there's some external condition preventing
> >    a full check
> > 
> > that's eg. a real EIO after reading a tree block
> 
> That csum mismatch EIO with error message or really some error from
> underlying layer like some ATA command failure?

The idea for 3 is to cover hard errors, like the ATA error or anything
that block layer/driver returns. The checksum mismatch is a soft error
that still can be considered an EIO ("I can't give you the data"). So
there could be another category with the soft errors like csum
mismatches or generation mismatches etc.

> > The error code are IMO important to see how severe the problems are and
> > what's the expected solution. 2 is for 'check', 3 may need degraded
> > mount, 1 needs maybe more time to mount again.
> 
> Category 2 for check is sure.
> For other 2 cases it's a little hard to say.
> Normally if we really hit some error we don't expect, under most case
> the filesystem is already corrupted (e.g. a lot of errors of resuming
> balance/mount failure finally turns out to be fs corruption).
> 
> If category is determined by the expected solution, most will just fall
> into category 2), including most of errors we have in btrfs module
> currently.

Agreed that most things fall to 2 and we can't do much about it other
than try 'check' detect the scope of damage.

> > With the error messages in place, 2 can be completely covered by
> > EUCLEAN. I briefly skimmed a few call paths and think that the 3
> > categories should be enough, but I'm also expecting some exceptions that
> > can be decided case by case.
> 
> For category 2), I think it's pretty clear and practically to use EUCLEAN.
> 
> For other categories I'm not really sure.
> 
> E.G what happens if we can't find certain backref when running delayed
> refs? It's either a kernel bug or a corrupted fs.
> Which category should it fit? Category 2? But we don't really know
> what's going wrong.

If some critical piece of data is missing, like the backref, then it's a
structural bug and it's for 2. The reason why it happened we may not
known at the moment, but it is still a detected corruption. If it turns
out it's a bug, then it'll get fixed and the corruption will not be
detected for the 'bug' reason, but can be for a corruption or memory
bitflip error.

> For category 1/3? It won't really be fixed until we fix the bug or the fs.
> 
> More details examples would definitely help me understand the category.
> 
> > The error codes are now not consistent, lots of EUCLEAN are historically
> > EIO, but before we start cleaning that up we should have at least some
> > guidelines. Please let me know what you think.
> > 
> At least for self-verification code it's pretty clear that we should
> have error message for what's going wrong and what we expect, with
> explicit EUCLEAN error number.

Agreed.
