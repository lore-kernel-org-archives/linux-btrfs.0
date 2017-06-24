Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48328 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754525AbdFXCea (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Jun 2017 22:34:30 -0400
Date: Fri, 23 Jun 2017 19:34:09 -0700
From: Marc MERLIN <marc@merlins.org>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How to fix errors that check --mode lomem finds, but --mode normal doesn't?
Message-ID: <20170624023409.GT14690@merlins.org>
References: <20170620231202.GB5303@merlins.org> <CAJCQCtQMWKJwWjeM4zEb-W7-tjsZyfCo37YyT2xYi0fNTEzcUQ@mail.gmail.com> <20170621034352.GE5303@merlins.org> <20170621151339.GK5303@merlins.org> <13856431-9ee5-c13e-f2a8-860394f9aae4@cn.fujitsu.com> <20170622025330.GX5303@merlins.org> <e86db7c4-4953-7706-347d-983079177f37@cn.fujitsu.com> <20170623040601.akpyyvh3dgry6nn5@merlins.org> <90711a7c-92ff-e043-6d81-6bdadbfdbc3a@cn.fujitsu.com> <20170623161750.r7utffpsmyl5tcik@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170623161750.r7utffpsmyl5tcik@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 23, 2017 at 09:17:50AM -0700, Marc MERLIN wrote:
> Thanks for looking at this.
> I have applied your patch and I'm still re-running check in lowmem. It takes about 24H so I'll
> post the full results when it's done.

Ok, here is the output of the check with btrfs-progs freshly synced from
git, including Lu's just added patch.

Obviously while I'm happy to give further debug info on why my filesystem is in that state and
while check --repair sees nothing to repair, suggestions on how to clean those warnings up, unless they are not going to affect filesystem operation, would be greatly appreciated :)

Thanks,
Marc


