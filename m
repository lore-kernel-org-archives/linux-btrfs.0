Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbcEPIdV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 04:33:21 -0400
Date: Mon, 16 May 2016 10:32:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger@applied-asynchrony.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/7] Btrfs: replace BUG() with WARN_ONCE in raid56
Message-ID: <20160516083248.GA511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
 <57388570.1050607@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <57388570.1050607@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 15, 2016 at 04:19:28PM +0200, Holger Hoffstätte wrote:
> On 05/14/16 02:06, Liu Bo wrote:
> > This BUG() has been triggered by a fuzz testing image, but in fact
> > btrfs can handle this gracefully by returning -EIO.
> > 
> > Thus, use WARN_ONCE for warning purpose and don't leave a possible
> > kernel panic.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/raid56.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> > index 0b7792e..863f7fe 100644
> > --- a/fs/btrfs/raid56.c
> > +++ b/fs/btrfs/raid56.c
> > @@ -2139,7 +2139,7 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
> >  
> >  	rbio->faila = find_logical_bio_stripe(rbio, bio);
> >  	if (rbio->faila == -1) {
> > -		BUG();
> > +		WARN_ONCE(1, KERN_WARNING "rbio->faila is -1\n");
> 
> I'm generally in favor of not BUGing out for no good reason, but what
> is e.g. an admin (or user) supposed to do when he sees this message?
> Same for the other rather cryptic WARNs - they contain no actionable
> information, and are most likely going to be ignored as "debug spam".
> IMHO things that can be ignored can be deleted.

Agreed, the way this patchset repalces BUG on is very confusing.
WARN_ONCE is a global state, the message does not even print on which
filesystem the error happened. The only way to reset the state is to
unload the module.

This should be handled as a corruption, no matter if it's fuzzed or not,
report more details about what is corrupted or what was expected.
