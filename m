From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Can you please define "snapshot" and "subvolume"?
Date: Sat, 9 Oct 2010 15:55:01 +0200
Message-ID: <201010091555.01645.kreijack@libero.it>
References: <AANLkTimBsVGS=eJvpdf2Sq_Dg76zQRgy=E+3089zQ9D4@mail.gmail.com> <201010072313.18647.kreijack@libero.it> <20101009081537.GA4418@glandium.org>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Mike Hommey <mh@glandium.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101009081537.GA4418@glandium.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, 09 October, 2010, you (Mike Hommey) wrote:
> On Thu, Oct 07, 2010 at 11:13:18PM +0200, Goffredo Baroncelli wrote:
> > On Thursday, 07 October, 2010, David Nicol wrote:
> > > On Thu, Oct 7, 2010 at 8:18 AM, Mike Hommey <mh@glandium.org> wrote:
> > > > BTW, it would be very useful to be able to turn existing directories
> > > > into subvolumes.
> > > 
> > > does a (link,unlink) move work across subvolumes?
> > 
> > The link across subvolumes is not allowable.  In the beginning it was 
> > possible, but that was source of bugs. See the thread "Hard link across 
> > subvolumes"
> > 
> > http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03286.html
> 
> But couldn't cp --reflink be made to work?
> 
I don't know why, but I can confirm that in the btrfs kernel source it is 
checked the case that the "reflink" is preformed between two subvolume. And in 
this case this action is denied.

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-
unstable.git;a=blob;f=fs/btrfs/ioctl.c;h=9254b3d58dbef22974af3c7c61dbc9a4af7a33b6;hb=HEAD#l1489

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
