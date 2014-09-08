Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbaIHJJt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Sep 2014 05:09:49 -0400
Date: Mon, 8 Sep 2014 11:09:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] Scan all devices to build fs device list
Message-ID: <20140908090946.GI5636@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com>
 <540B6900.7000307@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <540B6900.7000307@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 06, 2014 at 04:05:20PM -0400, Chris Mason wrote:
> On 09/03/2014 09:36 AM, Miao Xie wrote:
> > This patchset implements device list automatic building function. As we
> > know, currently we need scan the devices to build device list by a user tool
> > before mounting the filesystem, especially mount the filesystem after
> > we re-install btrfs module. It is not convenient. This patchset can improve
> > that problem. With this patchset, we will scan all the devices in the
> > system to build the device list if we find the number of the devices
> > is not right when we mount the filesystem. By this way, we needn't scan
> > the device by the user tool and reduce the mount failure probability due
> > to the incomplete device list.
> 
> Thanks for working on these patches, but I really prefer that we do
> these scans from userspace.

I agree. The userspace approach gives more control of when and how the
scanning is done. Yes the scan has to be done after the module is
inserted, but distros have that in initrd. Reinstalling module is not
something a normal user does and developers know how to workaround.

Automatic scanning in usperspace can be done via the mount helper and
this is IMO the way to go. There's a patch for that from Goffredo, not
merged yet, the patch backlog is still too long.
