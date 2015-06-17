Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:36491 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbbFQVCF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 17:02:05 -0400
Date: Wed, 17 Jun 2015 23:02:02 +0200
From: Lennart Poettering <lennart@poettering.net>
To: kreijack@inwind.it
Cc: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [survey] BTRFS_IOC_DEVICES_READY return status
Message-ID: <20150617210202.GA30833@gardel-login>
References: <557ADBAE.9040407@oracle.com>
 <20150612210453.3dee4563@opensuse.site>
 <557B3C32.9030707@inwind.it>
 <557BF979.9040106@oracle.com>
 <557C479F.2070403@libero.it>
 <20150615104618.GB25616@gardel-login>
 <557F0A26.8070308@inwind.it>
 <20150615173806.GB26366@gardel-login>
 <5581C60A.6090505@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5581C60A.6090505@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 17.06.15 21:10, Goffredo Baroncelli (kreijack@libero.it) wrote:

> > Well, /bin/mount is not a daemon, and it should not be one.
> 
> My helper is not a deamon; you was correct the first time: it blocks
> until all needed/enough devices are appeared.
> Anyway this should not be different from mounting a nfs
> filesystem. Even in this case the mount helper blocks until the
> connection happened. The block time is not negligible, even tough
> not long as a device timeout ...

Well, the mount tool doesn't wait for the network to be configured or
so. It just waits for a response from the server. That's quite a
difference.

> > Well, it's not really ugly. I mean, if the state or properties of a
> > device change, then udev should update its information about it, and
> > that's done via a retrigger. We do that all the time already, for
> > example when an existing loopback device gets a backing file assigned
> > or removed. I am pretty sure that loopback case is very close to what
> > you want to do here, hence retriggering (either from the kernel side,
> > or from userspace), appears like an OK thing to do.
> 
> What seems strange to me is that in this case the devices don't have changed their status.
> How this problem is managed in the md/dm raid cases ?

md has a daemon mdmon to my knowledge.

Lennart

-- 
Lennart Poettering, Red Hat
