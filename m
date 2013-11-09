Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:37021 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3KISKf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Nov 2013 13:10:35 -0500
Received: from [192.168.1.27] (151.24.76.25) by outrelay08.libero.it (8.6.033) (authenticated as kreijack@inwind.it)
        id 5275D05E01578FA2 for linux-btrfs@vger.kernel.org; Sat, 9 Nov 2013 19:10:33 +0100
Message-ID: <527E7A99.2070207@inwind.it>
Date: Sat, 09 Nov 2013 19:10:33 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@libero.it
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs subvolume list: what is the meaning of "top level"
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

in "btrfs subvolume list" I supposed that "top level" is the subvolume
"father" tree id. But the example below shows that I am wrong.


ghigo@venice:/tmp$ uname -a
Linux venice 3.11.7 #142 SMP Wed Nov 6 19:25:46 CET 2013 x86_64 GNU/Linux
ghigo@venice:/tmp$ sudo mkfs.btrfs /dev/loop0

WARNING! - Btrfs v0.20-rc1 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

SMALL VOLUME: forcing mixed metadata/data groups
Created a data/metadata chunk of size 8388608
fs created label (null) on /dev/loop0
	nodesize 4096 leafsize 4096 sectorsize 4096 size 1001.00MB
Btrfs v0.20-rc1
ghigo@venice:/tmp$ sudo mount /dev/loop0 t/
ghigo@venice:/tmp$ sudo mkdir t/dir
ghigo@venice:/tmp$ sudo btrfs sub create t/sub1
Create subvolume 't/sub1'
ghigo@venice:/tmp$ sudo btrfs sub create t/dir/sub2
Create subvolume 't/dir/sub2'
ghigo@venice:/tmp$ sudo btrfs sub create t/dir/sub3
Create subvolume 't/dir/sub3'
ghigo@venice:/tmp$ sudo btrfs sub create t/dir/sub3/sub4
Create subvolume 't/dir/sub3/sub4'
ghigo@venice:/tmp$ sudo btrfs sub create t/sub5
Create subvolume 't/sub5'
ghigo@venice:/tmp$ sudo btrfs sub create t/sub5/sub6
Create subvolume 't/sub5/sub6'
ghigo@venice:/tmp$ sudo btrfs sub list t/ | nl
     1	ID 256 gen 5 top level 5 path sub1
     2	ID 257 gen 6 top level 5 path dir/sub2
     3	ID 258 gen 8 top level 5 path dir/sub3
     4	ID 259 gen 8 top level 5 path dir/sub3/sub4
     5	ID 260 gen 10 top level 5 path sub5
     6	ID 261 gen 10 top level 5 path sub5/sub6


I expected that in the line 4, the top level should be 258; the same for
the line 6: top level should be 260. So my question is: what is the
meaning of the "top level" value ?

Thanks.

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
