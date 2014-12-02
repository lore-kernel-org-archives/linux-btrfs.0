Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbaLBMwx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Dec 2014 07:52:53 -0500
Date: Tue, 2 Dec 2014 13:52:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141202125252.GR12140@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org>
 <547C6922.6030206@gmail.com>
 <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu>
 <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
 <20141202031403.GZ17395@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141202031403.GZ17395@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 01, 2014 at 10:14:03PM -0500, Zygo Blaxell wrote:
> > export BTRFS_SUBVOLUME_DELETE_CONFIRM=1
> > 
> > Ideas?
> 
> Never rely on aliasing or environment variables for defaults, and never
> change default behavior if your releases are old enough that someone
> has built scripts on top of them.  ;)

Exactly.

> If I had to pick the least evil, I'd go for interactive prompting by
> default (do nothing if the interaction fails, e.g. no TTY) and add a
> '-f'/'--force' flag to bypass the prompt.

This sounds acceptable.

> This is consistent with the
> way lvm2 and mdadm work when presented with data-losing or otherwise
> questionable commands and parameters.  It will break scripts, but btrfs
> users should still be expecting that for a while as undesirable default
> behaviors are identified.

How is this going to break scripts?

> OTOH maybe there is no issue with the current behavior.  Only root can
> delete subvolumes, and maybe we assume root knows what they're doing?

With the mount option user_subvol_rm_allowed the user can delete subvols
as well, so it makes sense to add the confirmation.

> On a side note...only root can delete subvolumes, but non-root users
> can create them, which results in...this:
> 
> 	$ /sbin/btrfs sub create foo
> 	Create subvolume './foo'
> 	$ date > foo/bar
> 	$ /sbin/btrfs sub delete foo
> 	Transaction commit: none (default)
> 	Delete subvolume '/home/testuser/foo'
> 	ERROR: cannot delete '/home/testuser/foo' - Operation not permitted
> 	$ rm -rf foo
> 	rm: cannot remove `foo': Operation not permitted
> 	$ cat /proc/version
> 	Linux version 3.17.1-zb64+ (root@buildbot) (gcc version 4.7.2 (Debian 4.7.2-5) ) #1 SMP PREEMPT Tue Oct 21 00:17:49 EDT 2014
> 
> ...uh oh?

That's how it works now. I'd like to enable the user to delete their
subvolumes even without the user_subvol_rm_allowed option someday.
