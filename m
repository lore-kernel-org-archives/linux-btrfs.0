Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbbAPP0R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Jan 2015 10:26:17 -0500
Date: Fri, 16 Jan 2015 16:26:13 +0100
From: Karel Zak <kzak@redhat.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-prog: improve build-system by autoconf
Message-ID: <20150116152613.GC2181@x2.net.home>
References: <1418387724-20188-1-git-send-email-kzak@redhat.com>
 <20141217140726.GY27601@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141217140726.GY27601@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 17, 2014 at 03:07:26PM +0100, David Sterba wrote:
> On Fri, Dec 12, 2014 at 01:35:14PM +0100, Karel Zak wrote:
> > This is first step to make btrfs-progs build system more conventional
> > for userspace users and developers. All is implemented by small incremental
> > patches to keep things review-able.
> 
> Thanks. I went through the patches and haven't found major problems. The
> changes are affecting build system and this will need a longer period
> before all distros have a chance to adapt to that, so I'm postponing it
> to 3.19.

 Note that I have rebased the autoconf patches and fixed some issues,
 the latest version is available at

    https://github.com/karelzak/btrfs-progs/commits/autoconf

 you can merge it (now or later) on command line by:

    git pull --log git@github.com:karelzak/btrfs-progs.git autoconf


  Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
