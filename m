Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbbBKRw2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 12:52:28 -0500
Date: Wed, 11 Feb 2015 18:52:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 00/10] Enhance btrfs-find-root and open_ctree() to
 provide better chance on damaged btrfs.
Message-ID: <20150211175226.GF28877@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422522437-18886-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150210144839.GC28877@twin.jikos.cz>
 <54DAA33F.7040109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54DAA33F.7040109@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 11, 2015 at 08:33:03AM +0800, Qu Wenruo wrote:
> >> Also, since only 2 patches is modified(although other part is slightly
> >> modified to match the change), to avoid mail bombing, I created the pull
> >> request on github and only send the first 2 patches with cover-letter.
> >> https://github.com/kdave/btrfs-progs/pull/5
> > Sending the changed patches only is ok (if you point me at the rest of
> > the patches), but it's not necessary to open the github pull request.
> >
> > The version to version changelogs are also stored in the commit
> > changelogs, that's a bit unexpected for a branch to be pulled.
> Oh, very sorry for this.
> I was meant to save your time, but I forgot that pull branch won't emit 
> the changelog like patches.

Pulled except the last patch, and I've cleaned up some bits so please
have a look. It's basically what I'd tell you during a normal review but
now it was easier to do myself.

My concern about the patch "btrfs-progs: Allow open_ctree use backup
tree root or search it automatically if primary..." is the
'automatically' part. Falling to the backup roots should be IMO on
request. The tools should have (and some of them already do have)
commandline options to request a given backup root. That way the user
can try the default action and then decide if the backup roots are fine
for use.
