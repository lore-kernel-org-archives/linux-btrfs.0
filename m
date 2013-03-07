Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab3CGO2S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Mar 2013 09:28:18 -0500
Date: Thu, 7 Mar 2013 15:28:16 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com
Subject: Warnings from xfstests/275 (3.9-rc1)
Message-ID: <20130307142816.GN21081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="98e8jtXdkpgskNou"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[resent with subject]
Hi,

I'm seeing messages like this

[ 3194.928153] btrfs allocation failed flags 1, wanted 65536
[ 3194.934874] space_info 1 has 147456 free, is full
[ 3194.941205] space_info total=1903427584, used=1903280128, pinned=0, reserved=0, may_use=65536, readonly=0
[ 3194.941209] block group 12582912 has 8388608 bytes, 8376320 used 0 pinned 0 reserved 
[ 3194.941212] entry offset 20959232, bytes 12288, bitmap no
[ 3194.941213] block group has cluster?: no
[ 3194.941215] 0 blocks of free space at or bigger than bytes is
[ 3194.941218] block group 136708096 has 218103808 bytes, 218095616 used 0 pinned 0 reserved 
[ 3194.941221] entry offset 354803712, bytes 8192, bitmap no
[ 3194.941222] block group has cluster?: no

mkfs is default, mount with noatime, happens consistently at
xfstests/275 (on first run of the whole testsuite) the test uses a 2g
scratch partition.

Has been observed for like 2 weeks when testing next/master.

The test description says

# The posix write test.  When write size is larger than disk free size,
# should write as much as possible until ENOSPC.

so enospc messages can be expected, although I don't know if they're
just debugging or point to real bugs.

Full log attached.

david

--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="enospc-3.9-275"

