From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: severe hardlink bug
Date: Sun, 24 Jan 2010 14:15:47 +0100
Message-ID: <201001241415.47519.kreijack@inwind.it>
References: <20100124015138.092c4959@simplux> <201001240909.44753.kreijack@libero.it> <20100124140837.5efcd526@simplux>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100124140837.5efcd526@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 24 January 2010, you (Dipl.-Ing. Michael Niederle) wrote:
> Hi, Goffredo!
> 
> > See this thread:
> 
> > Mass-Hardlinking Oops - 

May be that the link was broken in two line in the previous mail.
I copied again the ling. please give a try to see the thread.

http://thread.gmane.org/gmane.comp.file-systems.btrfs/3427

> 
> Sorry, I didn't find the thread myself - despite of massive googeling. :-(
> 
> The gentoo scenario however is a real world application - no artificial
> situation, so it would be really nice to fix the hard link problem somewhere 
in
> the future!

At the time of the thread, some peoples raised concerns about this limit. But 
at the time nobody highlighted a real case which required a lot of hard links.

Pay attention that in order to reach the limits the hard links have to be in 
the same directory.

If there is a real case in gentoo/bosybox, please send all the info. But in 
order solve this problem, it was told that a disk format change is required.

BR
Goffredo

 
> The problem will happen in all busybox-like scenarios - and long filenames 
are
> not so rarely used.
> 
> Greetings, Michael
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
