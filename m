Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbaDCRpV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Apr 2014 13:45:21 -0400
Date: Thu, 3 Apr 2014 19:45:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: harald@redhat.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: allow mounting btrfs subvolumes with different
 ro/rw options
Message-ID: <20140403174519.GP29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1384857365-7719-1-git-send-email-harald@redhat.com>
 <20131119143532.5312.44372@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131119143532.5312.44372@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 19, 2013 at 09:35:32AM -0500, Chris Mason wrote:
> Quoting harald@redhat.com (2013-11-19 05:36:05)
> > From: Harald Hoyer <harald@redhat.com>
> > 
> [ create new vfsmounts with different states ]
> 
> Thanks for resending Harald.  I'll give this a shot and see if I can
> find any problems with it.

Is this patch queued for 3.15? Thanks.
