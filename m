Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50986 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756399AbcIVQZr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 12:25:47 -0400
Date: Thu, 22 Sep 2016 18:23:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Cc: Rich Freeman <r-btrfs@gw.thefreemanclan.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: unable to handle kernel paging request - btrfs
Message-ID: <20160922162345.GT16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <57E3D23C.3050905@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <57E3D23C.3050905@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2016 at 02:44:44PM +0200, Holger Hoffstätte wrote:
> On 09/22/16 14:18, Rich Freeman wrote:
> > I have been getting panics consistently after doing a btrfs replace
> > operation on a raid1 and rebooting.  I linked a photo of the panic; I
> > haven't been able to get a text capture of it.
> > 
> > https://ibin.co/2vx0HhDeViu3.jpg
> > 
> > I'm getting this error on the latest 4.4, 4.1, and even on an old
> > 3.18.26 kernel I had lying around.
> 
> What happens when you try to boot e.g. SystemRescueCD?
> If it is what I think it is (see below) then that should start bombing
> as well.
> 
> > I'm able to boot into single-user mode and if I don't start any
> > processes the system seems fairly stable.  I am also able to start a
> > btrfs balance and run that for several hours without issue.  If I
> > start launching services the system will tend to panic, though how
> > many processes I can launch will vary.  I don't think that it is a
> > particular file being accessed that is triggering the issue since the
> > point where it fails varies.  I suspect it may be load-related.
> 
> If the SystemRescue method does not work then you have either
> an overheating/dying CPU or - more likely - bad memory.

Maybe a bad memory, I'd suspect other layers than the filesystem. The
faulty address is 0xfff...ffd8 which is -40 == -ELOOP. This error code
is not used in btrfs. It looks like an error code ended up returned as a
pointer so any access to it explodes. The last line in the list is

"Fixing recursive fault but reboot is needed"

so it's recursive or looping somewhere deep in the memory management.
