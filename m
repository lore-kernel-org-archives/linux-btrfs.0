Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbbCMWWQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 18:22:16 -0400
Date: Fri, 13 Mar 2015 23:22:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: fix comp_oper to get right order
Message-ID: <20150313222214.GM20767@suse.cz>
Reply-To: dsterba@suse.cz
References: <1426227878-29928-1-git-send-email-bo.li.liu@oracle.com>
 <20150313123734.GI20767@twin.jikos.cz>
 <CAL3q7H5tFUuWpM98gh=b_NN0F3vZ_69R8Ep1u26Dr7pD2dUBiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5tFUuWpM98gh=b_NN0F3vZ_69R8Ep1u26Dr7pD2dUBiQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 13, 2015 at 06:27:31PM +0000, Filipe David Manana wrote:
> > and should go to stable@ if not to 4.1-rc as it's a bug in the core of
> > qgroups. Waiting for the next merge window would not buy us anything.
> 
> Well, unless I missed something, it doesn't seem to cause any real
> harm as the only other search operation on the rbtree uses
> comp_oper_exist(), which totally ignores the seq field.
> 
> Of course it should be fixed anyway as it's logic error likely due to
> copy-paste, but unlikely to fix any real user visible problem.

Thanks for checking.
