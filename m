Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758871Ab3K1SiR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 13:38:17 -0500
Date: Thu, 28 Nov 2013 19:38:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Emil Karlson <jekarlson@gmail.com>
Cc: Pedro Fonseca <pfonseca@mpi-sws.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Warning in record_one_backref()
Message-ID: <20131128183815.GM25312@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <528B44BD.9050502@mpi-sws.org>
 <CAELSAVa+xA6NJ3UWw+C6xVegVhQKyPYZCLRU395+f5L4rN5qkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAELSAVa+xA6NJ3UWw+C6xVegVhQKyPYZCLRU395+f5L4rN5qkA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 19, 2013 at 01:36:43PM +0200, Emil Karlson wrote:
> On Tue, Nov 19, 2013 at 1:00 PM, Pedro Fonseca <pfonseca@mpi-sws.org> wrote:
> > Hi,
> >
> > In another test, I've encountered a few situations that triggered a warning
> > message in "record_one_backref()". I'm not sure if it's serious but it is
> > probably related to the concurrent defragment operations executed during the
> > test.
> >
> I think You'll need this patch or later linux-3.11 or linux-3.12
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=50f1319cb5f7690e4d9de18d1a75ea89296d0e53

The patch has been added to stable kernel 3.11.6.
