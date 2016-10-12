Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:47637 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755863AbcJLTKj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 15:10:39 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u9CJAbj0018992
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Oct 2016 19:10:37 GMT
Date: Wed, 12 Oct 2016 12:14:44 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/7] Btrfs: replace BUG() with WARN_ONCE in raid56
Message-ID: <20161012191444.GA4764@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
 <57388570.1050607@applied-asynchrony.com>
 <20160516083248.GA511@twin.jikos.cz>
 <20161012150655.GS11398@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20161012150655.GS11398@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 05:06:55PM +0200, David Sterba wrote:
> On Mon, May 16, 2016 at 10:32:48AM +0200, David Sterba wrote:
> > On Sun, May 15, 2016 at 04:19:28PM +0200, Holger Hoffstätte wrote:
> > > On 05/14/16 02:06, Liu Bo wrote:
> > > > This BUG() has been triggered by a fuzz testing image, but in fact
> > > > btrfs can handle this gracefully by returning -EIO.
> > > > 
> > > > Thus, use WARN_ONCE for warning purpose and don't leave a possible
> > > > kernel panic.
> > > > 
> > > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > > > ---
> > > >  fs/btrfs/raid56.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> > > > index 0b7792e..863f7fe 100644
> > > > --- a/fs/btrfs/raid56.c
> > > > +++ b/fs/btrfs/raid56.c
> > > > @@ -2139,7 +2139,7 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
> > > >  
> > > >  	rbio->faila = find_logical_bio_stripe(rbio, bio);
> > > >  	if (rbio->faila == -1) {
> > > > -		BUG();
> > > > +		WARN_ONCE(1, KERN_WARNING "rbio->faila is -1\n");
> > > 
> > > I'm generally in favor of not BUGing out for no good reason, but what
> > > is e.g. an admin (or user) supposed to do when he sees this message?
> > > Same for the other rather cryptic WARNs - they contain no actionable
> > > information, and are most likely going to be ignored as "debug spam".
> > > IMHO things that can be ignored can be deleted.
> > 
> > Agreed, the way this patchset repalces BUG on is very confusing.
> > WARN_ONCE is a global state, the message does not even print on which
> > filesystem the error happened. The only way to reset the state is to
> > unload the module.
> > 
> > This should be handled as a corruption, no matter if it's fuzzed or not,
> > report more details about what is corrupted or what was expected.
> 
> Looking again at the patch, it compares an inode property (a range to
> cow) against a global filesystem size, stored in superblock. This does
> not IMO belong here, either we'd have to do such check everywhere (and
> expect that it could really happen) or it should be removed completely.

(Are we talking about "[PATCH 2/7] Btrfs: replace BUG_ON with WARN_ONCE in cow_file_range"?)

In theory we don't need to do such a check because we've gone through
the reservation part which ensures that we have enough space,
whether super::total_bytes is valid can be verified during the mount
stage.  I prefer to removing it.

Thanks,

-liubo
