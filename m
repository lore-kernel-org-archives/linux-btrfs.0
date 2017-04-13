Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36220 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755400AbdDMDku (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 23:40:50 -0400
Date: Thu, 13 Apr 2017 11:40:46 +0800
From: Eryu Guan <eguan@redhat.com>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Liu Bo <bo.li.liu@oracle.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: introduce btrfs-map-logical
Message-ID: <20170413034046.GT22845@eguan.usersys.redhat.com>
References: <1491960463-28680-1-git-send-email-bo.li.liu@oracle.com>
 <5d7f7d05-b7af-5d8d-93f6-0db2db4ade85@cn.fujitsu.com>
 <20170412123201.GG4781@twin.jikos.cz>
 <20170412125222.GI4781@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170412125222.GI4781@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 12, 2017 at 02:52:23PM +0200, David Sterba wrote:
> > > I understand that we need to do corruption so that we can test if the 
> > > repair works, but I'm not sure if the output format will change, or if 
> > > the program will get replace by "btrfs inspect-internal" group.
> > 
> > In the long-term it will be repleaced, but there's no ETA.
> 
> Possibly, if fstests maintainer agrees, we can add btrfs-map-logical to
> fstests. It's small and uses headers from libbtrfs, so this would become
> a new dependency but I believe is still bearable.

IMHO, I think the ability to poke btrfs internal really should be
provided by btrfs-progs package and maintained by btrfs community.
fstests provides some fs-independent c helpers to assist testing, but
not necessarily needs to "understand" filesystem internals.

For historical reason, building fstests requires xfsprogs development
headers, we'd better not introduce new fs-specific dependencies.

Thanks,
Eryu
