Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbbLBWs3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Dec 2015 17:48:29 -0500
Subject: Re: Bug/regression: Read-only mount not read-only
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Russell Coker <russell@coker.com.au>
References: <20151128134634.GF24333@carfax.org.uk>
 <20151201190018.GD8918@ret.masoncoding.com> <565DEF65.4080900@redhat.com>
 <201512021725.32750.russell@coker.com.au> <565EB480.4010509@cn.fujitsu.com>
 <565EB878.9090501@cn.fujitsu.com> <565F2260.1080004@redhat.com>
 <565F2EF7.5000109@gmail.com>
Cc: Chris Mason <clm@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <565F753B.5020000@redhat.com>
Date: Wed, 2 Dec 2015 16:48:27 -0600
MIME-Version: 1.0
In-Reply-To: <565F2EF7.5000109@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/2/15 11:48 AM, Austin S Hemmelgarn wrote:

> On a side note, do either XFS or ext4 support removing the norecovery
> option from the mount flags through mount -o remount?  Even if they
> don't, that might be a nice feature to have in BTRFS if we can safely
> support it.

It's not remountable today on xfs:

        /* ro -> rw */
        if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & MS_RDONLY)) {
                if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
                        xfs_warn(mp,
                "ro->rw transition prohibited on norecovery mount");
                        return -EINVAL;
                }

not sure about ext4.

-Eric
