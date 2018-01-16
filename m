Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46078 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750802AbeAPKtx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jan 2018 05:49:53 -0500
Date: Tue, 16 Jan 2018 11:49:50 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Subject: Re: invalid files names, btrfs check can't repair it
Message-ID: <20180116104949.7qtf67mrdvyxrvs4@breakpoint.cc>
References: <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115090049.6tcnoadsam7adsea@breakpoint.cc>
 <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
 <b926ecdb-94da-1067-ff74-7d5392a7fe46@gmx.com>
 <20180116101058.wtcdjnqldcb5q3a7@breakpoint.cc>
 <4b929845-beae-9e13-2df9-ddc3232ad39a@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4b929845-beae-9e13-2df9-ddc3232ad39a@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-16 18:22:14 [+0800], Qu Wenruo wrote:
> Btrfs check is always recommended before really mount it.

 # btrfs check -p /dev/sdb4 
 Checking filesystem on /dev/sdb4
 UUID: b3bfb56e-d445-4335-93f0-c1fb2d1f6df1
 checking extents [O]
 cache and super generation don't match, space cache will be invalidated
 root 5 inode 57648595 errors 200, dir isize wrong

 ERROR: errors found in fs roots
 found 64009740288 bytes used, error(s) found
 total csum bytes: 61644600
 total tree bytes: 865746944
 total fs tree bytes: 693469184
 total extent tree bytes: 84905984
 btree space waste bytes: 225096302
 file data blocks allocated: 63203807232
  referenced 63142268928

> However as long as there is no other problem, btrfs check should not
> report anything wrong.

Is it important to note that the filesystem is a raid1 one?

> Thanks,
> Qu

Sebastian
