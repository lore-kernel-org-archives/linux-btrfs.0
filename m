Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:46834 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502Ab2JYQdl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 12:33:41 -0400
Date: Thu, 25 Oct 2012 18:33:34 +0200
From: David Sterba <dave@jikos.cz>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS][V2] Update to parse_size()
Message-ID: <20121025163334.GK10679@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1351014715-5727-1-git-send-email-kreijack@inwind.com>
 <CAJHuE_DAJNSMF5nXiMxUiG0X4KGj4vwuT6QJbWpRBppuHA9HjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJHuE_DAJNSMF5nXiMxUiG0X4KGj4vwuT6QJbWpRBppuHA9HjQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 23, 2012 at 08:48:08PM +0200, Goffredo Baroncelli wrote:
> Sorry the version is V1 and not V2

> > Changelog:
> > V1: avoid to change the parse_size argument;
> >     better check of a wrong suffix;
> >     force strtoull to use a decimal base

[I looked at patches at your git repo, not sure if this was the V2, but
the changelog seems to apply]

Code basically looks ok, the individual patches do not have your
Signed-off-by lines, please add them for the final version. There are a
few code style issues, like

+       for( i=0 ; s[i] && isdigit(s[i]) ; i++ ) ;
+       if( !i ){

ie. the spaces around keywords etc. Progs share lots of code from kernel
and thus this is the prevalent stylep, please keep it like that (unless
the maintainer is fine with your style of course :)

You can drop the patch "Replace the function atoll with strtoull()" and
fold the change into "Check that the suffix for the parse_size() input
is of only one character."

> On Tue, Oct 23, 2012 at 7:51 PM, Goffredo Baroncelli <kreijack@gmail.com> wrote:
> > the following patches attempt to address some issues to the function
> > parse_size():
> > - this function is defined both in mkfs.c and cmds-filesystem.c; I
> > moved it in utils.c (which is already used in both mkfs.btrfs and
> > btrfs) in order to avoid code duplication.
> > - it used the function atoll(); I replaceed atoll() with strtoull()
> > because we are dealing with u64
> > - no check on suffixes was performed. If the user put 'MB' as suffix he got
> > bytes instead megabytes. The patches check the suffix is valid
> > - add new suffixes (t,p,e for terabytes, petabytes, exabytes)
> > - update the man page of the command mkfs.btrfs and
> > "btrfs filesystem defragment", both use parse_size()

Nice set of updates, thanks.

david
