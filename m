Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:45744 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522Ab3AXPso (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 10:48:44 -0500
Date: Thu, 24 Jan 2013 10:48:41 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>,
        Alexander Block <ablock84@googlemail.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        Chen Yang <chenyang.fnst@cn.fujitsu.com>,
        Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH 1/2] V2 Avoid sending disknr==0 extents when possible.
Message-ID: <20130124154841.GD2349@localhost.localdomain>
References: <CAOcd+r1_hiz7A98r0o1e_=60+3tN16n+HTgQs0SgMhHjGG-E7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOcd+r1_hiz7A98r0o1e_=60+3tN16n+HTgQs0SgMhHjGG-E7Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 21, 2013 at 03:27:22AM -0700, Alex Lyakas wrote:
> In the following cases we do not send disknr==0 extents:
> 1) full send 2) new inode in a diff-send 3) when disknr==0 extents are
> added to the end of an inode
> 
> Original-version-by: Chen Yang <chenyang.fnst@cn.fujitsu.com>
> Signed-off-by: Alex Lyakas <alex@zadarastorage.com>

Neither of these would apply to btrfs-next, please rebase against btrfs-next and
resend.  Thanks,

Josef
