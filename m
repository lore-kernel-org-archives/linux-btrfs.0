From: Sander <sander@humilis.net>
Subject: Re: Offtopic: Which SAS / SATA HBA do you recommend?
Date: Mon, 20 Jul 2009 14:16:53 +0200
Message-ID: <20090720121653.GA2181@cumulus>
References: <20090720092838.GA1375@cumulus>
 <4A644580.7000401@enix.org>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, sander@humilis.net
To: S?bastien Wacquiez <sw@enix.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A644580.7000401@enix.org>
List-ID: <linux-btrfs.vger.kernel.org>

S?bastien Wacquiez wrote (ao):
> Sander wrote:
> > What SAS (or SATA) controller do you use or recommend in combination
> > with a SSD and BTRFS?
> > I'm looking for a non-RAID controller with four or eight ports and
> > of course full Linux support.
> 
> I don't have any ssd yet, but if you want cheap card without hardware
> raid, you could look at those :
> 
> http://www.supermicro.com/products/accessories/addon/AOC-USASLP-L8i.cfm
> http://www.supermicro.com/products/accessories/addon/AOC-USAS-L8i.cfm
> 
> You'll need to revert the bracket as they're designed to be in a
> supermicro UIO slot (In fact, they are just standart PCIe card upside
> down). They use the mptsas driver in linux which works ok for a long
> time, and can be found for ~ 130$. It work pretty fast (~ 800 Mo/s with
> a 8 drives raid10f2 in my brand new nehalem server).
> 
> You can also find this one  for ~ 120 bucks :
> http://www.supermicro.com/products/accessories/addon/AOC-SASLP-MV8.cfm
> 
> No proprietary slot this time, the chipset is supported in 2.6.30 (but I
> haven't tested it yet) via the mvsas drivers.
> 
> Hope you find this usefull.

Very useful, much appreciated, thanks!

I think I go for a Marvell based controller (again), as Marvell chips
seem to have quite a history when it comes to open source drivers.

No more Adaptec ..

Thanks again Sebastien.

	With kind regards, Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
