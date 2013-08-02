Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25100 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3HBC3m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Aug 2013 22:29:42 -0400
Date: Fri, 2 Aug 2013 10:29:32 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add dedup subcommand
Message-ID: <20130802022931.GD24158@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
 <1375285066-14173-7-git-send-email-bo.li.liu@oracle.com>
 <20130801220137.GB31381@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130801220137.GB31381@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 01, 2013 at 03:01:37PM -0700, Mark Fasheh wrote:
> On Wed, Jul 31, 2013 at 11:37:46PM +0800, Liu Bo wrote:
> > This aims to add deduplication subcommand, 'btrfs dedup command <path>',
> > ie. register/unregister'.
> > 
> > It can be used to enable or disable dedup support for a filesystem.
> 
> This seems to me like it should be a switch on btrfstune instead of a
> subcommand of the btrfs binary.

btrfstune is designed to play with flags if I understand it correctly.
Dedup is not about flipping a flag, but creating/deleting a tree.

But I'm OK with this idea :)

-liubo
