Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbcEPMjC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 08:39:02 -0400
Date: Mon, 16 May 2016 13:39:00 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, ptoscano@redhat.com
Subject: Re: RFE: 'btrfs' tools machine readable output
Message-ID: <20160516123859.GP1683@redhat.com>
References: <20160516121456.GA16970@redhat.com>
 <3271754.bqNJ5v1fWK@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3271754.bqNJ5v1fWK@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mon, May 16, 2016 at 02:21:07PM +0200, Martin Steigerwald wrote:
> Hello Richard,
> 
> On Montag, 16. Mai 2016 13:14:56 CEST Richard W.M. Jones wrote:
> > I don't have time to implement this right now, so I'm just posting
> > this as a suggestion/request ...
> > 
> > It would be really helpful if the btrfs tools had a machine-readable
> > output.
> > 
> > Libguestfs parses btrfs tools output in a number of places, eg:
> > https://github.com/libguestfs/libguestfs/blob/master/daemon/btrfs.c
> > This is a massive PITA because each time a new release of btrfs-progs
> > comes along it changes the output slightly, and we end up having
> > to add all sorts of hacks.
> > 
> > With machine-readable output, there'd be a flag which would
> > change the output.  eg:
> 
> I wonder whether parsing a text based output is really the most elegant method 
> here.
> 
> How about a libbtrfs so that other tools can benefit from btrfs tools 
> functionality? This was also desktop environments wishing to make use of 
> snapshot functionality or advanced disk usage reporting for example can easily 
> make use of it without calling external commands.
> 
> Of course it would likely me more effort than to implement structured output.

Yes, a similar situation happened with qemu actually.  We've been
talking for over half a decade about putting the qemu block layer into
a library, and it's still not happened.  But we got `qemu-img info' to
have JSON output in a few weeks, and that is now how we query the
properties of VM disk images:

$ qemu-img info --output=json ./builder/fedora.qcow2
{
    "virtual-size": 1073741824,
    "filename": "./builder/fedora.qcow2",
    "cluster-size": 65536,
    "format": "qcow2",
    "actual-size": 7933952,
    "format-specific": {
        "type": "qcow2",
        "data": {
            "compat": "1.1",
            "lazy-refcounts": false,
            "refcount-bits": 16,
            "corrupt": false
        }
    },
    "dirty-flag": false
}

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-builder quickly builds VMs from scratch
http://libguestfs.org/virt-builder.1.html
