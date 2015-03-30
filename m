Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbbC3ObR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 10:31:17 -0400
Date: Mon, 30 Mar 2015 16:30:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: Marc Cousin <cousinmarc@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: snapshot destruction making IO extremely slow
Message-ID: <20150330143058.GJ32051@suse.cz>
Reply-To: dsterba@suse.cz
References: <550E7917.5030602@gmail.com>
 <20150325011937.GB20767@twin.jikos.cz>
 <55129428.7090508@gmail.com>
 <CAGfcS_n1CyDMXdAu6eKuwszz+hBxnHdLpgxwW63TPs9k2zFDbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGfcS_n1CyDMXdAu6eKuwszz+hBxnHdLpgxwW63TPs9k2zFDbQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 25, 2015 at 07:38:20AM -0400, Rich Freeman wrote:
> On Wed, Mar 25, 2015 at 6:55 AM, Marc Cousin <cousinmarc@gmail.com> wrote:
> > On 25/03/2015 02:19, David Sterba wrote:
> >> as it reads the pre/post snapshots and deletes them if the diff is
> >> empty. This adds some IO stress.
> >
> > I couldn't find a clear explanation in the documentation. Does it mean
> > that when there is absolutely no difference between two snapshots, one
> > of them is deleted ? And that snapper does a diff between them to
> > determine that ?
> >
> 
> It seems like there should be some supported way of doing a diff on
> two btrfs subvolumes.

> The problem is that we don't have any functionality in kernel space to
> do this (that I'm aware of), and we don't expose the necessary
> information to userspace for it to do this smartly (again, as far as
> I'm aware).

> Maybe there would be some way to do it using btrfs send and parsing the output.

If the subvolumes are read-only than the lightweight send (ioctl with
flag bit set BTRFS_SEND_FLAG_NO_FILE_DATA) could be used and I think
this was the expected usecase.
