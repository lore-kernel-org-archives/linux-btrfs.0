Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19976 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbaDNRIs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 13:08:48 -0400
Date: Mon, 14 Apr 2014 20:08:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: dsterba@suse.cz, Chris Mason <clm@fb.com>, harald@redhat.com,
        linux-btrfs@vger.kernel.org, christophjaeger@linux.com
Subject: Re: btrfs: allow mounting btrfs subvolumes with different ro/rw
 options
Message-ID: <20140414170831.GU4963@mwanda>
References: <20140414131010.GA12764@mwanda>
 <534BE4F6.9050300@fb.com>
 <20140414161705.GN29256@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140414161705.GN29256@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 14, 2014 at 06:17:05PM +0200, David Sterba wrote:
> On Mon, Apr 14, 2014 at 09:39:02AM -0400, Chris Mason wrote:
> > 
> > 
> > On 04/14/2014 09:10 AM, Dan Carpenter wrote:
> > >Hello Harald Hoyer,
> > >
> > >The patch 0723a0473fb4: "btrfs: allow mounting btrfs subvolumes with
> > >different ro/rw options" from Nov 19, 2013, leads to the following
> > >static checker warning:
> > 
> > I'll fix this one up.  Harald's email has changed and I should have pulled
> > the patch in long ago.
> 
> There are now 2 reports for that and 1 patch,
> https://patchwork.kernel.org/patch/3972911/

It was different static checkers though.  Duplicate warnings are
unavoidable in this situation.

regards,
dan carpenter

