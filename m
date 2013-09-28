Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60641 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab3I1T0n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Sep 2013 15:26:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VQ0A5-0002ZP-E2
	for linux-btrfs@vger.kernel.org; Sat, 28 Sep 2013 21:26:41 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Sep 2013 21:26:41 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Sep 2013 21:26:41 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Corrupt btrfs filesystem recovery... (Due to *sata* errors)
Date: Sat, 28 Sep 2013 20:26:26 +0100
Message-ID: <l27agq$u5a$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This may be of interest for the fail cause aswel as how to recover...


I have a known good 2TB (4kByte physical sectors) HDD that supports
sata3 (6Gbit/s). Writing data via rsync at the 6Gbit/s sata rate caused
IO errors for just THREE sectors...

Yet btrfsck bombs out with LOTs of errors...

How best to recover from this?

(This is a 'backup' disk so not 'critical' but it would be nice to avoid
rewriting about 1.5TB of data over the network...)


Is there an obvious sequence/recipe to follow for recovery?

Thanks,
Martin



Further details:

Linux  3.10.7-gentoo-r1 #2 SMP Fri Sep 27 23:38:06 BST 2013 x86_64 AMD
E-450 APU with Radeon(tm) HD Graphics AuthenticAMD GNU/Linux

# btrfs version
Btrfs v0.20-rc1-358-g194aa4a

Single 2TB HDD using default mkbtrfs.
Entire disk (/dev/sdc) is btrfs (no partitions).


The IO errors were:

kernel: end_request: I/O error, dev sdc, sector 3215049328
kernel: end_request: I/O error, dev sdc, sector 3215049328
kernel: end_request: I/O error, dev sdc, sector 3215049328
kernel: end_request: I/O error, dev sdc, sector 3215049328
kernel: end_request: I/O error, dev sdc, sector 3215049328
kernel: end_request: I/O error, dev sdc, sector 3206563752
kernel: end_request: I/O error, dev sdc, sector 3206563752
kernel: end_request: I/O error, dev sdc, sector 3206563752
kernel: end_request: I/O error, dev sdc, sector 3206563752
kernel: end_request: I/O error, dev sdc, sector 3206563752
kernel: end_request: I/O error, dev sdc, sector 3213925248
kernel: end_request: I/O error, dev sdc, sector 3213925248
kernel: end_request: I/O error, dev sdc, sector 3213925248
kernel: end_request: I/O error, dev sdc, sector 3213925248
kernel: end_request: I/O error, dev sdc, sector 3213925248

Lots of sata error noise omitted.


The sata problem was fixed by limiting libata to 3Gbit/s:

libata.force=3.0G

added onto the Grub kernel line.

Running "badblocks" twice in succession (non-destructive data test!)
shows no surface errors and no further errors on the sata interface.

Running btrfsck twice gives the same result, giving a failure with:

