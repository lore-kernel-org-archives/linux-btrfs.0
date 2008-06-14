From: "Thomas Lindroth" <thomas.lindroth@gmail.com>
Subject: Re: kernel BUG at volumes.c:1705
Date: Sat, 14 Jun 2008 11:22:54 +0200
Message-ID: <3d08dbff0806140222w677896e3s4835524e3d796794@mail.gmail.com>
References: <3d08dbff0806120907r3bfc9701g24710b56da3e10b7@mail.gmail.com>
	 <1213320815.10187.336.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1213320815.10187.336.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 6/13/08, Chris Mason <chris.mason@oracle.com> wrote:
> On Thu, 2008-06-12 at 18:07 +0200, Thomas Lindroth wrote:
>  > Hello
>  >
>  > I'm using a recently pulled stable checkout on Gentoo i386 with kernel
>  > 2.6.24 and I get this message:
>
>
>
> > I got a similar message yesterday using plain 0.15 without any
>  > hotfixes. The message occurred when I was unrar:ing files on the FS.
>  > Both messages show crc errors but I don't think there is anything
>  > wrong with the disk.
>  >
>
>
> The hotfixes do fix a memory corruption that was present in 0.14.  Could
>  you please try the hotfixes?

The first time I got the message I was using 0.15 without hotfixes but
after that I started using the stable repository from
http://www.kernel.org/hg/btrfs/kernel and still got the same or a
similar message. It looks like the stable repository contain the
hotfixes. I included both messages for reference in my previous post.
If a message contains the line
kernel BUG at /home/cocobo/btrfs_dev/kernel/volumes.c:1705!
then that message is from when I was using the stable repository version.
