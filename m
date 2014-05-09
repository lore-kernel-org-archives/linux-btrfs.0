Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756791AbaEIQwX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 12:52:23 -0400
Date: Fri, 9 May 2014 18:52:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: Juan Orti Alcaine <juan.orti@miceliux.com>, linux-btrfs@vger.kernel.org
Subject: Re: File capabilities are lost when sending/receiving a btrfs
 subvolume
Message-ID: <20140509165222.GB6039@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <2199169.56ItP7JcO9@xenon.miceliux.com>
 <3DF68968-CAEC-483B-9217-0464520404BF@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3DF68968-CAEC-483B-9217-0464520404BF@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 30, 2014 at 10:00:29AM -0600, Chris Murphy wrote:
> 
> On Apr 29, 2014, at 1:21 PM, Juan Orti Alcaine <juan.orti@miceliux.com> wrote:
> 
> > Hello, I noticed that file capabilites are lost on received subvolumes, so I 
> > opened the bug report #68891 [1]. I don't know if other xattrs are affected by 
> > this problem.
> 
> I can reproduce the reported problem with kernel 3.15rc3 and
> btrfs-progs 3.14. I don't know if these xattr are being dropped by the
> send (kernel), or the receive (progs). SELinux labels are preserved,
> so those xattr aren't affected by this problem.

The bug is between progs and kernel on the receive side. The capability
xattrs are sent correctly but not applied for some reason.
