Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbaGDNFq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Jul 2014 09:05:46 -0400
Date: Fri, 4 Jul 2014 15:05:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: add ask_user confirmation for btrfstune
 clear seeding flag
Message-ID: <20140704130544.GM1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404353196-10914-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <20140703165145.GG1553@twin.jikos.cz>
 <1404439153.22279.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404439153.22279.10.camel@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 04, 2014 at 09:59:13AM +0800, Gui Hecheng wrote:
> > > --- a/btrfstune.c
> > > +++ b/btrfstune.c
> > > @@ -103,6 +104,7 @@ static void print_usage(void)
> > >  	fprintf(stderr, "\t-S value\tpositive value will enable seeding, zero to disable, negative is not allowed\n");
> > >  	fprintf(stderr, "\t-r \t\tenable extended inode refs\n");
> > >  	fprintf(stderr, "\t-x \t\tenable skinny metadata extent refs\n");
> > > +	fprintf(stderr, "\t-y \t\tsay yes to clear the seeding flag, make sure that you are aware of the danger\n");
> > 
> > The help text could say someting like
> > 
> > 		"--force\tallow dangerous changes\n"
> > 
> > btrfstune only allows setting the bit for extref and skinny-metadata,
> > unsetting would be dangerous as well.
> On my part, I don't find any scenarioes for these two, could you please
> remind me more?

For example the extended refs add a new key type representing the
hardlinks that do not fit into the leaf. Dropping the bit from incompat
bits will hide that. Mounting the filesystem on kernels < 3.7 will not
work as expected then.

The extref key is not necessarily used even if the bit is set, only if
the hardlinks do not fit, so dropping the bit will not automatically
cause a disaster.
