Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbcEKI4b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 04:56:31 -0400
Date: Wed, 11 May 2016 10:56:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Trivial fix for typos in comments.
Message-ID: <20160511085607.GY29353@suse.cz>
Reply-To: dsterba@suse.cz
References: <1462839210-10040-1-git-send-email-nsteeves@gmail.com>
 <20160510133359.GS29353@twin.jikos.cz>
 <CAD=QJKjYTv4-7srx2zPTJNnF97BFFsQ4kLz3+PpC_Qgfb3b33Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD=QJKjYTv4-7srx2zPTJNnF97BFFsQ4kLz3+PpC_Qgfb3b33Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 10, 2016 at 07:42:50PM -0400, Nicholas D Steeves wrote:
> On 10 May 2016 at 09:33, David Sterba <dsterba@suse.cz> wrote:
> > On Mon, May 09, 2016 at 08:13:29PM -0400, Nicholas D Steeves wrote:
> >> Trivial fix for typos in comments; I hope this patch isn't a nuisance!
> >
> > No, but I don't see the typos in any of the branches (master or the
> > for-next snapshots).
> 
> Sorry, I used for-linus, while following this guide:
> "git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
> for-linus"
> https://btrfs.wiki.kernel.org/index.php/Writing_patch_for_btrfs
> 
> and "git checkout master" confirms that I'm already on 'master', but
> "git rebase next" produces the error:
> 
> fatal: Needed a single revision
> invalid upstream next

You'd need to have the linux-next git tree or my kernel.org tree
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git

> I'm very new to git.  Should I have cloned the whole linux-btrfs.git
> without "for-linus"?  Am I on the a master branch for the for-linus
> module, which is separate from the master branch of the main
> linux-btrfs?

If not sure, look at other branches, timestamps etc. The plain for-linus
in chris' repo is from january and on top of 4.3. There are other
for-linus branches with a version. There's no predefined style for
naming so it could be confusing. Git comes with a nice feature
'git instaweb' that will present the local git repository in a web
browser and it's very handy for quick peeks into other branches.

> On 10 May 2016 at 10:20, David Sterba <dsterba@suse.cz> wrote:
> Message-ID: <20160510142028.GU29353@twin.jikos.cz>
> > On Mon, May 09, 2016 at 08:13:29PM -0400, Nicholas D Steeves wrote:
> > I ran ispell on the strings from comments, there are like 90+ typos
> > (attached) that seem worth fixing, if you like.
> 
> Thank you for the list, I'd be happy to.  Are patches against master
> or next preferred (I don't see a for-next branch)?

The for-next branch is in my kenrel.org repo, otherwise the snapshots
(named like for-next-20160510) are hosted in my development
repositories. Basing on master should be fine, the for-next branches are
sort of in flux so we could miss some typos from there, but no big deal.
The list I sent was from master sources.
