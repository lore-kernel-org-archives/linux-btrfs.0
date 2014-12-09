Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529AbaLIMQL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Dec 2014 07:16:11 -0500
Date: Tue, 9 Dec 2014 13:16:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Chris Mason <clm@fb.com>, dsterba@suse.cz,
        Dimitri John Ledkov <xnox@debian.org>, cwillu <cwillu@cwillu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Zygo Blaxell <zblaxell@furryterror.org>
Subject: Re: [RFC][PATCH v2] mount.btrfs helper
Message-ID: <20141209121609.GD20595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <547B5724.1060507@libero.it>
 <CANBHLUh9nXu4-wexFJimBvL-FtwPXQ7MeURi3COskJf-YJqGQA@mail.gmail.com>
 <CAE5mzvhOAi_Y2icLHOiUzG121ZALLZCTYhpjY8mkio3AyHrECA@mail.gmail.com>
 <CANBHLUhHktgJRYR5JDjPmvq=299iDR3xmwoPTjFh5ey7DnFxZw@mail.gmail.com>
 <1417793566.21214.11@mail.thefacebook.com>
 <CANBHLUgkY5YkFqe48H=vsS4w2uZr+nU0NBhy8o88A=vv3-nHkQ@mail.gmail.com>
 <20141205164144.GK9754@suse.cz>
 <5481F657.8090307@inwind.it>
 <1417805015.4845.0@mail.thefacebook.com>
 <54820CD7.8000808@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54820CD7.8000808@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 05, 2014 at 08:51:51PM +0100, Goffredo Baroncelli wrote:
> > From there if we really need a mount helper, it can either use a
> > libbtrfs to hit the scan code or be a bash script.
>  
> > Thanks for trying to smooth our or wrinkles in this area.  It's
> > definitely worth working on, I just want to make sure we recreate as
> > little infrastructure as possible ;)
> 
> This is an RFC because I am not sure about the "right" direction.
> My first goal is more to start a "sane" discussion, than provide a 
> solution.
> 
> But I have to point out that "btrfs device scan" usually is started
> by udev, so no possibility to show [see] an error. More, btrfs dev scan is
> started on a device "alone", from which is impossible to check
> dev.uuid conflicts... [except if you accept to extend the analysis 
> to all devices] [*]

Agreed with the way errors can be reported from udev hooks, the mount is
IMO best time to report incomplete filesystems (aka "failed to read
system error" in dmesg). Extending device scan will not help here
AFAICS. 
