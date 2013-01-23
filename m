Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab3AWRmM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 12:42:12 -0500
Date: Wed, 23 Jan 2013 18:42:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org, Christian Hesse <list@eworm.de>
Subject: Re: [PATCH] fix btrfs-progs build
Message-ID: <20130123174210.GO28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130121164628.GK19967@twin.jikos.cz>
 <1358887879-6297-1-git-send-email-gene@czarc.net>
 <1358887879-6297-2-git-send-email-gene@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358887879-6297-2-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 22, 2013 at 03:51:19PM -0500, Gene Czarcinski wrote:
> From: Christian Hesse <list@eworm.de>
> 
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

I've added Christian's

Signed-off-by: Christian Hesse <list@eworm.de>

and modified the subject line to say

"btrfs-progs: fix build, manpage compression command"

david
