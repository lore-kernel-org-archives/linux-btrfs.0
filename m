Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:19163 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932155AbcI1OAA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Sep 2016 10:00:00 -0400
Subject: Re: BTRFS: space_info 4 has 18446742286429913088 free, is not full
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1c94f3b1-b238-6668-7976-c0594f170dfe@profihost.ag>
 <57EBAAF5.10509@cn.fujitsu.com> <57EBBBE1.8000309@applied-asynchrony.com>
 <38866575-422f-0d2d-b76c-a1d4b1018cfd@profihost.ag>
 <57EBC950.6040205@applied-asynchrony.com>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <74141633-1874-cf1e-207b-7c2508ca4ecf@profihost.ag>
Date: Wed, 28 Sep 2016 15:59:56 +0200
MIME-Version: 1.0
In-Reply-To: <57EBC950.6040205@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 28.09.2016 um 15:44 schrieb Holger Hoffstätte:

>> Good idea but it does not. I hope i can reproduce this with my already
>> existing testscript which i've now bumped to use a 37TB partition and
>> big files rather than a 15GB part and small files. If i can reproduce it
>> i can also check whether disabling compression fixes this.
> 
> Great. Remember to undo the compression on existing files, or create
> them from scratch.

I create files from scratch - but currently i can't trigger the problem
with my testscript. But even in production load it's not that easy. I
need to process 60-120 files before the error is triggered.

>> No that's not the case. No rsync nor inplace is involved. I'm dumping
>> differences directly from ceph and put them on top of a base image but
>> only for 7 days. So it's not endless fragmenting the file. After 7 days
>> a clean whole image is dumped.
> 
> That sounds sane but it's also not at all how you described things to me
> previosuly ;) But OK.
I'm sorry. May be my english is just bad, you got me wrong or was drunk
*joke*. It never changed.

> How do you "dump differences directly from
> Ceph"? I'd assume the VM images are RBDs, but it sounds you're somehow
> using overlayfs.

You can use rbd diff to export differences between two snapshots. So no
overlayfs involved.

> Anyway..something is off and you successfully cause it while other
> people apparently do not.
Sure - i know that. But i still don't want to switch to zfs.

> Do you still use those nonstandard mount
> options with extremely long transaction flush times?
No i removed commit=300 just to be sure they do not cause this issue.

Sure,
Stefan
