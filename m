Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:42624 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab2JHO3K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 10:29:10 -0400
Date: Mon, 8 Oct 2012 10:29:08 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Christian Hesse <list@eworm.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: fix btrfs-progs build
Message-ID: <20121008142908.GC4132@shiny>
References: <20121008161713.218a6eb1@leda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20121008161713.218a6eb1@leda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 08, 2012 at 08:17:13AM -0600, Christian Hesse wrote:
> Hello everybody,
> 
> man pages for btrfs-progs are compressed by gzip by default. In Makefile the
> variable GZIP is use, this evaluates to 'gzip gzip' on my system. From man
> gzip:
> 
> > The environment variable GZIP can hold a set of default options for gzip.
> > These options are interpreted first and can be overwritten by explicit
> > command line parameters.
> 
> So using any other variable name fixes this. Patch is attached.

Ok, which system is this?  Just curious, I'll pull in the patch.

-chris
