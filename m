Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30108 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3HAKRU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Aug 2013 06:17:20 -0400
Date: Thu, 1 Aug 2013 18:17:11 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add dedup subcommand
Message-ID: <20130801101710.GD20228@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
 <1375285066-14173-7-git-send-email-bo.li.liu@oracle.com>
 <51F93BAD.4030306@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51F93BAD.4030306@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 31, 2013 at 06:30:37PM +0200, Stefan Behrens wrote:
> On Wed, 31 Jul 2013 23:37:46 +0800, Liu Bo wrote:
> > This aims to add deduplication subcommand, 'btrfs dedup command <path>',
> > ie. register/unregister'.
> > 
> > It can be used to enable or disable dedup support for a filesystem.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  Makefile     |    2 +-
> >  btrfs.c      |    1 +
> >  cmds-dedup.c |  101 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  commands.h   |    2 +
> >  ctree.h      |    2 +
> >  ioctl.h      |    5 +++
> >  6 files changed, 112 insertions(+), 1 deletions(-)
> >  create mode 100644 cmds-dedup.c
> 
> No manpage?
> 

Good reminder, thanks very much.

-liubo
