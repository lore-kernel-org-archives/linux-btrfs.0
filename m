Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153AbaAVMFf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 07:05:35 -0500
Date: Wed, 22 Jan 2014 13:05:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Toggenburger Lukas <Lukas.Toggenburger@htwchur.ch>
Cc: Tomasz Torcz <tomek@pipebreaker.pl>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Working on Btrfs as topic for master thesis
Message-ID: <20140122120533.GE6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local>
 <20140117160436.GA3356@mother.pipebreaker.pl>
 <8E968DF3B7EC0D40B67B5A9D25675A6A0400BF@MBXSRV03EDU.edu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8E968DF3B7EC0D40B67B5A9D25675A6A0400BF@MBXSRV03EDU.edu.local>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 18, 2014 at 12:50:54PM +0000, Toggenburger Lukas wrote:
> Hello Tomasz
> 
> > Have you considered per-file/per-directory selection of raid level?
> 
> Sounds great, I haven't thought about it before.
> 
> Do you or someone else know what the current state of development is?
> Is someone working on this?

The feature lacks interface to specify the raid flags per-object. This
is WIP, keyword is 'properties', you'll find some preliminary patches in
the list. This is the ground work for all sorts of fancy tuning.

The filesystem split into areas with different raid levels will bring
interesting problems regarding free space and operations that cross the
raid levels. But I think it's doable.
