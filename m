Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:59438 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733AbbDWOrL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 10:47:11 -0400
Date: Thu, 23 Apr 2015 16:47:09 +0200
From: Lennart Poettering <lennart@poettering.net>
To: arnaud gaboury <arnaud.gaboury@gmail.com>
Cc: systemd <systemd-devel@lists.freedesktop.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] install Fedora systemd-nspawn container on btrfs
Message-ID: <20150423144708.GB29079@gardel-login>
References: <CAK1hC9ujeQs_pv6nD6C689hMFQNjMMQdUgt7RFOz0gHjdeSz_A@mail.gmail.com>
 <20150423115056.GA28566@gardel-login>
 <CAK1hC9unKak9ffbwJthki38te5PDB+28iJTN10++gRGLZpfoiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAK1hC9unKak9ffbwJthki38te5PDB+28iJTN10++gRGLZpfoiA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 23.04.15 14:18, arnaud gaboury (arnaud.gaboury@gmail.com) wrote:

> > Pick one:
> >
> > a) download the raw image and use that, but it will be a loopback file
> > with its own file system inside
> >
> > or:
> >
> > b) do the dnf/yum install root thing, and install it into a directory
> > tree.
> 
> I installed yum package on Arch but couldn't manage to do the install.
> 
> # yum -y --releasever=22 --nogpg --installroot=/var/lib/machines/enl
> --disablerepo='*' --enablerepo=fedora install systemd passwd dnf
> fedora-release-server
> Error getting repository data for fedora, repository not found
> # yum repolist all
> repolist: 0
> 
> In fact, /etc/yum/repos.d is empty, so I am not surprised.

Of course, you could use the .raw image, mount the extern btrfs volume
into it via nspawn's --bind= switch, then use yum inside of that
container to install into the btrfs volume. Then get rid of the .raw
image again, and you still have the btrfs volume that should be
bootable.

A bit complex, but you almost were there already... ;-)

Lennart

-- 
Lennart Poettering, Red Hat
