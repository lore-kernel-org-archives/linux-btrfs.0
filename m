Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab3JYKAs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 06:00:48 -0400
Date: Fri, 25 Oct 2013 12:00:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 3/3] btrfs-progs: separate command ant implementation of
 chunk-recover code
Message-ID: <20131025100046.GD28149@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1379430631.git.dsterba@suse.cz>
 <69b632706722652312df15e72befaec2b85174df.1379430631.git.dsterba@suse.cz>
 <CAKcLGm9tCpw--Omat+f8GoVUHzOA98FTq-mgFzLa=+Y=WH_w+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKcLGm9tCpw--Omat+f8GoVUHzOA98FTq-mgFzLa=+Y=WH_w+w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 24, 2013 at 03:31:55PM -0500, Mitch Harder wrote:
> On Tue, Sep 17, 2013 at 10:21 AM, David Sterba <dsterba@suse.cz> wrote:
> > The command has been moved and we should rename the files accordingly,
> > so the entry point is now in cmds-rescue.c and the core functionality
> > in it's own file.
> >
> > Return codes of btrfs_recover_chunk_tree have been simplified not to
> > require a define and another file for defintion.
> >
> > CC: Miao Xie <miaox@cn.fujitsu.com>
> > Signed-off-by: David Sterba <dsterba@suse.cz>
> > ---
> >  Makefile        |    3 +-
> >  chunk-recover.c | 1745 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  cmds-rescue.c   |   62 ++
> >  3 files changed, 1809 insertions(+), 1 deletion(-)
> >  create mode 100644 chunk-recover.c
> 
> I'm not sure if this patch has gone 'final' yet, but since it
> relocates the code from cmds-chunk.c to chunk-recover.c, the
> cmds-chunk.c file needs to be deleted.

Right, thanks for noticing.

david
