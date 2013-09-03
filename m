Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932726Ab3ICNlc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 09:41:32 -0400
Date: Tue, 3 Sep 2013 15:41:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>, Gabriel de Perthuis <g2p.code@gmail.com>,
        Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PROGS PATCH] Import btrfs-extent-same
Message-ID: <20130903134129.GB18147@suse.cz>
Reply-To: dsterba@suse.cz
References: <51CB6D5B.70302@gmail.com>
 <20130806153112.GL5284@twin.jikos.cz>
 <20130813193515.GG31381@wotan.suse.de>
 <20130902164358.GE23113@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130902164358.GE23113@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 02, 2013 at 06:43:58PM +0200, David Sterba wrote:
> > So I would suggest maybe something like the syhntax of btrfs-extent-same.c:
> > 
> > btrfs dedupe files len file1 loff1 file2 loff2 ...
> 
> I'm not sure I see what 'len' means here, length of the dedup block?

Now I'm reading more carefully, the arguments are the same as for
btrfs-extent-same that does only the simple task of deduping just one
extent, but that's not the point behind 'btrfs dedup files *'.

So there are 2 usecases:

1 - give it a bunch of files and try to dedup as much as possible among
    their data
2 - what btrfs-extent-same does, dedup just a specified range in 2 files

I'm not sure if #2 is going to be used widely though it would bring some
flexibility and fine tuning, besides testing purposes.

I think it would be good to keep both modes under one command, so it's a
matter of a sane UI.

#2 would look like:

$ btrfs dedup files --length 4096 --src-offset 0 --dest-offset 4096 file1 file2

and fail if != 2 files are given

#1 :

$ btrfs dedup files --min-length 65536 file1 file2 file3 ...

I think we could come up with more hints like 'min-length' based on user
requirements, but I'd like to get some agreement if this is the way to
go.

thanks,
david
