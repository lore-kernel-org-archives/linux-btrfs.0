Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757774AbaHZLIo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 07:08:44 -0400
Date: Tue, 26 Aug 2014 13:08:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] btrfs-progs: remove full /dev scanning
Message-ID: <20140826110842.GP29981@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53F51F4D.2090203@redhat.com>
 <53F5B18B.1030801@oracle.com>
 <53F60264.5090401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53F60264.5090401@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 21, 2014 at 09:29:56AM -0500, Eric Sandeen wrote:
> On 8/21/14, 3:44 AM, Anand Jain wrote:
> > 
> > 
> >  A long time back there was an attempt to remove it but
> >  this avoided it. Pls ref to the link in this discussion.
> > 
> >  https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg27272.html
> 
> Hm, I guess I don't understand this.  How is udev related to whether
> or not /proc/partitions is sufficient vs. recursive /dev?

The argument about udev is probably invalid, /proc/filesystem is
populated by kernel afaics.

> To be clear, my patchset keeps the -d / --all-devices option.
> 
> It simply discovers all devices via /proc/partitions, not via
> a full /dev tree walk.

I'm fine with that.
