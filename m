Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59201 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbbC0KNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Mar 2015 06:13:20 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: fdmanana@gmail.com
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: number of hardlinks for directory in ls -lid always 1?
Date: Fri, 27 Mar 2015 11:13:18 +0100
Message-ID: <5158437.uj9bTtxEzW@merkaba>
In-Reply-To: <CAL3q7H5ycuGP=LFsC0Pm7uhO5OxrjzLfEXq-wkVZMHd9rJ5Bkw@mail.gmail.com>
References: <9389540.MYekrP2a8Q@merkaba> <20150320123922.GL20767@twin.jikos.cz> <CAL3q7H5ycuGP=LFsC0Pm7uhO5OxrjzLfEXq-wkVZMHd9rJ5Bkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 20. März 2015, 12:59:14 schrieb Filipe David Manana:
> On Fri, Mar 20, 2015 at 12:39 PM, David Sterba <dsterba@suse.cz> wrote:
> > On Thu, Mar 19, 2015 at 09:47:15PM +0000, Filipe David Manana wrote:
> >> On Thu, Mar 19, 2015 at 1:21 PM, David Sterba <dsterba@suse.cz> 
wrote:
> >> > On Wed, Mar 18, 2015 at 03:23:50PM +0100, Martin Steigerwald wrote:
> >> >> It explains that having a correct hardlink number for directory is
> >> >> not
> >> >> mandatory, but it doesn´t explain why BTRFS always has 1 in there
> >> >> instead of the actual count of hardlinks. Is this an performance
> >> >> optimization for BTRFS or are there any other reasons why BTRFS
> >> >> does it this way?>> > 
> >> > I believe it's for performance reasons. New inodes do not update
> >> > the
> >> > parent directory metadata wrt link counts, compared to other
> >> > filesystems that do that.
> >> 
> >> Weird. Because creating a new inode implies adding the dentry to the
> >> parent directory, which implies updating the directory's i_size.
> > 
> > I wonder why the link count is not maintained then. The directory
> > inode
> > is modified anyway, add a few ifs here and there will not make things
> > worse and we could get rid of this special behaviour, plus find could
> > use the link count reliably.
> > 
> > It can be turned on in a fully backward compatible way:
> > 
> > * new directories/subvolumes will get dir nlink set to 2
> > * if mkdir/rmdir/move sees a parent link count of 1, no change
> > * otherwise inc/dec the link count for new subdirectoris/subvolumes
> > 
> > Jeff Liu reported a problem, without further details
> > http://article.gmane.org/gmane.comp.file-systems.btrfs/14628
> > 
> > so I still might be missing something.
> 
> Maybe this was all before delayed inodes were introduced, where
> updating inode items always implied touching the btrees.

Interesting.

Well this came up due to an exercise to find all hardlinks to /usr/local 
in a Linux training. And one participant of the training did this on a 
SLES 11 SP 3 VM with BTRFS.

I did some search and indeed see nothing about link count for directories 
related to POSIX standard. Incrementing link count only seems to be 
mentioned for files:

http://pubs.opengroup.org/onlinepubs/009695399/functions/link.html

Even when people tend to rely on this behavior for forensics as in:

http://digital-forensics.sans.org/blog/2009/06/19/directory-link-counts-and-hidden-directories/

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
