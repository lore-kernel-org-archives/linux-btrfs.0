Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:33541 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab2JJMiL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Oct 2012 08:38:11 -0400
Date: Wed, 10 Oct 2012 08:38:08 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: David Sterba <dave@jikos.cz>
CC: "Richard W.M. Jones" <rjones@redhat.com>,
        Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121010123808.GA31317@shiny>
References: <20121008141642.GC24071@rhmail.home.annexia.org>
 <20121008142757.GB4132@shiny>
 <20121008145730.GD24071@rhmail.home.annexia.org>
 <20121008150419.GE4132@shiny>
 <20121008151513.GE24071@rhmail.home.annexia.org>
 <20121008212230.GA13692@rhmail.home.annexia.org>
 <20121009000051.GA12735@shiny>
 <20121009072002.GJ24071@rhmail.home.annexia.org>
 <20121009073357.GB13692@rhmail.home.annexia.org>
 <20121009090012.GJ4405@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20121009090012.GJ4405@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 09, 2012 at 03:00:12AM -0600, David Sterba wrote:
> On Tue, Oct 09, 2012 at 08:33:57AM +0100, Richard W.M. Jones wrote:
> > On Tue, Oct 09, 2012 at 08:20:02AM +0100, Richard W.M. Jones wrote:
> > > On Mon, Oct 08, 2012 at 08:00:51PM -0400, Chris Mason wrote:
> > > > Ok, what's a rough idea of the mainline git equiv of the buggy kernel?
> > > 
> > > On my local machine, I'm reproducing this with what Fedora calls
> > > 3.7.0-0.rc0.git2.4.fc19.x86_64
> > 
> > OK, that's not very helpful is it :-)  AFAIK it should be possible
> > to reproduce this with Linus's git kernel, but I haven't proven
> > that yet.
> 
> Found the same error message in my logs with master+next:
> 
> Oct  8 15:07:25 kernel: [13048.856283] device fsid cd15a893-e955-49cc-989c-4fd952a838a6 devid 1 transid 3 /dev/sda9
> Oct  8 15:07:25 kernel: [13048.866880] btrfs: disk space caching is enabled
> Oct  8 15:07:25 kernel: [13048.875767] btrfs: failed to recover relocation
> Oct  8 15:07:25 kernel: [13048.884662] btrfs: open_ctree failed
> 
> There are some xfstests that triggered the related bug with stale data,
> I'm investigating further.

Check your progs, this commit was updated to continue instead of break.

https://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs.git;a=commitdiff;h=6eba9002956ac40db87d42fb653a0524dc568810;hp=bc130ecd0260e4ee6ffe07ae43fc90db281a4daa

The original commit triggered those errors during 204.

-chris

