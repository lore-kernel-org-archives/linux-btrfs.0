Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:43064 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab2FMOdY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 10:33:24 -0400
Date: Wed, 13 Jun 2012 10:33:21 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: ceph-on-btrfs inline-cow regression fix for 3.4.3
Message-ID: <20120613143320.GA374@shiny>
References: <orvcivvppp.fsf@livre.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <orvcivvppp.fsf@livre.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 12, 2012 at 09:46:26PM -0600, Alexandre Oliva wrote:
> Hi, Greg,
> 
> There's a btrfs regression in 3.4 that's causing a lot of grief to
> ceph-on-btrfs users like myself.  This small and nice patch cures it.
> It's in Linus' master already.  I've been running it on top of 3.4.2,
> and it would be very convenient for me if this could be in 3.4.3.

Ack, this can definitely to go 3.4-stable.  Thanks Alexandre.

-chris
