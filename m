Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mylinuxtime.de ([80.190.48.209]:46595 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2JHOag (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 10:30:36 -0400
Date: Mon, 8 Oct 2012 16:30:31 +0200
From: Christian Hesse <list@eworm.de>
To: Chris Mason <chris.mason@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: fix btrfs-progs build
Message-ID: <20121008163031.4656b6ff@leda>
In-Reply-To: <20121008142908.GC4132@shiny>
References: <20121008161713.218a6eb1@leda>
	<20121008142908.GC4132@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason@fusionio.com> on Mon, 2012/10/08 10:29:
> On Mon, Oct 08, 2012 at 08:17:13AM -0600, Christian Hesse wrote:
> > Hello everybody,
> > 
> > man pages for btrfs-progs are compressed by gzip by default. In Makefile
> > the variable GZIP is use, this evaluates to 'gzip gzip' on my system.
> > From man gzip:
> > 
> > > The environment variable GZIP can hold a set of default options for
> > > gzip. These options are interpreted first and can be overwritten by
> > > explicit command line parameters.
> > 
> > So using any other variable name fixes this. Patch is attached.
> 
> Ok, which system is this?  Just curious, I'll pull in the patch.

This is Arch Linux with gzip 1.5-1.
-- 
main(a){char*c=/*    Schoene Gruesse                         */"B?IJj;MEH"
"CX:;",b;for(a/*    Chris           get my mail address:    */=0;b=c[a++];)
putchar(b-1/(/*               gcc -o sig sig.c && ./sig    */b/42*2-3)*42);}