Ignoring transid failure
btrfsck: cmds-check.c:1066: process_file_extent: Assertion `!(rec->ino
!= key->objectid || rec->refs > 1)' failed.


An abridged summary is:

checking extents
parent transid verify failed on 907185082368 wanted 15935 found 12264
parent transid verify failed on 907185082368 wanted 15935 found 12264
parent transid verify failed on 907185127424 wanted 15935 found 12264
parent transid verify failed on 907185127424 wanted 15935 found 12264
leaf parent key incorrect 907185135616
bad block 907185135616
parent transid verify failed on 915444707328 wanted 16974 found 13021
parent transid verify failed on 915444707328 wanted 16974 found 13021
parent transid verify failed on 915445092352 wanted 16974 found 13021
parent transid verify failed on 915445092352 wanted 16974 found 13021
leaf parent key incorrect 915444883456
bad block 915444883456
leaf parent key incorrect 915445014528
bad block 915445014528
parent transid verify failed on 907185082368 wanted 15935 found 12264
parent transid verify failed on 907185082368 wanted 15935 found 12264
parent transid verify failed on 907185127424 wanted 15935 found 12264
parent transid verify failed on 907185127424 wanted 15935 found 12264
leaf parent key incorrect 907183771648
bad block 907183771648
leaf parent key incorrect 907183779840
bad block 907183779840
leaf parent key incorrect 907183783936
bad block 907183783936
[...]
leaf parent key incorrect 907185913856
bad block 907185913856
leaf parent key incorrect 907185917952
bad block 907185917952
parent transid verify failed on 915431579648 wanted 16974 found 16972
parent transid verify failed on 915431579648 wanted 16974 found 16972
parent transid verify failed on 915432382464 wanted 16974 found 16972
parent transid verify failed on 915432382464 wanted 16974 found 16972
parent transid verify failed on 915444707328 wanted 16974 found 13021
parent transid verify failed on 915444707328 wanted 16974 found 13021
parent transid verify failed on 915445092352 wanted 16974 found 13021
parent transid verify failed on 915445092352 wanted 16974 found 13021
parent transid verify failed on 915445100544 wanted 16974 found 13021
parent transid verify failed on 915445100544 wanted 16974 found 13021
parent transid verify failed on 915432734720 wanted 16974 found 16972
parent transid verify failed on 915432734720 wanted 16974 found 16972
parent transid verify failed on 915433144320 wanted 16974 found 16972
parent transid verify failed on 915433144320 wanted 16974 found 16972
parent transid verify failed on 915431862272 wanted 16974 found 16972
parent transid verify failed on 915431862272 wanted 16974 found 16972
parent transid verify failed on 915444715520 wanted 16974 found 13021
parent transid verify failed on 915444715520 wanted 16974 found 13021
parent transid verify failed on 915445166080 wanted 16974 found 13021
parent transid verify failed on 915445166080 wanted 16974 found 13021
parent transid verify failed on 915444740096 wanted 16974 found 13021
parent transid verify failed on 915444740096 wanted 16974 found 13021
bad block 915431026688
leaf parent key incorrect 915431141376
bad block 915431141376
leaf parent key incorrect 915431161856
[...]
leaf parent key incorrect 915445100544
bad block 915445100544
leaf parent key incorrect 915445166080
bad block 915445166080
leaf parent key incorrect 915445268480
bad block 915445268480
parent transid verify failed on 915444973568 wanted 16974 found 13021
parent transid verify failed on 915444973568 wanted 16974 found 13021
parent transid verify failed on 915444977664 wanted 16974 found 13021
parent transid verify failed on 915444977664 wanted 16974 found 13021
parent transid verify failed on 915444981760 wanted 16974 found 13021
parent transid verify failed on 915444981760 wanted 16974 found 13021
parent transid verify failed on 915432701952 wanted 16974 found 16972
parent transid verify failed on 915432701952 wanted 16974 found 16972
parent transid verify failed on 915444678656 wanted 16974 found 13021
parent transid verify failed on 915444678656 wanted 16974 found 13021
parent transid verify failed on 915444682752 wanted 16974 found 13021
parent transid verify failed on 915444682752 wanted 16974 found 13021
ref mismatch on [712708972544 4096] extent item 0, found 1
Backref 712708972544 parent 5 root 5 not found in extent tree
backpointer mismatch on [712708972544 4096]
ref mismatch on [712708988928 4096] extent item 0, found 1
Backref 712708988928 parent 5 root 5 not found in extent tree
backpointer mismatch on [712708988928 4096]
ref mismatch on [712708993024 4096] extent item 0, found 1
Backref 712708993024 parent 5 root 5 not found in extent tree
backpointer mismatch on [712708993024 4096]
ref mismatch on [712708997120 4096] extent item 0, found 1
Backref 712708997120 parent 5 root 5 not found in extent tree
backpointer mismatch on [712708997120 4096]
ref mismatch on [712709001216 4096] extent item 0, found 1
Backref 712709001216 parent 5 root 5 not found in extent tree
backpointer mismatch on [712709001216 4096]
[...]
ref mismatch on [712709062656 4096] extent item 0, found 1
Backref 712709062656 parent 5 root 5 not found in extent tree
backpointer mismatch on [712709062656 4096]
ref mismatch on [712709066752 4096] extent item 0, found 1
Backref 712709066752 parent 5 root 5 not found in extent tree
backpointer mismatch on [712709066752 4096]
ref mismatch on [907178082304 4096] extent item 1, found 0
Backref 907178082304 root 5 not referenced back 0x1b96f2a0
Incorrect global backref count on 907178082304 found 1 wanted 0
backpointer mismatch on [907178082304 4096]
owner ref check failed [907178082304 4096]
ref mismatch on [907178090496 4096] extent item 1, found 0
Backref 907178090496 root 5 not referenced back 0x1b98aed0
Incorrect global backref count on 907178090496 found 1 wanted 0
backpointer mismatch on [907178090496 4096]
owner ref check failed [907178090496 4096]
ref mismatch on [907178156032 4096] extent item 1, found 0
Backref 907178156032 root 5 not referenced back 0x3ffe5ce0
Incorrect global backref count on 907178156032 found 1 wanted 0
backpointer mismatch on [907178156032 4096]
owner ref check failed [907178156032 4096]
ref mismatch on [907178160128 4096] extent item 1, found 0
Backref 907178160128 root 5 not referenced back 0x5fbf8b0
Incorrect global backref count on 907178160128 found 1 wanted 0
backpointer mismatch on [907178160128 4096]
owner ref check failed [907178160128 4096]
[...]
ref mismatch on [907180011520 4096] extent item 1, found 0
Backref 907180011520 root 5 not referenced back 0x5980c7e0
Incorrect global backref count on 907180011520 found 1 wanted 0
backpointer mismatch on [907180011520 4096]
owner ref check failed [907180011520 4096]
owner ref check failed [907183771648 4096]
owner ref check failed [907183779840 4096]
owner ref check failed [907183783936 4096]
owner ref check failed [907183792128 4096]
owner ref check failed [907183796224 4096]
owner ref check failed [907183841280 4096]
owner ref check failed [907183874048 4096]
owner ref check failed [907183878144 4096]
owner ref check failed [907183882240 4096]
owner ref check failed [907183886336 4096]
owner ref check failed [907183894528 4096]
owner ref check failed [907183898624 4096]
owner ref check failed [907183902720 4096]
owner ref check failed [907183906816 4096]
owner ref check failed [907183910912 4096]
owner ref check failed [907185057792 4096]
owner ref check failed [907185082368 4096]
owner ref check failed [907185135616 4096]
ref mismatch on [907185139712 4096] extent item 1, found 0
Backref 907185139712 root 5 not referenced back 0x470fa690
Incorrect global backref count on 907185139712 found 1 wanted 0
backpointer mismatch on [907185139712 4096]
owner ref check failed [907185139712 4096]
[...]
ref mismatch on [934316011520 4096] extent item 0, found 1
Backref 934316011520 parent 5 root 5 not found in extent tree
backpointer mismatch on [934316011520 4096]
ref mismatch on [934316019712 4096] extent item 0, found 1
Backref 934316019712 parent 5 root 5 not found in extent tree
backpointer mismatch on [934316019712 4096]
ref mismatch on [934316032000 4096] extent item 0, found 1
Backref 934316032000 parent 5 root 5 not found in extent tree
backpointer mismatch on [934316032000 4096]
ref mismatch on [1128365600768 8192] extent item 1, found 0
Incorrect local backref count on 1128365600768 root 5 owner 889187
offset 0 found 0 wanted 1 back 0x6bb76d90
Backref disk bytenr does not match extent record, bytenr=1128365600768,
ref bytenr=17613768628740554752
backpointer mismatch on [1128365600768 8192]
owner ref check failed [1128365600768 8192]
ref mismatch on [1128365608960 8192] extent item 1, found 0
Incorrect local backref count on 1128365608960 root 5 owner 889188
offset 0 found 0 wanted 1 back 0x6bb76ec0
Backref disk bytenr does not match extent record, bytenr=1128365608960,
ref bytenr=8848955218968205284
backpointer mismatch on [1128365608960 8192]
owner ref check failed [1128365608960 8192]
ref mismatch on [1128365617152 8192] extent item 1, found 0
Incorrect local backref count on 1128365617152 root 5 owner 889189
offset 0 found 0 wanted 1 back 0x6bb76ff0
Backref disk bytenr does not match extent record, bytenr=1128365617152,
ref bytenr=1928784803178016523
backpointer mismatch on [1128365617152 8192]
owner ref check failed [1128365617152 8192]
ref mismatch on [1128365625344 4096] extent item 1, found 0
Incorrect local backref count on 1128365625344 root 5 owner 889190
offset 0 found 0 wanted 1 back 0x6bb77120
Backref disk bytenr does not match extent record, bytenr=1128365625344,
ref bytenr=3735616339648328182
backpointer mismatch on [1128365625344 4096]
owner ref check failed [1128365625344 4096]
[...]
ref mismatch on [1454133166080 12288] extent item 1, found 0
Incorrect local backref count on 1454133166080 root 5 owner 2096965
offset 0 found 0 wanted 1 back 0x50c68ad0
Backref disk bytenr does not match extent record, bytenr=1454133166080,
ref bytenr=64
backpointer mismatch on [1454133166080 12288]
owner ref check failed [1454133166080 12288]
Errors found in extent allocation tree or chunk allocation
checking free space cache
Checking filesystem on /dev/sdc
UUID: 38a60270-f9c6-4ed4-8421-4bf1253ae0b3
free space inode generation (0) did not match free space cache
generation (505)
free space inode generation (0) did not match free space cache
generation (486)
free space inode generation (0) did not match free space cache
generation (486)
free space inode generation (0) did not match free space cache
generation (486)
free space inode generation (0) did not match free space cache
generation (484)
free space inode generation (0) did not match free space cache
generation (486)
free space inode generation (0) did not match free space cache
generation (486)
free space inode generation (0) did not match free space cache
generation (484)
free space inode generation (0) did not match free space cache
generation (486)
free space inode generation (0) did not match free space cache
generation (484)
free space inode generation (0) did not match free space cache
generation (516)
free space inode generation (0) did not match free space cache
generation (486)
free space inode generation (0) did not match free space cache
generation (487)
free space inode generation (0) did not match free space cache
generation (486)
free space inode generation (0) did not match free space cache
generation (501)
free space inode generation (0) did not match free space cache
generation (531)
free space inode generation (0) did not match free space cache
generation (498)
free space inode generation (0) did not match free space cache
generation (498)
free space inode generation (0) did not match free space cache
generation (484)
free space inode generation (0) did not match free space cache
generation (532)
free space inode generation (0) did not match free space cache
generation (502)
free space inode generation (0) did not match free space cache
generation (532)
free space inode generation (0) did not match free space cache
generation (502)
[...]
free space inode generation (0) did not match free space cache
generation (1612)
free space inode generation (0) did not match free space cache
generation (1612)
free space inode generation (0) did not match free space cache
generation (1613)
free space inode generation (0) did not match free space cache
generation (1599)
free space inode generation (0) did not match free space cache
generation (1606)
free space inode generation (0) dparent transid verify failed on
907185127424 wanted 15935 found 12264
parent transid verify failed on 907185127424 wanted 15935 found 12264
parent transid verify failed on 915431579648 wanted 16974 found 16972
parent transid verify failed on 915431579648 wanted 16974 found 16972
parent transid verify failed on 915432382464 wanted 16974 found 16972
parent transid verify failed on 915432382464 wanted 16974 found 16972
parent transid verify failed on 915444707328 wanted 16974 found 13021
parent transid verify failed on 915444707328 wanted 16974 found 13021
parent transid verify failed on 915445092352 wanted 16974 found 13021
parent transid verify failed on 915445092352 wanted 16974 found 13021
parent transid verify failed on 915445100544 wanted 16974 found 13021
parent transid verify failed on 915445100544 wanted 16974 found 13021
parent transid verify failed on 915432734720 wanted 16974 found 16972
parent transid verify failed on 915432734720 wanted 16974 found 16972
parent transid verify failed on 915433144320 wanted 16974 found 16972
parent transid verify failed on 915433144320 wanted 16974 found 16972
parent transid verify failed on 915431862272 wanted 16974 found 16972
parent transid verify failed on 915431862272 wanted 16974 found 16972
parent transid verify failed on 915444715520 wanted 16974 found 13021
parent transid verify failed on 915444715520 wanted 16974 found 13021
parent transid verify failed on 915445166080 wanted 16974 found 13021
parent transid verify failed on 915445166080 wanted 16974 found 13021
parent transid verify failed on 915444740096 wanted 16974 found 13021
parent transid verify failed on 915444740096 wanted 16974 found 13021
parent transid verify failed on 915444973568 wanted 16974 found 13021
parent transid verify failed on 915444973568 wanted 16974 found 13021
parent transid verify failed on 915444977664 wanted 16974 found 13021
parent transid verify failed on 915444977664 wanted 16974 found 13021
parent transid verify failed on 915444981760 wanted 16974 found 13021
parent transid verify failed on 915444981760 wanted 16974 found 13021
parent transid verify failed on 915432701952 wanted 16974 found 16972
parent transid verify failed on 915432701952 wanted 16974 found 16972
parent transid verify failed on 915444678656 wanted 16974 found 13021
parent transid verify failed on 915444678656 wanted 16974 found 13021
parent transid verify failed on 915444682752 wanted 16974 found 13021
parent transid verify failed on 915444682752 wanted 16974 found 13021
checking fs roots
parent transid verify failed on 907185082368 wanted 15935 found 12264
parent transid verify failed on 907185082368 wanted 15935 found 12264
parent transid verify failed on 907185082368 wanted 15935 found 12264
parent transid verify failed on 907185082368 wanted 15935 found 12264
parent transid verify failed on 907185127424 wanted 15935 found 12264
parent transid verify failed on 907185127424 wanted 15935 found 12264
parent transid verify failed on 907185127424 wanted 15935 found 12264
parent transid verify failed on 907185127424 wanted 15935 found 12264
[...]
parent transid verify failed on 915444523008 wanted 16974 found 13021
parent transid verify failed on 915444523008 wanted 16974 found 13021
parent transid verify failed on 915444523008 wanted 16974 found 13021
parent transid verify failed on 915444523008 wanted 16974 found 13021
Ignoring transid failure
btrfsck: cmds-check.c:1066: process_file_extent: Assertion `!(rec->ino
!= key->objectid || rec->refs > 1)' failed.
id not match free space cache generation (1625)
free space inode generation (0) did not match free space cache
generation (1607)
free space inode generation (0) did not match free space cache
generation (1604)
free space inode generation (0) did not match free space cache
generation (1606)
free space inode generation (0) did not match free space cache
generation (1620)
free space inode generation (0) did not match free space cache
generation (1626)
free space inode generation (0) did not match free space cache
generation (1609)
free space inode generation (0) did not match free space cache
generation (1653)
free space inode generation (0) did not match free space cache
generation (1628)
free space inode generation (0) did not match free space cache
generation (1628)
free space inode generation (0) did not match free space cache
generation (1649)

End of output







