From: "Yang, Yi Y" <yi.y.yang@intel.com>
Subject: RE: How to get the default subvolume?
Date: Fri, 8 Jul 2011 18:28:54 +0800
Message-ID: <FC2FB65B4D919844ADE4BE3C2BB739AD6B06BC94@shsmsx501.ccr.corp.intel.com>
References: <20110708095802.GA11513@yangyi-dev.bj.intel.com>
 <20110708095802.GA19280@carfax.org.uk>
 <FC2FB65B4D919844ADE4BE3C2BB739AD6B06BC86@shsmsx501.ccr.corp.intel.com>
 <20110708101329.GB19280@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110708101329.GB19280@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

>From your source, you defined some structures using python and use them to get and parse btrfs metadata, very advanced and complicated :-), do you know there is any library to provide similar APIs in order that I can use some advanced APIs and don't need to worry  about frequent changes of btrfs superblock and other metadata.

-----Original Message-----
From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Hugo Mills
Sent: Friday, July 08, 2011 6:13 PM
To: Yang, Yi Y
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to get the default subvolume?

On Fri, Jul 08, 2011 at 06:06:02PM +0800, Yang, Yi Y wrote:
> That's great, can you share your source code with me? I'm very eager 
> to get this now :-)

   http://carfax.org.uk/btrfs-gui
   http://git.darksatanic.net/repo/btrfs-gui.git/

   You probably want the btrfsgui.hlp.subvol.sv_list() function.

   Hugo.

> -----Original Message-----
> From: Hugo Mills [mailto:hugo@carfax.org.uk]
> Sent: Friday, July 08, 2011 5:58 PM
> To: Yang, Yi Y
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: How to get the default subvolume?
> 
> On Fri, Jul 08, 2011 at 05:58:02PM +0800, Yi Yang wrote:
> > I know I can set the default subvolume for a btrfs fs using
> > 
> > sudo btrfs subvolume set-default 256 /btrfs/mnt
> > 
> > But after that, how can get the default subvolume name? In my 
> > opinion, btrfs-progs should provide "btrfs subvolume get-default 
> > /btrfs/mnm" to get the default subvolume id and name, I think it is 
> > very easy to do this in btrfs-progs and btrfs kernel space.
> 
>    I don't think the current btrfs-progs will do it. As you pointed 
> out though, it's pretty easy to write the code to get the information 
> (I implemented it for btrfs-gui without any additional kernel code, 
> for example). We just need someone to implement it. :)
> 
>    I'd do it myself, but there's about a dozen things higher up my priority list right now.
> 
>    Hugo.
> 

--
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                      --- vi: The core of evil. ---                      
