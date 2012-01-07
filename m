From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH] Btrfs-progs: restriper interface
Date: Sat, 7 Jan 2012 17:14:43 +0200
Message-ID: <20120107151443.GA9084@zambezi.lan>
References: <1325860680-19403-1-git-send-email-idryomov@gmail.com>
 <201201071348.45052.kreijack@inwind.it>
 <20120107142529.GA8404@zambezi.lan>
 <20120107203251.24533460@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120107203251.24533460@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 07, 2012 at 08:32:51PM +0600, Roman Mamedov wrote:
> On Sat, 7 Jan 2012 16:25:29 +0200
> Ilya Dryomov <idryomov@gmail.com> wrote:
> 
> > IMHO it would be much better if we had our long names and a handful of
> > predefined abbreviations (like ip command for example).
> 
> Does the ip command use just a handful of predefined abbrebiations?
> 
> ip addr show
> ip add sho
> ip ad sh
> ip a s
> 
> all work. 
> which suggests to me they use exactly the same scheme as btrfs currently.

Look at ntbl for ntable, tunl for tunnel, tap for tuntap, lst for list,
etc.  On top af that they are using a "first match" policy, which leads
to a very simple and clean code and is not at all what btrfs uses:

ip route
ip rout
ip rou
ip ro
ip r

all work and expand to "ip route"

and if you want the "rule" sub-command, you have to use

ip ru

at the very least.

btrfs instead tries to be clever, and if ip was doing the same thing
btrfs does you would get "ambiguous command 'r'" error in response to
"ip r".

Thanks,

		Ilya

