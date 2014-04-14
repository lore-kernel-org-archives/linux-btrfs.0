Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbaDNQRH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 12:17:07 -0400
Date: Mon, 14 Apr 2014 18:17:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, harald@redhat.com,
        linux-btrfs@vger.kernel.org, christophjaeger@linux.com
Subject: Re: btrfs: allow mounting btrfs subvolumes with different ro/rw
 options
Message-ID: <20140414161705.GN29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140414131010.GA12764@mwanda>
 <534BE4F6.9050300@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <534BE4F6.9050300@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 14, 2014 at 09:39:02AM -0400, Chris Mason wrote:
> 
> 
> On 04/14/2014 09:10 AM, Dan Carpenter wrote:
> >Hello Harald Hoyer,
> >
> >The patch 0723a0473fb4: "btrfs: allow mounting btrfs subvolumes with
> >different ro/rw options" from Nov 19, 2013, leads to the following
> >static checker warning:
> 
> I'll fix this one up.  Harald's email has changed and I should have pulled
> the patch in long ago.

There are now 2 reports for that and 1 patch,
https://patchwork.kernel.org/patch/3972911/
