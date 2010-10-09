From: Mike Hommey <mh@glandium.org>
Subject: Re: Can you please define "snapshot" and "subvolume"?
Date: Sat, 9 Oct 2010 10:15:37 +0200
Message-ID: <20101009081537.GA4418@glandium.org>
References: <AANLkTimBsVGS=eJvpdf2Sq_Dg76zQRgy=E+3089zQ9D4@mail.gmail.com>
 <20101007131823.GB1536@glandium.org>
 <AANLkTinG8EN8x0=GxXq2x4W1uy6cZS078QQ5zDPFeDW2@mail.gmail.com>
 <201010072313.18647.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010072313.18647.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 07, 2010 at 11:13:18PM +0200, Goffredo Baroncelli wrote:
> On Thursday, 07 October, 2010, David Nicol wrote:
> > On Thu, Oct 7, 2010 at 8:18 AM, Mike Hommey <mh@glandium.org> wrote:
> > > BTW, it would be very useful to be able to turn existing directories
> > > into subvolumes.
> > 
> > does a (link,unlink) move work across subvolumes?
> 
> The link across subvolumes is not allowable.  In the beginning it was 
> possible, but that was source of bugs. See the thread "Hard link across 
> subvolumes"
> 
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03286.html

But couldn't cp --reflink be made to work?

Mike
