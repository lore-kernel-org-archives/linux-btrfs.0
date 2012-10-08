Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab2JHRyd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 13:54:33 -0400
Date: Mon, 8 Oct 2012 18:01:55 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121008170155.GF24071@rhmail.home.annexia.org>
References: <20121008141642.GC24071@rhmail.home.annexia.org>
 <20121008142757.GB4132@shiny>
 <20121008145730.GD24071@rhmail.home.annexia.org>
 <20121008150419.GE4132@shiny>
 <20121008151513.GE24071@rhmail.home.annexia.org>
 <20121008164227.GH4405@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121008164227.GH4405@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 08, 2012 at 06:42:27PM +0200, David Sterba wrote:
> On Mon, Oct 08, 2012 at 04:15:14PM +0100, Richard W.M. Jones wrote:
> > Unfortunately I'm struggling to reproduce this outside of our build
> > system (Koji).  I will keep you informed if I do manage to reproduce
> > it locally.  Adding fsync /dev/sda1 was also my first instinct :-)
> 
> Have you updated the VM/guest related packages recently? This may be a
> bug in the VM drivers.

qemu hasn't been updated for over a week.  However I'm having a hard
time understanding how even a change to qemu's caching would in any
way affect only btrfs and nothing else.  The libguestfs test suite is
extremely comprehensive and tests many other filesystems, and none of
them are failing.

These guests are built on the fly from the latest packages in Fedora,
so any other package might be the cause, but it seems like the kernel
is the most likely candidate.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://et.redhat.com/~rjones/virt-df/
