From: David Sterba <dave@jikos.cz>
Subject: Re: Create subvolume from a directory?
Date: Wed, 28 Mar 2012 11:20:36 +0200
Message-ID: <20120328092035.GC11610@twin.jikos.cz>
References: <loom.20120327T190041-268@post.gmane.org> <20120327222422.GA32675@suse.com> <CAG1y0sd9o07nckBzDPsG3w3BmFaByNxfAqQYWwf2Uzq2j1iZCA@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Matthias G. Eckermann" <mge@suse.com>, Alex <alex@bpmit.com>,
	linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sd9o07nckBzDPsG3w3BmFaByNxfAqQYWwf2Uzq2j1iZCA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 28, 2012 at 08:46:13AM +0700, Fajar A. Nugraha wrote:
> On Wed, Mar 28, 2012 at 5:24 AM, Matthias G. Eckermann <mge@suse.com> wrote:
> > While the time measurement might be flawed due to the subvol
> > actions inbetween, caching etc.: I tried several times, and
> > "cp --reflinks" always is multiple times faster than "mv" in
> > my environment.
> 
> So this is cross-subvolume reflinks? I thought the code for that
> wasn't merged yet?

Matthias was using SLES kernel, the cross-subvolume reflink patch is
present there, he was not aware it's not merged upstream.


david
