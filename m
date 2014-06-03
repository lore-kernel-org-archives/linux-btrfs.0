Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbaFCMTP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jun 2014 08:19:15 -0400
Date: Tue, 3 Jun 2014 14:19:13 +0200
From: David Sterba <dsterba@suse.cz>
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: doc: link btrfsck to btrfs-check
Message-ID: <20140603121913.GH22324@suse.cz>
Reply-To: dsterba@suse.cz
References: <20140416171219.GC29256@twin.jikos.cz>
 <1397668577-846-1-git-send-email-dsterba@suse.cz>
 <534F24A0.5000304@cn.fujitsu.com>
 <20140418144801.GG29256@suse.cz>
 <536AE073.2070307@cn.fujitsu.com>
 <20140512140917.GA6917@suse.cz>
 <CALOYprVO555k34EhKN85j=HBcD3=Wp9PGus+Gqej__xi2AghTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALOYprVO555k34EhKN85j=HBcD3=Wp9PGus+Gqej__xi2AghTQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 03, 2014 at 10:38:16AM +0100, WorMzy Tykashi wrote:
> I noticed this in another thread:
> 
> On 3 June 2014 10:14, David Sterba <dsterba@suse.cz> wrote:
> > I've assembled a branch containing doc-only fixes, including this one,
> > and asked Chris do do a 3.14.3 release.
> 
> Does this branch include this fix for this bug? According to
> patchwork, it's status is still "under review", but it's been a month
> and the bug slipped into the 3.14.2 release. I just want to make sure
> it hasn't fallen out of the pile. :)

Yes the branch contains this fix as well,

http://repo.or.cz/w/btrfs-progs-unstable/devel.git/shortlog/refs/heads/v3.14.x

and it almost fell off, I had forgotten to tag it in my mailbox and a
filter did not pick it.

About patchwork, I'm still using mailbox and git for tracking patches
and sync the patchwork status manually on occasion. This is not ideal
and patchwork status is not accurate. I'm aiming for a semi-automated
sync from git/mbox -> patchwork when the patches change their status
regarding stability and upstream readiness.
