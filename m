Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:52694 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbaAGUir (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jan 2014 15:38:47 -0500
Message-ID: <52CC65C9.3090605@friedels.name>
Date: Tue, 07 Jan 2014 21:38:33 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck does not fix
References: <52C7127F.3060902@friedels.name> <6E517D5F-B921-47E7-82E7-27865077C43D@colorremedies.com> <52C87B67.1040503@friedels.name> <F9C2788F-B057-4C3F-A490-8F8A19C37F97@colorremedies.com>
In-Reply-To: <F9C2788F-B057-4C3F-A490-8F8A19C37F97@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

 >>>> I ran btrfsck on my volume with the repair option. When I re-run 
it, >>I get the same errors as before.
> It mounts without errors? So why then btrfsck/btrfs repair? What precipitated the repair?

I don't know what caused the damage, but a check revealed this:

Checking filesystem on /dev/sdb1
UUID: 989306aa-d291-4752-8477-0baf94f8c42f
checking extents

Extent back ref already exists for 2994950590464 parent 863072366592 root 0
Extent back ref already exists for 2994950836224 parent 863072366592 root 0
Extent back ref already exists for 862762737664 parent 863072366592 root 0
Extent back ref already exists for 2994950877184 parent 863072366592
[...]
Incorrect global backref count on 2995767250944 found 1 wanted 2
backpointer mismatch on [2995767250944 4096]
ref mismatch on [2995767304192 4096] extent item 1, found 2
Incorrect global backref count on 2995767304192 found 1 wanted 2
backpointer mismatch on [2995767304192 4096]
ref mismatch on [2995768258560 4096] extent item 1, found 2
Incorrect global backref count on 2995768258560 found 1 wanted 2
backpointer mismatch on [2995768258560 4096]
ref mismatch on [2995768459264 4096] extent item 1, found 2
Incorrect global backref count on 2995768459264 found 1 wanted 2
backpointer mismatch on [2995768459264 4096]
Errors found in extent allocation tree or chunk allocation

ref mismatch on [2995768459264 4096] extent item 1, found 2
Incorrect global backref count on 2995768459264 found 1 wanted 2
backpointer mismatch on [2995768459264 4096]
Errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
root 256 inode 9579 errors 100, file extent discount
root 256 inode 9580 errors 100, file extent discount
root 256 inode 14258 errors 100, file extent discount
root 256 inode 14259 errors 100, file extent discount
root 4444 inode 9579 errors 100, file extent discount
root 4444 inode 9580 errors 100, file extent discount
root 4444 inode 14258 errors 100, file extent discount
root 4444 inode 14259 errors 100, file extent discount
found 1993711951581 bytes used err is 1
total csum bytes: 4560615360
total tree bytes: 5643403264
total fs tree bytes: 139776000
total extent tree bytes: 263602176
btree space waste bytes: 504484726
file data blocks allocated: 6557032402944
  referenced 6540949323776
Btrfs v3.12

This made me run btrfsck with the repair option:


Extent back ref already exists for 2994950590464 parent 863072366592 root 0

ref mismatch on [32935936 4096] extent item 1, found 2
repair deleting extent record: key 32935936 168 4096
adding new tree backref on start 32935936 len 4096 parent 2994784206848 
root 2994784206848
Incorrect global backref count on 32935936 found 1 wanted 2
backpointer mismatch on [32935936 4096]
ref mismatch on [32997376 4096] extent item 1, found 2
repair deleting extent record: key 32997376 168 4096
adding new tree backref on start 32997376 len 4096 parent 2994824708096 
root 2994824708096
Incorrect global backref count on 32997376 found 1 wanted 2
backpointer mismatch on [32997376 4096]

Incorrect global backref count on 8988365651968 found 1 wanted 0
backpointer mismatch on [8988365651968 4096]
repaired damaged extent references
checking free space cache
checking fs roots
root 256 inode 9579 errors 100, file extent discount
root 256 inode 9580 errors 100, file extent discount
root 256 inode 14258 errors 100, file extent discount
root 256 inode 14259 errors 100, file extent discount
root 4444 inode 9579 errors 100, file extent discount
root 4444 inode 9580 errors 100, file extent discount
root 4444 inode 14258 errors 100, file extent discount
root 4444 inode 14259 errors 100, file extent discount
enabling repair mode
Checking filesystem on /dev/sdc1
UUID: 989306aa-d291-4752-8477-0baf94f8c42f
cache and super generation don't match, space cache will be invalidated
found 827360733827 bytes used err is 1
total csum bytes: 4446455380
total tree bytes: 5506977792
total fs tree bytes: 137293824
total extent tree bytes: 258691072
btree space waste bytes: 496921489
file data blocks allocated: 6440132583424
  referenced 6424163344384
Btrfs v3.12


After this, I ran a check without the repair option again and the same 
errors persist.

Greetings,
Hendrik


-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Mobil 0178 1874363
