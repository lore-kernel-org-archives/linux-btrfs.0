Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62490 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313AbbLBXkn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Dec 2015 18:40:43 -0500
Subject: Re: Bug/regression: Read-only mount not read-only
To: Eric Sandeen <sandeen@redhat.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Russell Coker <russell@coker.com.au>
References: <20151128134634.GF24333@carfax.org.uk>
 <20151201190018.GD8918@ret.masoncoding.com> <565DEF65.4080900@redhat.com>
 <201512021725.32750.russell@coker.com.au> <565EB480.4010509@cn.fujitsu.com>
 <565EB878.9090501@cn.fujitsu.com> <565F2260.1080004@redhat.com>
 <565F2EF7.5000109@gmail.com> <565F753B.5020000@redhat.com>
Cc: Chris Mason <clm@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <565F8158.4090304@gmx.com>
Date: Thu, 3 Dec 2015 07:40:08 +0800
MIME-Version: 1.0
In-Reply-To: <565F753B.5020000@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/03/2015 06:48 AM, Eric Sandeen wrote:
> On 12/2/15 11:48 AM, Austin S Hemmelgarn wrote:
>
>> On a side note, do either XFS or ext4 support removing the norecovery
>> option from the mount flags through mount -o remount?  Even if they
>> don't, that might be a nice feature to have in BTRFS if we can safely
>> support it.
>
> It's not remountable today on xfs:
>
>          /* ro -> rw */
>          if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & MS_RDONLY)) {
>                  if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
>                          xfs_warn(mp,
>                  "ro->rw transition prohibited on norecovery mount");
>                          return -EINVAL;
>                  }
>
> not sure about ext4.
>
> -Eric

Not remountable is very good to implement it.
Makes things super easy to do.

Or we will need to add log replay for remount time.

I'd like to implement it first for non-remountable case as a try.
And for the option name, I prefer something like "notreereplay", but I 
don't consider it the best one yet....

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
