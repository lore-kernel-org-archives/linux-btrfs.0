Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpoutz25.laposte.net ([194.117.213.100]:43638 "EHLO
        smtp.laposte.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750938AbdITTHG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 15:07:06 -0400
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout013 (Postfix) with ESMTP id B6914104FB2
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 21:07:03 +0200 (CEST)
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout013 (Postfix) with ESMTP id A8D93104FC1
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 21:07:03 +0200 (CEST)
Received: from lpn-prd-vrin002 (lpn-prd-vrin002.prosodie [10.128.63.3])
        by lpn-prd-vrout013 (Postfix) with ESMTP id A3CE1104FB2
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 21:07:03 +0200 (CEST)
Received: from lpn-prd-vrin002 (localhost [127.0.0.1])
        by lpn-prd-vrin002 (Postfix) with ESMTP id 9443B5C3678
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 21:07:03 +0200 (CEST)
References: <5d7494af-0d18-8663-57a5-3007252fa0e3@gmail.com>
Subject: Re: difference between -c and -p for send-receive?
From: Antoine Belvire <antoine.belvire@laposte.net>
In-Reply-To: <5d7494af-0d18-8663-57a5-3007252fa0e3@gmail.com>
To: linux-btrfs@vger.kernel.org, arvidjaar@gmail.com
Message-ID: <e664b01f-0628-ed2b-4fd4-c93012239af3@laposte.net>
Date: Wed, 20 Sep 2017 21:05:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

 > All snapshots listed in -c options and snapshot that we want to
 > transfer must have the same parent uuid, unless -p is explicitly
 > provided.

It's rather the same mount point than the same parent uuid, like cp 
--reflink, isn't it?

~# btrfs subvolume create /test2/
Create subvolume '//test2'
~# btrfs subvolume create /test2/foo
Create subvolume '/test2/foo'
~# cd /test2	
~# btrfs subvolume snapshot -r . .1
Create a readonly snapshot of '.' in './.1'
~#
~# # a: 40 MiB in /test2/
~# dd if=/dev/urandom of=a bs=4k count=10k
10240+0 records in
10240+0 records out
41943040 bytes (42 MB, 40 MiB) copied, 0.198961 s, 211 MB/s
~#
~# # b: 80 MiB in /test2/foo
~# dd if=/dev/urandom of=foo/b bs=4k count=20k
0480+0 records in
20480+0 records out
83886080 bytes (84 MB, 80 MiB) copied, 0.393823 s, 213 MB/s
~#
~# # copy-clone /test2/foo/b to /test2/b
~# cp --reflink foo/b .
~#
~# btrfs subvolume -s . .2
Create a readonly snapshot of '.' in './.2'
~#
~# # Sending .2 with only .1 as parent (.1 already sent)
~# btrfs send -p .1 .2 | wc -c
At subvol .2
125909258 # 120 Mio = 'a' + 'b'
~#
~# # Sending .2 with .1 and foo as clone sources (.1 and foo already
~# # sent), .1 is automatically picked as parent
~# btrfs property set foo ro true
~# btrfs send -c .1 -c foo .2 | wc -c
At subvol .2
41970349 # 40 Mio, only 'a'
~#

UUIDs on the sending side:

~# btrfs subvolume list -uq / | grep test2
ID 6141 gen 454658 top level 6049 parent_uuid - uuid 
bbf936dd-ca84-f749-9b9b-09f7081879a2 path test2
ID 6142 gen 454658 top level 6141 parent_uuid - uuid 
54a7cdea-6198-424a-9349-8116172d0c17 path test2/foo
ID 6143 gen 454655 top level 6141 parent_uuid 
bbf936dd-ca84-f749-9b9b-09f7081879a2 uuid 
28f1d7db-7341-f545-a2ac-d8819d22a5b5 path test2/.1
ID 6144 gen 454658 top level 6141 parent_uuid 
bbf936dd-ca84-f749-9b9b-09f7081879a2 uuid 
db9ad2b1-aee1-544c-b368-d698b4a05119 path test2/.2
~#

On the receiving side, .1 is used as parent:

~# btrfs subvolume list -uq /var/run/media/antoine/backups/ | grep dest
ID 298 gen 443 top level 5 parent_uuid - uuid 
7695cba7-dfbf-2f44-bd79-18c9820fdb2f path dest/.1
ID 299 gen 443 top level 5 parent_uuid - uuid 
c32c06ec-0a17-cf42-9b04-3804ad72f836 path dest/foo
ID 300 gen 446 top level 5 parent_uuid 
7695cba7-dfbf-2f44-bd79-18c9820fdb2f uuid 
552b1d51-38bf-d546-a47f-4bc667ec4128 path dest/.2
~#

Regards,

--
Antoine
