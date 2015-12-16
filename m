Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2on0108.outbound.protection.outlook.com ([207.46.100.108]:11808
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751445AbbLPDs2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 22:48:28 -0500
From: "Langhorst, Brad" <Langhorst@neb.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: need to recover large file
Date: Wed, 16 Dec 2015 03:13:48 +0000
Message-ID: <E3AE2CD5-D3F1-48CF-9C5E-092DDF41AF3A@neb.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi:

I just screwed up‚Ä¶ spent the last 3 weeks generting a 400G file (genome assembly) . 
Went to back it up and swapped the arguments to tar (tar Jcf my_precious my_precious.tar.xz) 
what was once 400G is now 108 bytes of xz header - argh.  

This is on a 6-volume btrfs filesystem. 

I immediately unmounted the fs (had to cd /  first).

After a bit of searching I found Chris Mason‚Äôs post about using btrfs-debug-tree -R

root tree: 25606900367360 level 1
chunk tree: 25606758596608 level 1
extent tree key (EXTENT_TREE ROOT_ITEM 0) 25606900383744 level 2
device tree key (DEV_TREE ROOT_ITEM 0) 25606865108992 level 1
fs tree key (FS_TREE ROOT_ITEM 0) 22983583956992 level 1
checksum tree key (CSUM_TREE ROOT_ITEM 0) 25606922682368 level 2
uuid tree key (UUID_TREE ROOT_ITEM 0) 22984609513472 level 0
data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0) 22984615477248 level 0
btrfs root backup slot 0
	tree root gen 21613 block 25606891274240
		extent root gen 21613 block 25606891323392
		chunk root gen 21612 block 25606758596608
		device root gen 21612 block 25606865108992
		csum root gen 21613 block 25606891503616
		fs root gen 21611 block 22983583956992
		1712858198016 used 5400011280384 total 6 devices
btrfs root backup slot 1
	tree root gen 21614 block 25606900367360
		extent root gen 21614 block 25606900383744
		chunk root gen 21612 block 25606758596608
		device root gen 21612 block 25606865108992
		csum root gen 21614 block 25606922682368
		fs root gen 21611 block 22983583956992
		1712858198016 used 5400011280384 total 6 devices
btrfs root backup slot 2
	tree root gen 21611 block 25606857605120
		extent root gen 21611 block 22983584268288
		chunk root gen 21595 block 25606758612992
		device root gen 21601 block 22983580794880
		csum root gen 21611 block 22983584333824
		fs root gen 21611 block 22983583956992
		1712971542528 used 5400011280384 total 6 devices
btrfs root backup slot 3
	tree root gen 21612 block 25606874546176
		extent root gen 21612 block 25606880575488
		chunk root gen 21612 block 25606758596608
		device root gen 21612 block 25606865108992
		csum root gen 21612 block 25606890864640
		fs root gen 21611 block 22983583956992
		1712971444224 used 5400011280384 total 6 devices
total bytes 5400011280384
bytes used 1712858198016
uuid b13d3dc1-f287-483c-8b7d-b142f31fe6df
Btrfs v3.12

if found the oldest generation and grabbed the tree root gen block  like this

sudo btrfs restore -o -v -t 25606857605120 --path-regex ^/\(\|deer\(\|/masurca\(\|/quorum_mer_db.jf\)\)\)$ /dev/sdd1 /tmp/recover/

unfortunately, I only recovered the post error file.

I also read that one can use btrfs-find-root to get a list of files to recover
 and just ran btrfs-find-root on one of the underlying disks but I get an error  
"Super think's the tree root is at 25606900367360, chunk root 25606758596608
Went past the fs size, exiting‚Äù
Someone else was able to get past this by commenting that error ‚Ä¶ so i tried recompiling without those lines.

