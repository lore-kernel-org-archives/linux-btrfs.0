Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:56497 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbaDPLZI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 07:25:08 -0400
Received: by mail-lb0-f173.google.com with SMTP id p9so7943807lbv.18
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 04:25:07 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140416110916.GA10386@infradead.org>
References: <1396392799-9858-1-git-send-email-fdmanana@gmail.com>
	<1468801.p0fTO3mgjp@localhost.localdomain>
	<CAL3q7H68Z+6=oHUFMuHpkPET+Q-U23F_0W7rWEa7vXsGX_QgAg@mail.gmail.com>
	<20140416110916.GA10386@infradead.org>
Date: Wed, 16 Apr 2014 12:25:07 +0100
Message-ID: <CAL3q7H5zO8nVrXRcdMwAa-6MDG_RFxUdWHpMV7MrY03Bvet3+A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: implement inode_operations callback tmpfile
From: Filipe David Manana <fdmanana@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linuxpatches@star.c10r.facebook.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 16, 2014 at 12:09 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Apr 16, 2014 at 11:36:23AM +0100, Filipe David Manana wrote:
>> The xattr is needed for the case where an acl is inherited. And 5
>> units are required for orphan insertion (see comment on top of
>> btrfs_orphan_add).
>> I'll update the comment.
>
> I don't think think a tmpfile should inherit any ACL, as it does not
> have a parent.  Anyway, we're currently having a discussion on that on
> various lists including linux-fsdevel.

Interesting Christoph.
I was following the ext4 implementation initially.

So it seems the question is still open, and none of the following
alternatives is decided yet (unless I missed something in the thread
at fsdevel):

1) inherit acl from directory passed to the tmpfile handler;
2) inherit acl at link time from directory we're linking to;
3) don't inherit acls

Thanks for the heads up.

>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
