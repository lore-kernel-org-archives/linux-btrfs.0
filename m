From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Can you please define "snapshot" and "subvolume"?
Date: Thu, 7 Oct 2010 23:13:18 +0200
Message-ID: <201010072313.18647.kreijack@libero.it>
References: <AANLkTimBsVGS=eJvpdf2Sq_Dg76zQRgy=E+3089zQ9D4@mail.gmail.com> <20101007131823.GB1536@glandium.org> <AANLkTinG8EN8x0=GxXq2x4W1uy6cZS078QQ5zDPFeDW2@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinG8EN8x0=GxXq2x4W1uy6cZS078QQ5zDPFeDW2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, 07 October, 2010, David Nicol wrote:
> On Thu, Oct 7, 2010 at 8:18 AM, Mike Hommey <mh@glandium.org> wrote:
> > BTW, it would be very useful to be able to turn existing directories
> > into subvolumes.
> 
> does a (link,unlink) move work across subvolumes?

The link across subvolumes is not allowable.  In the beginning it was 
possible, but that was source of bugs. See the thread "Hard link across 
subvolumes"

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03286.html


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