Super think's the tree root is at 25606900367360, chunk root 25606758596608
Well block 24729718243328 seems great, but generation doesn't match, have=21582, want=21614 level 1
Well block 24729718292480 seems great, but generation doesn't match, have=21582, want=21614 level 0
Well block 24729718308864 seems great, but generation doesn't match, have=21582, want=21614 level 0
Well block 24729718407168 seems great, but generation doesn't match, have=21582, want=21614 level 0
Well block 24729944670208 seems great, but generation doesn't match, have=21583, want=21614 level 1
Well block 24729944719360 seems great, but generation doesn't match, have=21583, want=21614 level 0
Well block 24729944735744 seems great, but generation doesn't match, have=21583, want=21614 level 0
Well block 24729944817664 seems great, but generation doesn't match, have=21583, want=21614 level 0
Well block 24730048708608 seems great, but generation doesn't match, have=21584, want=21614 level 1
Well block 24730048724992 seems great, but generation doesn't match, have=21584, want=21614 level 0
Well block 24730048741376 seems great, but generation doesn't match, have=21584, want=21614 level 0
Well block 24730048757760 seems great, but generation doesn't match, have=21584, want=21614 level 0
Well block 24730048774144 seems great, but generation doesn't match, have=21584, want=21614 level 0
Well block 24730048823296 seems great, but generation doesn't match, have=21584, want=21614 level 0
Well block 24730132348928 seems great, but generation doesn't match, have=21585, want=21614 level 1
Well block 24730132414464 seems great, but generation doesn't match, have=21585, want=21614 level 0
Well block 24730132430848 seems great, but generation doesn't match, have=21585, want=21614 level 0
Well block 24730211762176 seems great, but generation doesn't match, have=21586, want=21614 level 1
Well block 24730211778560 seems great, but generation doesn't match, have=21586, want=21614 level 0
Well block 24730211794944 seems great, but generation doesn't match, have=21586, want=21614 level 0
Well block 24730211811328 seems great, but generation doesn't match, have=21586, want=21614 level 0
Well block 24730211827712 seems great, but generation doesn't match, have=21586, want=21614 level 0
Well block 24730291781632 seems great, but generation doesn't match, have=21587, want=21614 level 1
Well block 24730291798016 seems great, but generation doesn't match, have=21587, want=21614 level 0
Well block 24730291814400 seems great, but generation doesn't match, have=21587, want=21614 level 0
Well block 24730291830784 seems great, but generation doesn't match, have=21587, want=21614 level 0
Well block 24730291847168 seems great, but generation doesn't match, have=21587, want=21614 level 0
Well block 24730291863552 seems great, but generation doesn't match, have=21587, want=21614 level 0
Well block 24730292191232 seems great, but generation doesn't match, have=21587, want=21614 level 0
Well block 24730368065536 seems great, but generation doesn't match, have=21588, want=21614 level 1
Well block 24730368081920 seems great, but generation doesn't match, have=21588, want=21614 level 0
Well block 24730368098304 seems great, but generation doesn't match, have=21588, want=21614 level 0
Well block 24730368131072 seems great, but generation doesn't match, have=21588, want=21614 level 0
Well block 24730368147456 seems great, but generation doesn't match, have=21588, want=21614 level 0
Well block 24730368196608 seems great, but generation doesn't match, have=21588, want=21614 level 0
Well block 24730450804736 seems great, but generation doesn't match, have=21589, want=21614 level 1
Well block 24730451394560 seems great, but generation doesn't match, have=21589, want=21614 level 0
Well block 24730451410944 seems great, but generation doesn't match, have=21589, want=21614 level 0
Well block 24730451558400 seems great, but generation doesn't match, have=21589, want=21614 level 0
Well block 24730451607552 seems great, but generation doesn't match, have=21589, want=21614 level 0
Well block 24730542997504 seems great, but generation doesn't match, have=21590, want=21614 level 1
Well block 24730543063040 seems great, but generation doesn't match, have=21590, want=21614 level 0
Well block 24730543112192 seems great, but generation doesn't match, have=21590, want=21614 level 0
Well block 25606820544512 seems great, but generation doesn't match, have=21591, want=21614 level 1
Well block 25606820659200 seems great, but generation doesn't match, have=21591, want=21614 level 0
Well block 25606857605120 seems great, but generation doesn't match, have=21611, want=21614 level 1
Well block 25606857621504 seems great, but generation doesn't match, have=21611, want=21614 level 0
Well block 25606857637888 seems great, but generation doesn't match, have=21611, want=21614 level 0
Well block 25606857654272 seems great, but generation doesn't match, have=21611, want=21614 level 0
Well block 25606857670656 seems great, but generation doesn't match, have=21611, want=21614 level 0
Well block 25606860406784 seems great, but generation doesn't match, have=21611, want=21614 level 0
Well block 25606865059840 seems great, but generation doesn't match, have=21611, want=21614 level 0
Well block 25606865076224 seems great, but generation doesn't match, have=21611, want=21614 level 0
Well block 25606865092608 seems great, but generation doesn't match, have=21611, want=21614 level 0
Well block 25606874546176 seems great, but generation doesn't match, have=21612, want=21614 level 1
Well block 25606880559104 seems great, but generation doesn't match, have=21612, want=21614 level 0
Well block 25606890799104 seems great, but generation doesn't match, have=21612, want=21614 level 0
Well block 25606890815488 seems great, but generation doesn't match, have=21612, want=21614 level 0
Well block 25606890831872 seems great, but generation doesn't match, have=21612, want=21614 level 0
Well block 25606891257856 seems great, but generation doesn't match, have=21612, want=21614 level 0
Well block 25606891274240 seems great, but generation doesn't match, have=21613, want=21614 level 1
Well block 25606891307008 seems great, but generation doesn't match, have=21613, want=21614 level 0
Well block 25606899744768 seems great, but generation doesn't match, have=21613, want=21614 level 0
Well block 25606900334592 seems great, but generation doesn't match, have=21613, want=21614 level 0
Found tree root at 25606900367360 gen 21614 level 1

none of these block numbers seems to be restorable though‚Ä¶
(tried like this: btrfs restore -o -v -f 25606865092608 --path-regex ^/\(\|deer\(\|/masurca\(\|/quorum_mer_db.jf\)\)\)$ /dev/sdd1 /tmp/recover

Is there any way to restore my file?

Thanks!

Brad

--
Brad Langhorst, Ph.D.
Development Scientist
New England Biolabs

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˝ªk~œ‚ûÿ^nár°ˆ¶zÀÅÎhô®Ë≠⁄&£˚‡zø‰zπﬁó˙+Ä +zf£¢∑höàß~Ü≠Ü€iˇˇÔÅÍˇëÍÁz_ËÆÊj:+vâ®˛)ﬂ£¯m