Mar  7 14:53:16 root: run xfstest 275
Mar  7 14:53:17 kernel: [ 3153.309687] device fsid 1cc979d6-c415-4607-bcfd-71efd34bf3ef devid 1 transid 4 /dev/sda9
Mar  7 14:53:17 kernel: [ 3153.359752] device fsid 1cc979d6-c415-4607-bcfd-71efd34bf3ef devid 1 transid 4 /dev/sda9
Mar  7 14:53:17 kernel: [ 3153.371696] btrfs: disk space caching is enabled
Mar  7 14:53:58 kernel: [ 3194.928153] btrfs allocation failed flags 1, wanted 65536
Mar  7 14:53:58 kernel: [ 3194.934874] space_info 1 has 147456 free, is full
Mar  7 14:54:02 kernel: [ 3194.941205] space_info total=1903427584, used=1903280128, pinned=0, reserved=0, may_use=65536, readonly=0
Mar  7 14:54:02 kernel: [ 3194.941209] block group 12582912 has 8388608 bytes, 8376320 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941212] entry offset 20959232, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941213] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941215] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941218] block group 136708096 has 218103808 bytes, 218095616 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941221] entry offset 354803712, bytes 8192, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941222] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941224] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941227] block group 354811904 has 218103808 bytes, 218091520 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941229] entry offset 572903424, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941230] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941232] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941235] block group 572915712 has 218103808 bytes, 218071040 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941237] entry offset 790986752, bytes 32768, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941238] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941239] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941243] block group 791019520 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941248] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941249] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941253] block group 1009123328 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941254] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941255] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941259] block group 1227227136 has 218103808 bytes, 218087424 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941261] entry offset 1445314560, bytes 16384, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941262] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941264] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941267] block group 1445330944 has 218103808 bytes, 218083328 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941269] entry offset 1663414272, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941270] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941272] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941275] block group 1663434752 has 218103808 bytes, 218079232 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941277] entry offset 1881513984, bytes 24576, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941278] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941280] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941283] block group 1881538560 has 150208512 bytes, 150188032 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941285] entry offset 2031726592, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941286] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941287] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941614] btrfs allocation failed flags 1, wanted 65536
Mar  7 14:54:02 kernel: [ 3194.941617] space_info 1 has 147456 free, is full
Mar  7 14:54:02 kernel: [ 3194.941620] space_info total=1903427584, used=1903280128, pinned=0, reserved=0, may_use=65536, readonly=0
Mar  7 14:54:02 kernel: [ 3194.941624] block group 12582912 has 8388608 bytes, 8376320 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941626] entry offset 20959232, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941628] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941629] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941632] block group 136708096 has 218103808 bytes, 218095616 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941634] entry offset 354803712, bytes 8192, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941636] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941637] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941640] block group 354811904 has 218103808 bytes, 218091520 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941642] entry offset 572903424, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941643] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941645] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941648] block group 572915712 has 218103808 bytes, 218071040 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941650] entry offset 790986752, bytes 32768, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941651] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941652] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941655] block group 791019520 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941657] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941658] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941661] block group 1009123328 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941663] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941664] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941667] block group 1227227136 has 218103808 bytes, 218087424 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941669] entry offset 1445314560, bytes 16384, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941671] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941672] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941675] block group 1445330944 has 218103808 bytes, 218083328 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941677] entry offset 1663414272, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941679] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941680] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941683] block group 1663434752 has 218103808 bytes, 218079232 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941685] entry offset 1881513984, bytes 24576, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941687] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941688] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941691] block group 1881538560 has 150208512 bytes, 150188032 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941693] entry offset 2031726592, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941695] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941696] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941841] btrfs allocation failed flags 1, wanted 65536
Mar  7 14:54:02 kernel: [ 3194.941843] space_info 1 has 147456 free, is full
Mar  7 14:54:02 kernel: [ 3194.941845] space_info total=1903427584, used=1903280128, pinned=0, reserved=0, may_use=65536, readonly=0
Mar  7 14:54:02 kernel: [ 3194.941847] block group 12582912 has 8388608 bytes, 8376320 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941848] entry offset 20959232, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941848] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941849] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941851] block group 136708096 has 218103808 bytes, 218095616 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941852] entry offset 354803712, bytes 8192, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941853] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941853] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941855] block group 354811904 has 218103808 bytes, 218091520 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941856] entry offset 572903424, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941857] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941858] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941859] block group 572915712 has 218103808 bytes, 218071040 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941860] entry offset 790986752, bytes 32768, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941861] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941862] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941863] block group 791019520 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941864] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941865] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941867] block group 1009123328 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941868] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941868] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941870] block group 1227227136 has 218103808 bytes, 218087424 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941871] entry offset 1445314560, bytes 16384, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941872] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941873] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941874] block group 1445330944 has 218103808 bytes, 218083328 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941875] entry offset 1663414272, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941876] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941877] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941879] block group 1663434752 has 218103808 bytes, 218079232 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941880] entry offset 1881513984, bytes 24576, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941880] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941881] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.941883] block group 1881538560 has 150208512 bytes, 150188032 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.941884] entry offset 2031726592, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.941885] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.941885] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942024] btrfs allocation failed flags 1, wanted 65536
Mar  7 14:54:02 kernel: [ 3194.942026] space_info 1 has 147456 free, is full
Mar  7 14:54:02 kernel: [ 3194.942027] space_info total=1903427584, used=1903280128, pinned=0, reserved=0, may_use=65536, readonly=0
Mar  7 14:54:02 kernel: [ 3194.942029] block group 12582912 has 8388608 bytes, 8376320 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942030] entry offset 20959232, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942031] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942032] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942033] block group 136708096 has 218103808 bytes, 218095616 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942034] entry offset 354803712, bytes 8192, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942035] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942036] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942038] block group 354811904 has 218103808 bytes, 218091520 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942039] entry offset 572903424, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942039] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942040] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942042] block group 572915712 has 218103808 bytes, 218071040 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942043] entry offset 790986752, bytes 32768, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942044] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942044] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942046] block group 791019520 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942047] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942048] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942049] block group 1009123328 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942050] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942051] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942052] block group 1227227136 has 218103808 bytes, 218087424 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942054] entry offset 1445314560, bytes 16384, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942054] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942055] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942057] block group 1445330944 has 218103808 bytes, 218083328 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942058] entry offset 1663414272, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942059] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942059] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942061] block group 1663434752 has 218103808 bytes, 218079232 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942062] entry offset 1881513984, bytes 24576, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942063] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942064] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942065] block group 1881538560 has 150208512 bytes, 150188032 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942066] entry offset 2031726592, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942067] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942068] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942198] btrfs allocation failed flags 1, wanted 65536
Mar  7 14:54:02 kernel: [ 3194.942200] space_info 1 has 147456 free, is full
Mar  7 14:54:02 kernel: [ 3194.942202] space_info total=1903427584, used=1903280128, pinned=0, reserved=0, may_use=65536, readonly=0
Mar  7 14:54:02 kernel: [ 3194.942204] block group 12582912 has 8388608 bytes, 8376320 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942205] entry offset 20959232, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942205] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942206] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942208] block group 136708096 has 218103808 bytes, 218095616 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942209] entry offset 354803712, bytes 8192, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942210] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942210] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942212] block group 354811904 has 218103808 bytes, 218091520 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942213] entry offset 572903424, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942214] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942215] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942216] block group 572915712 has 218103808 bytes, 218071040 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942217] entry offset 790986752, bytes 32768, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942218] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942219] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942220] block group 791019520 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942221] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942222] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942224] block group 1009123328 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942224] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942225] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942227] block group 1227227136 has 218103808 bytes, 218087424 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942228] entry offset 1445314560, bytes 16384, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942229] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942229] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942231] block group 1445330944 has 218103808 bytes, 218083328 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942232] entry offset 1663414272, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942233] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942234] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942235] block group 1663434752 has 218103808 bytes, 218079232 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942236] entry offset 1881513984, bytes 24576, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942237] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942238] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942240] block group 1881538560 has 150208512 bytes, 150188032 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942241] entry offset 2031726592, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942241] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942242] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942379] btrfs allocation failed flags 1, wanted 65536
Mar  7 14:54:02 kernel: [ 3194.942380] space_info 1 has 147456 free, is full
Mar  7 14:54:02 kernel: [ 3194.942382] space_info total=1903427584, used=1903280128, pinned=0, reserved=0, may_use=65536, readonly=0
Mar  7 14:54:02 kernel: [ 3194.942384] block group 12582912 has 8388608 bytes, 8376320 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942385] entry offset 20959232, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942386] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942386] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942388] block group 136708096 has 218103808 bytes, 218095616 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942389] entry offset 354803712, bytes 8192, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942390] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942391] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942392] block group 354811904 has 218103808 bytes, 218091520 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942393] entry offset 572903424, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942394] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942395] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942397] block group 572915712 has 218103808 bytes, 218071040 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942398] entry offset 790986752, bytes 32768, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942398] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942399] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942401] block group 791019520 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942402] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942402] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942404] block group 1009123328 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942405] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942406] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942407] block group 1227227136 has 218103808 bytes, 218087424 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942409] entry offset 1445314560, bytes 16384, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942409] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942410] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942412] block group 1445330944 has 218103808 bytes, 218083328 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942413] entry offset 1663414272, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942414] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942414] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942416] block group 1663434752 has 218103808 bytes, 218079232 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942417] entry offset 1881513984, bytes 24576, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942418] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942419] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942420] block group 1881538560 has 150208512 bytes, 150188032 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942421] entry offset 2031726592, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942422] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942423] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942554] btrfs allocation failed flags 1, wanted 65536
Mar  7 14:54:02 kernel: [ 3194.942555] space_info 1 has 147456 free, is full
Mar  7 14:54:02 kernel: [ 3194.942557] space_info total=1903427584, used=1903280128, pinned=0, reserved=0, may_use=65536, readonly=0
Mar  7 14:54:02 kernel: [ 3194.942559] block group 12582912 has 8388608 bytes, 8376320 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942560] entry offset 20959232, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942561] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942561] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942563] block group 136708096 has 218103808 bytes, 218095616 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942564] entry offset 354803712, bytes 8192, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942565] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942566] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942567] block group 354811904 has 218103808 bytes, 218091520 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942568] entry offset 572903424, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942569] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942570] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942571] block group 572915712 has 218103808 bytes, 218071040 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942573] entry offset 790986752, bytes 32768, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942573] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942574] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942576] block group 791019520 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942576] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942577] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942579] block group 1009123328 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942580] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942580] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942582] block group 1227227136 has 218103808 bytes, 218087424 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942583] entry offset 1445314560, bytes 16384, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942584] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942585] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942586] block group 1445330944 has 218103808 bytes, 218083328 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942587] entry offset 1663414272, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942588] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942589] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942591] block group 1663434752 has 218103808 bytes, 218079232 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942592] entry offset 1881513984, bytes 24576, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942592] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942593] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942595] block group 1881538560 has 150208512 bytes, 150188032 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942596] entry offset 2031726592, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942597] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942598] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942734] btrfs allocation failed flags 1, wanted 65536
Mar  7 14:54:02 kernel: [ 3194.942735] space_info 1 has 147456 free, is full
Mar  7 14:54:02 kernel: [ 3194.942737] space_info total=1903427584, used=1903280128, pinned=0, reserved=0, may_use=65536, readonly=0
Mar  7 14:54:02 kernel: [ 3194.942739] block group 12582912 has 8388608 bytes, 8376320 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942740] entry offset 20959232, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942740] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942741] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942743] block group 136708096 has 218103808 bytes, 218095616 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942744] entry offset 354803712, bytes 8192, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942745] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942745] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942747] block group 354811904 has 218103808 bytes, 218091520 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942748] entry offset 572903424, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942749] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942750] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942751] block group 572915712 has 218103808 bytes, 218071040 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942752] entry offset 790986752, bytes 32768, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942753] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942754] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942756] block group 791019520 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942756] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942757] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942759] block group 1009123328 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942760] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942760] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942762] block group 1227227136 has 218103808 bytes, 218087424 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942763] entry offset 1445314560, bytes 16384, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942764] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942765] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942766] block group 1445330944 has 218103808 bytes, 218083328 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942767] entry offset 1663414272, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942768] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942769] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942770] block group 1663434752 has 218103808 bytes, 218079232 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942772] entry offset 1881513984, bytes 24576, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942772] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942773] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942775] block group 1881538560 has 150208512 bytes, 150188032 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942776] entry offset 2031726592, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942777] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942777] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942913] btrfs allocation failed flags 1, wanted 65536
Mar  7 14:54:02 kernel: [ 3194.942914] space_info 1 has 147456 free, is full
Mar  7 14:54:02 kernel: [ 3194.942916] space_info total=1903427584, used=1903280128, pinned=0, reserved=0, may_use=65536, readonly=0
Mar  7 14:54:02 kernel: [ 3194.942918] block group 12582912 has 8388608 bytes, 8376320 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942919] entry offset 20959232, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942920] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942920] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942922] block group 136708096 has 218103808 bytes, 218095616 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942923] entry offset 354803712, bytes 8192, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942924] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942925] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942926] block group 354811904 has 218103808 bytes, 218091520 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942927] entry offset 572903424, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942928] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942929] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942931] block group 572915712 has 218103808 bytes, 218071040 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942932] entry offset 790986752, bytes 32768, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942933] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942933] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942935] block group 791019520 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942936] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942936] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942938] block group 1009123328 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942939] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942940] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942941] block group 1227227136 has 218103808 bytes, 218087424 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942942] entry offset 1445314560, bytes 16384, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942943] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942944] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942946] block group 1445330944 has 218103808 bytes, 218083328 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942947] entry offset 1663414272, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942947] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942948] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942950] block group 1663434752 has 218103808 bytes, 218079232 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942951] entry offset 1881513984, bytes 24576, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942952] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942952] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.942954] block group 1881538560 has 150208512 bytes, 150188032 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.942955] entry offset 2031726592, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.942956] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.942957] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943030] btrfs allocation failed flags 1, wanted 65536
Mar  7 14:54:02 kernel: [ 3194.943031] space_info 1 has 147456 free, is full
Mar  7 14:54:02 kernel: [ 3194.943033] space_info total=1903427584, used=1903280128, pinned=0, reserved=0, may_use=65536, readonly=0
Mar  7 14:54:02 kernel: [ 3194.943035] block group 12582912 has 8388608 bytes, 8376320 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943036] entry offset 20959232, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943036] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943037] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943039] block group 136708096 has 218103808 bytes, 218095616 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943040] entry offset 354803712, bytes 8192, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943041] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943041] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943043] block group 354811904 has 218103808 bytes, 218091520 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943044] entry offset 572903424, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943045] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943046] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943047] block group 572915712 has 218103808 bytes, 218071040 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943048] entry offset 790986752, bytes 32768, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943049] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943050] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943051] block group 791019520 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943052] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943053] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943055] block group 1009123328 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943055] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943056] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943058] block group 1227227136 has 218103808 bytes, 218087424 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943059] entry offset 1445314560, bytes 16384, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943060] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943060] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943062] block group 1445330944 has 218103808 bytes, 218083328 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943063] entry offset 1663414272, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943064] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943065] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943067] block group 1663434752 has 218103808 bytes, 218079232 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943068] entry offset 1881513984, bytes 24576, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943068] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943069] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943071] block group 1881538560 has 150208512 bytes, 150188032 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943072] entry offset 2031726592, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943073] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943073] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943304] btrfs allocation failed flags 1, wanted 65536
Mar  7 14:54:02 kernel: [ 3194.943306] space_info 1 has 147456 free, is full
Mar  7 14:54:02 kernel: [ 3194.943308] space_info total=1903427584, used=1902690304, pinned=589824, reserved=0, may_use=65536, readonly=0
Mar  7 14:54:02 kernel: [ 3194.943310] block group 12582912 has 8388608 bytes, 7786496 used 589824 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943311] entry offset 20959232, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943312] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943312] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943314] block group 136708096 has 218103808 bytes, 218095616 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943315] entry offset 354803712, bytes 8192, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943316] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943317] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943318] block group 354811904 has 218103808 bytes, 218091520 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943319] entry offset 572903424, bytes 12288, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943320] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943321] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943322] block group 572915712 has 218103808 bytes, 218071040 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943323] entry offset 790986752, bytes 32768, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943324] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943325] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943327] block group 791019520 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943327] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943328] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943330] block group 1009123328 has 218103808 bytes, 218103808 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943331] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943331] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943333] block group 1227227136 has 218103808 bytes, 218087424 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943334] entry offset 1445314560, bytes 16384, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943335] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943336] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943337] block group 1445330944 has 218103808 bytes, 218083328 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943338] entry offset 1663414272, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943339] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943340] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943342] block group 1663434752 has 218103808 bytes, 218079232 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943343] entry offset 1881513984, bytes 24576, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943343] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943344] 0 blocks of free space at or bigger than bytes is
Mar  7 14:54:02 kernel: [ 3194.943346] block group 1881538560 has 150208512 bytes, 150188032 used 0 pinned 0 reserved 
Mar  7 14:54:02 kernel: [ 3194.943347] entry offset 2031726592, bytes 20480, bitmap no
Mar  7 14:54:02 kernel: [ 3194.943348] block group has cluster?: no
Mar  7 14:54:02 kernel: [ 3194.943348] 0 blocks of free space at or bigger than bytes is

--98e8jtXdkpgskNou--
