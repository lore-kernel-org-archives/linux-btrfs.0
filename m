Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451Ab3BMLAi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 06:00:38 -0500
Date: Wed, 13 Feb 2013 11:00:33 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>, Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: What can I do to make btrfs work?
Message-ID: <20130213110033.GA1543@rhmail.home.annexia.org>
References: <20130212185449.GA16773@rhmail.home.annexia.org>
 <20130212191637.GD2611@localhost.localdomain>
 <20130212210535.GC16773@rhmail.home.annexia.org>
 <20130212214225.GM16687@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130212214225.GM16687@shiny.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 12, 2013 at 04:42:25PM -0500, Chris Mason wrote:
> On Tue, Feb 12, 2013 at 02:05:35PM -0700, Richard W.M. Jones wrote:
> > 
> > Yes, this is inside a very recent KVM (qemu 1.3.0), using virtio-scsi
> > as the backing disk.
> 
> Ok, can you please run this on your virtio device file?  It will
> overwrite the first 256K, so don't do this on a file you care about.
> 
> gcc -Wall -o vtest vtest.c
> 
> ./vtest /dev/xxx
> 
> I've attached vtest.c and gzip'd it just to make sure no mailers mess
> with my pretty code.

The output of this is:

writing to /dev/sda

and nothing else.  Since it seems to be intended to be an infinite
loop, I left it running for a five minutes before killing it.

Will try the btrfsprogs patch next.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top
