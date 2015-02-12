Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809AbbBLNQQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 08:16:16 -0500
Date: Thu, 12 Feb 2015 14:16:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 00/10] Enhance btrfs-find-root and open_ctree() to
 provide better chance on damaged btrfs.
Message-ID: <20150212131614.GA8720@suse.cz>
Reply-To: dsterba@suse.cz
References: <1422522437-18886-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150210144839.GC28877@twin.jikos.cz>
 <54DAA33F.7040109@cn.fujitsu.com>
 <20150211175226.GF28877@twin.jikos.cz>
 <54DC0381.9050303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <54DC0381.9050303@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 12, 2015 at 09:36:01AM +0800, Qu Wenruo wrote:
> Subject: Re: [PATCH v3 00/10] Enhance btrfs-find-root and open_ctree() 
> to provide better chance on damaged btrfs.
> From: David Sterba <dsterba@suse.cz>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2015年02月12日 01:52
> > On Wed, Feb 11, 2015 at 08:33:03AM +0800, Qu Wenruo wrote:
> >>>> Also, since only 2 patches is modified(although other part is slightly
> >>>> modified to match the change), to avoid mail bombing, I created the pull
> >>>> request on github and only send the first 2 patches with cover-letter.
> >>>> https://github.com/kdave/btrfs-progs/pull/5
> >>> Sending the changed patches only is ok (if you point me at the rest of
> >>> the patches), but it's not necessary to open the github pull request.
> >>>
> >>> The version to version changelogs are also stored in the commit
> >>> changelogs, that's a bit unexpected for a branch to be pulled.
> >> Oh, very sorry for this.
> >> I was meant to save your time, but I forgot that pull branch won't emit
> >> the changelog like patches.
> > Pulled except the last patch, and I've cleaned up some bits so please
> > have a look. It's basically what I'd tell you during a normal review but
> > now it was easier to do myself.
> Thanks for merging and modifying them.
> It seems that my naming sense is not so good and the new naming looks 
> good for me, except some of them,
> like OPEN_CTREE_SUPPRESS_CHECK_TREE_ERROR seems too long for me, but 
> that's all right and doesn't
> do any harm.

Yeah it's long and I'm not completely happy about that but I gave
preference to descriptiveness as we may want to add other fine tuning
flags to open_ctree. As the TODO you've added to the enum definition
says, we may split the flags and then cleanup as needed.

> And it seems that the patch I send it still out of date and some naming 
> changes in my v3 patch doesn't show in
> it...

I've used the v3 branch from github. Please send incremental fixes if I
missed something.

> > My concern about the patch "btrfs-progs: Allow open_ctree use backup
> > tree root or search it automatically if primary..." is the
> > 'automatically' part. Falling to the backup roots should be IMO on
> > request. The tools should have (and some of them already do have)
> > commandline options to request a given backup root. That way the user
> > can try the default action and then decide if the backup roots are fine
> > for use.
> What about ask user to do such fallback method?
> IMHO, such way should take a balance for average user and advanced user 
> who can, for example, extract
> the bad block and fix it manually without corruption.

Agreed this is about finding a good balance. However, here a regular
user could do more harm than good if the tool just "does something" and
does not stop if there's not a safe way forward.

> Current btrfsck has a problem that doesn't give enough info on possible 
> solutions.

Right, this should be improved in the long term. This requires
documentation of the internals and some level of knowledge even if the
tool provides options how to proceed.

> The case is much like --init-(csum/extent)-tree, we provide such 
> options, but when a tree block in extent
> tree happens, the backref mismatch error messages won't really help to 
> guide user to use --init-extent-tree
> option.
> 
> How do you think about the ask-user method?

The options are:

* exit if user input/decision is required
* pass command line options to checker to preset the behaviour
* add a specialized subcommand to fix a particular class of errors
* run checker in interactive mode that asks user if she/he wants to fix
  the problem, possibly how if there are more options

The superblock and root backup options are very handy in the analysis
phase, so one can see the differences in the output. I think the same
holds for the find-root command. We don't have a "cookbook" how to
analyze a broken filesystem. Your and my experience is probably
different in how to do the analysis but I believe we will find a common
ground and implement that into the tools and documentation.
