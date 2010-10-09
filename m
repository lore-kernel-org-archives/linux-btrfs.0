From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: revisiting "Hard link across subvolumes"
Date: Sat, 9 Oct 2010 15:44:19 +0200
Message-ID: <201010091544.19468.kreijack@libero.it>
References: <AANLkTim28O+6b86Cuoxgt5sht6KK2Xq=iwMNp46X1ceL@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: David Nicol <davidnicol@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim28O+6b86Cuoxgt5sht6KK2Xq=iwMNp46X1ceL@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, 09 October, 2010, you (David Nicol) wrote:
> could i-node numbers be made unique on a whole device, or somehow
> adjusted to avoid collisions, instead of simply disallowing this
> useful operation?

In case of a snapshot make sense to preserve the inode number.

> On Thu, Oct 7, 2010 at 4:13 PM, Goffredo Baroncelli <kreijack@libero.it> 
wrote:
> 
> > The link across subvolumes is not allowable.  In the beginning it was
> > possible, but that was source of bugs. See the thread "Hard link across
> > subvolumes"
> >
> > http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03286.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
