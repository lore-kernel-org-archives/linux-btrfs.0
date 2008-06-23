From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG at volumes.c:1705
Date: Mon, 23 Jun 2008 10:38:41 -0400
Message-ID: <1214231921.10187.553.camel@think.oraclecorp.com>
References: <3d08dbff0806120907r3bfc9701g24710b56da3e10b7@mail.gmail.com>
	 <1213320815.10187.336.camel@think.oraclecorp.com>
	 <3d08dbff0806140222w677896e3s4835524e3d796794@mail.gmail.com>
	 <1213618813.10187.387.camel@think.oraclecorp.com>
	 <3d08dbff0806180158o6718d3acy34ae5c48a23ad9f8@mail.gmail.com>
	 <1213792851.10187.420.camel@think.oraclecorp.com>
	 <485CCB69.8050500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Thomas Lindroth <thomas.lindroth@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <485CCB69.8050500@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2008-06-21 at 11:35 +0200, Thomas Lindroth wrote:
> Chris Mason wrote:
> > So, is the bittorrent program run every time you see the memory
> > corruption?
> > 
> > Could you please send along a few of the most common errors you see?
> 
> 
> It's possible to recreate it with mv, cp and other tools without having
> the torrent program running.
> 
> I've found a way to trigger the problem every time. If I copy a folder
> with music videos to a freshly created FS it will always fail on the
> same file when about 5.6G of data has been copied. The FS is 30G and
> there is nothing special with that file. If I only copy that file to a
> fresh FS everything works. I've also tried to run
> dd if=/dev/zero of=test to a fresh FS and I was able to write 15G, but I
> was not able to remove that file.
> 

Something in your config is much less stable than my test boxes here.
Focusing on the dd test, it looks like random corruption in the FS
metadata.  I see you've got gentoo i386 and a 2.6.24 kernel, are there
any other patches in that kernel?

-chris


