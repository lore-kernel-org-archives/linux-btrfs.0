Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbaETLI2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 07:08:28 -0400
Date: Tue, 20 May 2014 13:08:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
 page for each btrfs subcommand.
Message-ID: <20140520110826.GI31608@suse.cz>
Reply-To: dsterba@suse.cz
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140416171219.GC29256@twin.jikos.cz>
 <20140517174315.GC2537@carfax.org.uk>
 <20140519140123.GG31608@suse.cz>
 <20140519143342.GH31608@suse.cz>
 <537AA30B.1050909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <537AA30B.1050909@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 20, 2014 at 08:34:19AM +0800, Qu Wenruo wrote:
> >Proposed changes:
> >- format all subcommands as bold instead of italic ('' -> **)
> >- add all missing <...>
> >- find a way how to add '...' around <...> (xsl or sed or whatever)
> >
> >Does that work for you?
> That is OK for me, I'll investigate it.
> 
> Should I send a new patchset or just delta patches upon the current base?

Don't bother, patches sent yesterday.
