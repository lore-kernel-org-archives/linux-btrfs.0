Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:52983 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751120AbdJBSrF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Oct 2017 14:47:05 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH v3 07/14] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20170918072139.6300-8-quwenruo.btrfs@gmx.com>
 <7cec48bd-c007-618f-b361-d4425c757c5c@oracle.com>
 <trinity-eef9a61f-60ab-47a3-9771-d638cb0083c9-1506076766926@3c-app-mailcom-bs16>
 <9f598cb9-0267-158d-c54b-13f4372eadd5@gmail.com>
 <9652f4f4-b91c-0382-fa2a-01d45dde7fbb@gmx.com>
 <5e079410-cd64-3d40-8914-b3d48ecdebfd@gmail.com>
 <808d11d8-f22b-f26e-ba3f-7d148915db5a@gmx.com>
 <5b26f9dd-8bae-a35a-4920-4a617b52f9f7@oracle.com>
 <c0652f30-5ca7-b917-7f15-78dfdb2e1205@libero.it>
 <7af34399-f969-dfe5-d006-3e7fb293b9df@gmail.com>
 <20170927162032.GM31640@twin.jikos.cz>
 <287aaa56-f2a2-d44c-1068-ec6f87b7a2f3@gmx.com>
 <cdd1e7c5-80c1-cd41-0e62-a1302c6682c5@inwind.it>
 <ffe46217-1112-8a3c-649b-c66d823527b1@gmx.com>
 <61a2d5e6-d382-1620-d82d-34b29d712813@gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <50850fbe-62d7-7c24-214f-645ffdef4822@inwind.it>
Date: Mon, 2 Oct 2017 20:47:01 +0200
MIME-Version: 1.0
In-Reply-To: <61a2d5e6-d382-1620-d82d-34b29d712813@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/02/2017 01:47 PM, Austin S. Hemmelgarn wrote:
>>>
>>> What about doing it on a file instead of a device ? As sparse file, it would be less expensive to enlarge then shrink. I think that who need to build a filesystem with "shrink", doesn't need to create it on a real block device
>>
>> For device, nothing different, just v3 patchset will handle it.
> Agreed on this point.
>>
>> For file, sparse file of course.
> But not on this one.  Unless the image gets properly compacted, a sparse file will only help when you're just storing the image on a filesystem.

I think that you have misunderstood my proposal... My suggestion is to create the image using a file, and after image creation compact it, and then cut it at the end. So you don't have to care about the space needing during the process (before the shrinking).

Today mkfs.btrfs fails to create an image on an empty file

ghigo@venice:/tmp$ mkdir test
ghigo@venice:/tmp$ mkdir test/test1
ghigo@venice:/tmp$ touch test/test1/file
ghigo@venice:/tmp$ mkfs.btrfs --root test disk.img
btrfs-progs v4.12
See http://btrfs.wiki.kernel.org for more information.

ERROR: failed to check size for disk.img: No such file or directory
ghigo@venice:/tmp$ touch disk.img
ghigo@venice:/tmp$ mkfs.btrfs --root test disk.img
btrfs-progs v4.12
See http://btrfs.wiki.kernel.org for more information.

ERROR: 'disk.img' is too small to make a usable filesystem
ERROR: minimum size for each btrfs device is 41943040

you have to create a big enough

ghigo@venice:/tmp$ truncate -s 10G disk.img 
ghigo@venice:/tmp$ mkfs.btrfs --root test disk.img
btrfs-progs v4.12
See http://btrfs.wiki.kernel.org for more information.
[...]


BR
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
