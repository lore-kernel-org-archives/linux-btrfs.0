From: David Sterba <dave@jikos.cz>
Subject: Re: A Plumber???s Wish List for Linux
Date: Mon, 10 Oct 2011 13:18:13 +0200
Message-ID: <20111010111813.GF17912@twin.jikos.cz>
References: <1317943022.1095.25.camel@mop> <20111007111231.6e11d18e@lxorguk.ukuu.org.uk> <CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com> <20111007113820.3b8424a8@lxorguk.ukuu.org.uk> <CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com> <20111007152137.GE28351@carfax.org.uk>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org, lennart@poettering.net,
	harald@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111007152137.GE28351@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 07, 2011 at 04:21:37PM +0100, Hugo Mills wrote:
> On Fri, Oct 07, 2011 at 02:46:23PM +0200, Kay Sievers wrote:
> > On Fri, Oct 7, 2011 at 12:38, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > On Fri, 7 Oct 2011 12:28:46 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:
> > >
> > >> What do you mean would be ugly?
> > >
> > > I have an ext4fs. It supports every possible file name allowed by POSIX
> > > and SuS. What name are you going to use for your 'hidden directory' that
> > > won't clash with a real file ?
> > 
> > Ah, no. The label on FAT (similar on NTFS) are 'magic entries' in the
> > root dir list, not a real file in the root dir.
> > 
> > We need kernel support for changing a mounted fs, because, unlike
> > ext4, the blocks containing the strings are inside the fs, which the
> > kernel might change any time.
> 
>    It's worth noting that there are similar issues with btrfs around
> changing label. A common API for it would make sense. The only btrfs
> patches I've seen to change label after mkfs-time work either as:
> 
>  * unmounted only, single underlying device only, pure userspace
>    implementation
>  * mounted only, multiple underlying devices, kernel support needed
> 
>    The kernel-side patches never got integrated, so we're still unable
> to change the label on the majority of btrfs filesystems.
> 
>    Changing the UUID for the filesystem is even harder, as I think
> it's written to every metadata block. I'm not sure we can do that
> sanely on a mounted filesystem.

http://marc.info/?l=linux-btrfs&m=131161949201880&w=2

"Resetting the UUID on btrfs isn't a quick-and-easy thing - you have to
walk the entire tree and change every object. We've got a bad-hack in
meego that uses btrfs-debug-tree and changes the UUID while it runs
the entire tree, but it's ugly as hell."

That's on an unmoutned fs. Doing it on a mounted one seems more
complicated wrt to the intermediate state when there are some blocks
with the old and some block wit the new UUID. The operation will take
long and I don't know if it's better do to do it in batches (and
follow usual rules for commiting a transaction every now and then), or
in one go (requires: no failures, no scrub run, no devices
added/removed). Counting all potential problems and practical
unusability of the FS during UUID change, the off-line approach seems a
better way to go.


david
