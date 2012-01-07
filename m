From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH] Btrfs-progs: restriper interface
Date: Sat, 7 Jan 2012 17:49:01 +0100
Message-ID: <201201071749.01583.kreijack@inwind.it>
References: <1325860680-19403-1-git-send-email-idryomov@gmail.com> <20120107203251.24533460@natsu> <20120107151443.GA9084@zambezi.lan>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120107151443.GA9084@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, 07 January, 2012 16:14:43 you wrote:
> On Sat, Jan 07, 2012 at 08:32:51PM +0600, Roman Mamedov wrote:
> > On Sat, 7 Jan 2012 16:25:29 +0200
> > 
> > Ilya Dryomov <idryomov@gmail.com> wrote:
> > > IMHO it would be much better if we had our long names and a handful of
> > > predefined abbreviations (like ip command for example).
> > 
> > Does the ip command use just a handful of predefined abbrebiations?
> > 
> > ip addr show
> > ip add sho
> > ip ad sh
> > ip a s
> > 
> > all work.
> > which suggests to me they use exactly the same scheme as btrfs currently.
> 
> Look at ntbl for ntable, tunl for tunnel, tap for tuntap, lst for list,
> etc.  On top af that they are using a "first match" policy, which leads
> to a very simple and clean code and is not at all what btrfs uses:
> 
> ip route
> ip rout
> ip rou
> ip ro
> ip r
> 
> all work and expand to "ip route"
> 
> and if you want the "rule" sub-command, you have to use
> 
> ip ru
> 
> at the very least.
> 
> btrfs instead tries to be clever, and if ip was doing the same thing
> btrfs does you would get "ambiguous command 'r'" error in response to
> "ip r".

You are right, but this is a bug. 

1) btrfs s sn -> means  btrfs subvolume snapshot
2) btrfs s se -> means  btrfs subvolume set-default
3) btrfs s s -> is ambiguous command because it could means both 1) and 2)

However if we try 1) we get an error. But this is not the intended behavior. I 
have to investigate why.

BR
G.Baroncelli


> 
> Thanks,
> 
> 		Ilya

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
