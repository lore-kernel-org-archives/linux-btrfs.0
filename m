Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaLCSso (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Dec 2014 13:48:44 -0500
Date: Wed, 3 Dec 2014 19:48:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141203184843.GW12140@suse.cz>
Reply-To: dsterba@suse.cz
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org>
 <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu>
 <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
 <20141202031403.GZ17395@hungrycats.org>
 <20141202125252.GR12140@twin.jikos.cz>
 <20141202152555.GA17395@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141202152555.GA17395@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 02, 2014 at 10:25:55AM -0500, Zygo Blaxell wrote:
> On Tue, Dec 02, 2014 at 01:52:52PM +0100, David Sterba wrote:
> > > On a side note...only root can delete subvolumes, but non-root users
> > > can create them, which results in...this:
> > > 
> > > 	$ /sbin/btrfs sub create foo
> > > 	Create subvolume './foo'
> > > 	$ date > foo/bar
> > > 	$ /sbin/btrfs sub delete foo
> > > 	Transaction commit: none (default)
> > > 	Delete subvolume '/home/testuser/foo'
> > > 	ERROR: cannot delete '/home/testuser/foo' - Operation not permitted
> > > 	$ rm -rf foo
> > > 	rm: cannot remove `foo': Operation not permitted
> > > 	$ cat /proc/version
> > > 	Linux version 3.17.1-zb64+ (root@buildbot) (gcc version 4.7.2 (Debian 4.7.2-5) ) #1 SMP PREEMPT Tue Oct 21 00:17:49 EDT 2014
> > > 
> > > ...uh oh?
> > 
> > That's how it works now. I'd like to enable the user to delete their
> > subvolumes even without the user_subvol_rm_allowed option someday.
> 
> That seems...odd.  It should be symmetrical, i.e. if you can create a
> subvol you should be able to delete it, and if can't delete a subvol
> then you shouldn't be able to create them either.

It should and I don't know the exact reasons why it's been restricted.
AFAICS it should be safe to enable the user_subvol_rm_allowed mode by
default.

> I can imagine
> quite a bit of havoc could be wrought by an unprivileged user creating
> subvols indiscriminately (or in various specific, targeted locations).

Is this different from creating directories the same way?

There is a difference in metadata consumption between subvolume and
directory, but this would lead to "just" ENOSPC.