Checking filesystem on /dev/mapper/dshelf2
UUID: 85441c59-ad11-4b25-b1fe-974f9e4acede
ERROR: extent[3886187384832, 81920] referencer count mismatch (root: 11930, owner: 375444, offset: 1851654144) wanted: 1, have: 4
ERROR: extent[3886189391872, 122880] referencer count mismatch (root: 11712, owner: 863395, offset: 79659008) wanted: 1, have: 2
ERROR: extent[3886189391872, 122880] referencer count mismatch (root: 11494, owner: 863395, offset: 79659008) wanted: 1, have: 2
ERROR: extent[3886189391872, 122880] referencer count mismatch (root: 11930, owner: 863395, offset: 79659008) wanted: 1, have: 2
ERROR: extent[3933249708032, 69632] referencer count mismatch (root: 12424, owner: 6945, offset: 2083389440) wanted: 1, have: 2
ERROR: extent[3933249708032, 69632] referencer count mismatch (root: 12172, owner: 6945, offset: 2083389440) wanted: 1, have: 2
ERROR: extent[4571729862656, 876544] referencer count mismatch (root: 11058, owner: 375442, offset: 907706368) wanted: 6, have: 21
ERROR: extent[4641490833408, 270336] referencer count mismatch (root: 11712, owner: 375444, offset: 1848672256) wanted: 3, have: 5
ERROR: extent[4641490833408, 270336] referencer count mismatch (root: 11276, owner: 375444, offset: 1848672256) wanted: 3, have: 5
ERROR: extent[4641490833408, 270336] referencer count mismatch (root: 11058, owner: 375444, offset: 1848672256) wanted: 3, have: 5
ERROR: extent[4641490833408, 270336] referencer count mismatch (root: 11494, owner: 375444, offset: 1848672256) wanted: 3, have: 5
ERROR: extent[4658555617280, 122880] referencer count mismatch (root: 11712, owner: 375444, offset: 1848705024) wanted: 1, have: 3
ERROR: extent[4658555617280, 122880] referencer count mismatch (root: 11276, owner: 375444, offset: 1848705024) wanted: 1, have: 3
ERROR: extent[4658555617280, 122880] referencer count mismatch (root: 11058, owner: 375444, offset: 1848705024) wanted: 1, have: 3
ERROR: extent[4658555617280, 122880] referencer count mismatch (root: 11494, owner: 375444, offset: 1848705024) wanted: 1, have: 3
ERROR: extent[4677858123776, 417792] referencer count mismatch (root: 11712, owner: 863395, offset: 79523840) wanted: 1, have: 3
ERROR: extent[4677858123776, 417792] referencer count mismatch (root: 11494, owner: 863395, offset: 79523840) wanted: 1, have: 3
ERROR: extent[4677858123776, 417792] referencer count mismatch (root: 11930, owner: 863395, offset: 79523840) wanted: 1, have: 3
ERROR: extent[4698380947456, 409600] referencer count mismatch (root: 11930, owner: 375444, offset: 1851596800) wanted: 3, have: 4
ERROR: extent[4720470421504, 667648] referencer count mismatch (root: 11058, owner: 3463478, offset: 2334720) wanted: 2, have: 10
ERROR: extent[4783941246976, 65536] referencer count mismatch (root: 9365, owner: 24493, offset: 4562944) wanted: 2, have: 3
ERROR: extent[5077564477440, 106496] referencer count mismatch (root: 9370, owner: 1602694, offset: 734756864) wanted: 1, have: 2
ERROR: extent[5136306929664, 131489792] referencer count mismatch (root: 11712, owner: 375441, offset: 910999552) wanted: 16, have: 1864
ERROR: extent[5136306929664, 131489792] referencer count mismatch (root: 11276, owner: 375441, offset: 910999552) wanted: 867, have: 1865
ERROR: extent[5136306929664, 131489792] referencer count mismatch (root: 11058, owner: 375441, offset: 910999552) wanted: 126, have: 1872
ERROR: extent[5136306929664, 131489792] referencer count mismatch (root: 11494, owner: 375441, offset: 910999552) wanted: 866, have: 1864
ERROR: extent[5136306929664, 131489792] referencer count mismatch (root: 11930, owner: 375441, offset: 910999552) wanted: 861, have: 1859
ERROR: extent[5136649891840, 66781184] referencer count mismatch (root: 11058, owner: 375442, offset: 192659456) wanted: 5, have: 19
ERROR: extent[5136879157248, 134217728] referencer count mismatch (root: 11930, owner: 375442, offset: 394543104) wanted: 10, have: 33
ERROR: extent[5137380671488, 80945152] referencer count mismatch (root: 11058, owner: 375442, offset: 875233280) wanted: 1, have: 21
ERROR: extent[5137380671488, 80945152] referencer count mismatch (root: 11930, owner: 375442, offset: 875233280) wanted: 11, have: 21
ERROR: extent[5138641395712, 524288] referencer count mismatch (root: 11494, owner: 375445, offset: 39845888) wanted: 1, have: 3
ERROR: extent[5190245990400, 53248] referencer count mismatch (root: 11712, owner: 863395, offset: 51118080) wanted: 1, have: 4
ERROR: extent[5190245990400, 53248] referencer count mismatch (root: 11276, owner: 863395, offset: 51118080) wanted: 1, have: 4
ERROR: extent[5190245990400, 53248] referencer count mismatch (root: 11494, owner: 863395, offset: 51118080) wanted: 1, have: 4
ERROR: extent[5190274174976, 77824] referencer count mismatch (root: 11276, owner: 863395, offset: 74952704) wanted: 3, have: 5
ERROR: extent[5190274174976, 77824] referencer count mismatch (root: 11058, owner: 863395, offset: 74952704) wanted: 3, have: 5
ERROR: extent[5190274174976, 77824] referencer count mismatch (root: 11494, owner: 863395, offset: 74952704) wanted: 3, have: 5
ERROR: extent[5190274174976, 77824] referencer count mismatch (root: 11930, owner: 863395, offset: 74952704) wanted: 3, have: 5
ERROR: extent[5190275895296, 77824] referencer count mismatch (root: 11712, owner: 863395, offset: 77705216) wanted: 1, have: 6
ERROR: extent[5190275895296, 77824] referencer count mismatch (root: 11276, owner: 863395, offset: 77705216) wanted: 5, have: 6
ERROR: extent[5190275895296, 77824] referencer count mismatch (root: 11058, owner: 863395, offset: 77705216) wanted: 5, have: 6
ERROR: extent[5427326599168, 61440] referencer count mismatch (root: 9370, owner: 1225712, offset: 29753344) wanted: 1, have: 5
ERROR: extent[5456623030272, 24576] referencer count mismatch (root: 11058, owner: 2278892, offset: 786432) wanted: 2, have: 3
ERROR: extent[5851251269632, 134217728] referencer count mismatch (root: 9370, owner: 1602695, offset: 534061056) wanted: 3, have: 4
ERROR: errors found in extent allocation tree or chunk allocation
cache and super generation don't match, space cache will be invalidated
ERROR: root 3862 EXTENT_DATA[18170706 4096] interrupt
ERROR: root 3862 EXTENT_DATA[18170706 16384] interrupt
ERROR: root 3862 EXTENT_DATA[18170706 20480] interrupt
ERROR: root 3862 EXTENT_DATA[18170706 135168] interrupt
ERROR: root 3862 EXTENT_DATA[18170706 1048576] interrupt
ERROR: errors found in fs roots
found 5544779108352 bytes used, error(s) found
total csum bytes: 5344523140
total tree bytes: 71323041792
total fs tree bytes: 59288403968
total extent tree bytes: 5378260992
btree space waste bytes: 10912166856
file data blocks allocated: 7830914256896
 referenced 6244104495104

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
