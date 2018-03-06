Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59057 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752931AbeCFUCy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 15:02:54 -0500
Date: Tue, 6 Mar 2018 12:02:47 -0800
From: Marc MERLIN <marc@merlins.org>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, fdmanana@gmail.com
Message-ID: <20180306200247.svrsko5zr5vldaes@merlins.org>
References: <20180305161619.prnkl4q4zcyibzhc@merlins.org>
 <32dcf3b9-e810-dc14-1a0b-005f9c49df0a@gmail.com>
 <20180305194718.GC613@merlins.org>
 <b323d987-9d97-f57e-b0d6-4ff405abf91c@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b323d987-9d97-f57e-b0d6-4ff405abf91c@mendix.com>
Subject: Re: How to change/fix 'Received UUID'
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 06, 2018 at 08:12:15PM +0100, Hans van Kranenburg wrote:
> On 05/03/2018 20:47, Marc MERLIN wrote:
> > On Mon, Mar 05, 2018 at 10:38:16PM +0300, Andrei Borzenkov wrote:
> >>> If I absolutely know that the data is the same on both sides, how do I
> >>> either
> >>> 1) force back in a 'Received UUID' value on the destination
> >>
> >> I suppose the most simple is to write small program that does it using
> >> BTRFS_IOC_SET_RECEIVED_SUBVOL.
> > 
> > Understdood.
> > Given that I have not worked with the code at all, what is the best 
> > tool in btrfs progs, to add this to?
> > 
> > btrfstune?
> > btrfs propery set?
> > other?
> > 
> > David, is this something you'd be willing to add support for?
> > (to be honest, it'll be quicker for someone who knows the code to add than
> > for me, but if no one has the time, I'l see if I can have a shot at it)
> 
> If you want something right now that works, so you can continue doing
> your backups, python-btrfs also has the ioctl, since v9, together with
> an example of using it:
> 
> https://github.com/knorrie/python-btrfs/commit/1ace623f95300ecf581b1182780fd6432a46b24d

Well, I had never heard about it until now, thank you.

I'll see if I can make it work when I get a bit of time.

Dear btrfs-progs folks, this would be great to add to the canonical
btrfs-progs too :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
