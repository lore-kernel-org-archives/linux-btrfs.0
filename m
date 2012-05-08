From: David Sterba <dave@jikos.cz>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Tue, 8 May 2012 21:12:12 +0200
Message-ID: <20120508191212.GJ19331@twin.jikos.cz>
References: <C8TGUFbuCXB@helmut.hullen.de>
 <4FA968EB.6050306@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: helmut@hullen.de, Helmut Hullen <Hullen@t-online.de>,
	linux-btrfs@vger.kernel.org
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA968EB.6050306@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2012 at 08:41:47PM +0200, Felix Blanke wrote:
> >As I've written some hours ago: I run
> >
> >         btrfs fi balance ...
> >
> >after adding and after deleting a disk. Maybe it's not necessary.
> >Especially it seems not to be necessary after adding a disk.
> 
> What are the steps you're doing?! If this is really possible then there must
> be some sort of command that tells btrfs "Hey, I wanne remove this disk from
> the fs, please copy all data to the other disks and then remove the disk".
> Is there such a command? Haven't heard of one, but that would be
> interesting.

The 'btrfs device delete' command does what you described, a pretty
basic command, so I'm not sure if I did not miss something during this
thread.

> Otherwise if you remove a disk from a raid0 (doesn't matter if you have 2 or
> 5 or x disks in the fs, btrfs should stripe above all disks) your fs should
> be broken.

All data from the device being removed are relocated to the rest of the
device group.


david
