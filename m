Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34286 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753573AbdGNMEN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 08:04:13 -0400
Received: by mail-lf0-f68.google.com with SMTP id g21so7998339lfk.1
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 05:04:11 -0700 (PDT)
From: Filippe LeMarchand <gasinvein@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: Btrfs check reports errors, filesystem seems fine
Date: Fri, 14 Jul 2017 15:04:03 +0300
Message-ID: <3453103.9rW5SPuTga@carbide>
In-Reply-To: <7258553b-83b4-4fa9-1f99-a3a1e2b0e5bb@gmx.com>
References: <2049018.boNrIqZ5uI@carbide> <2641001.fhgYYCTHgT@carbide> <7258553b-83b4-4fa9-1f99-a3a1e2b0e5bb@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1843026.Zg9hFWJ8Sr"; micalg="sha256"; protocol="application/pkcs7-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1843026.Zg9hFWJ8Sr
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

> Currently possible solution may be deleting the whole subvolume.
Can btrfs send (to external drive) and then btrfs receive back fix it? Or s=
hould I use simple cp/rsync?
=20
> If you have full backup, then you could try it.
It is my root subvolume (sensitive data is on other ones), thus it is expen=
dable. Can btrfs check --repair damage other subvolumes?

> Any idea about the reproducer? Or just random memory corruption?
No idea why and no idea when. This partition is about year and a half old, =
and I did btrfs check for the first time just about a month ago.
Also I ran memtest recently and it didn't find any errors.

In a letter from Friday, July 14, 2017 14:28:58 MSK user Qu Wenruo wrote:
>=20
> On 2017=E5=B9=B407=E6=9C=8814=E6=97=A5 18:12, Filippe LeMarchand wrote:
> > First "rm" on deprecated.txt worked, but file is still there. Neither t=
he file, nor its parent directory cannot be deleted:
> >=20
> > $ sudo rm /usr/share/doc/packages/util-linux/deprecated.txt
> > rm: cannot remove '/usr/share/doc/packages/util-linux/deprecated.txt': =
No such file or directory
> >=20
> > $ sudo rm -rf /usr/share/doc/packages/util-linux/
> > rm: cannot remove '/usr/share/doc/packages/util-linux/': Directory not =
empty
> >=20
> > $ sudo ls -l /usr/share/doc/packages/util-linux/
> > ls: cannot access '/usr/share/doc/packages/util-linux/deprecated.txt': =
No such file or directory
> > total 0
> > -????????? ? ? ? ?            ? deprecated.txt
>=20
> Similar behavior is also detected using manually crafted image in our=20
> environment.
>=20
> Su Yue have sent patches to enhance error detection and test case for=20
> it, but repairing is not supported.
>=20
> >=20
> > Reinstall of util-linux package gives me two of that file (and also two=
 files present on previous snapshot):
> >=20
> > $ ls -l /usr/share/doc/packages/util-linux/
> > total 104
> > -rw-r--r-- 1 root root 18092 Jul 20  2016 COPYING
> > -rw-r--r-- 1 root root  1391 Jul 20  2016 COPYING.BSD-3
> > -rw-r--r-- 1 root root 26530 Jul 20  2016 COPYING.LGPLv2.1
> > -rw-r--r-- 1 root root  1824 Jul 20  2016 COPYING.UCB
> > -rw-r--r-- 1 root root   555 Jul 20  2016 README.licensing
> > -rw-r--r-- 1 root root  3257 Jul 20  2016 blkid.txt
> > -rw-r--r-- 1 root root  2264 Jul 20  2016 cal.txt
> > -rw-r--r-- 1 root root  1913 Jul 20  2016 col.txt
> > -rw-r--r-- 1 root root  2825 May  2 13:17 deprecated.txt
> > -rw-r--r-- 1 root root  2825 May  2 13:17 deprecated.txt
> > -rw-r--r-- 1 root root   992 Jul 20  2016 getopt.txt
> > -rw-r--r-- 1 root root  2437 Nov  2  2016 howto-debug.txt
> > -rw-r--r-- 1 root root   148 Jul 20  2016 hwclock.txt
> > -rw-r--r-- 1 root root  2617 Jul 20  2016 modems-with-agetty.txt
> > -rw-r--r-- 1 root root   522 Jul 20  2016 mount.txt
> > -rw-r--r-- 1 root root   448 Jul 20  2016 pg.txt
> >=20
> > So, is this situation actually dangerous? And what can I do to gather m=
ore information for you?
>=20
> The situation won't be worse. I'd recommend not to take any snapshot of=20
> those subvolumes (4546 and 5134) to limit the corruption to those=20
> subvolumes.
>=20
> However there is also no easy way to fix it yet.
>=20
> Currently possible solution may be deleting the whole subvolume.
> If no further error happens, it may be fixed.
>=20
> IIRC btrfs check --repair in original mode has=20
> DIR_ITEM/DIR_INDEX/INODE_REF repair function, but I'm not sure if it can=
=20
> handle it well.
> Btrfs check --repair *MAY* fix it, or it may make things worse.
> If you have full backup, then you could try it.
> Otherwise, don't try it at all.
>=20
> Other solution includes a specific repair program just for your case.
> We can modify btrfs-corrupt-block to just delete the corrupted DIR_ITEM=20
> (".sxt" one) and related DIR_INDEX/INODE_REF.
> But I'll only choose this if you really need to fix it as soon as possibl=
e.
>=20
> At least we have solution for it.
> I'm more concerned about how this happened.
>=20
> Any idea about the reproducer? Or just random memory corruption?
>=20
> Thanks,
> Qu
> >=20
> > In a letter from Friday, July 14, 2017 9:11:06 MSK user Qu Wenruo wrote:
> >> Thanks for your dump.
> >>
> >> We're clear what is the direct cause of the problem.
> >>
> >> It's one corrupted DIR_ITEM causing the problem.
> >> And further more, original mode btrfs check can't detect it, and we wi=
ll
> >> fix it soon.
> >>
> >> The corrupted DIR_ITEM is as the following:
> >> 	item 72 key (79177 DIR_ITEM 54846528) itemoff 12380 itemsize 88
> >> 		location key (4222342 INODE_ITEM 0) type FILE
> >> 		transid 170929 data_len 0 name_len 14
> >> 		name: deprecated.sxt
> >> 		location key (13590433 INODE_ITEM 0) type FILE
> >> 		transid 796448 data_len 0 name_len 14
> >> 		name: deprecated.txt
> >>
> >> For dir inode 79177, it has 2 child inodes, with name "deprecated.txt"
> >> (ino=3D4222342) and "deprecated.sxt" (ino=3D13590433)
> >>
> >> But something goes wrong here:
> >>
> >> 1) Hash of "deprecated.sxt" doesn't match 54846528
> >>
> >> 2) Inode backref of inode 4222342 thinks its filename is "deprecated.t=
xt"
> >> Also captured by dump:
> >> 	item 40 key (4222342 INODE_REF 79177) itemoff 7189 itemsize 24
> >> 		inode ref index 417 namelen 14 name: deprecated.txt
> >>
> >> 3) DIR_INDEX also shows that filename for inode 4222342 should be
> >> "deprecated.txt"
> >> 	item 87 key (79177 DIR_INDEX 417) itemoff 11757 itemsize 44
> >> 		location key (4222342 INODE_ITEM 0) type FILE
> >> 		transid 170929 data_len 0 name_len 14
> >> 		name: deprecated.txt
> >>
> >> So generic speaking, it's DIR_ITEM wrong and causing the problem.
> >>
> >> But the root reason is still unknown.
> >>
> >> What I can see is, the corrupted DIR_ITEM points to an very old inode,
> >> its mtime is back to 2016-09-07.
> >> While the good DIR_ITEM points to newer inode, whose mtime is just
> >> 2017-05-02.
> >>
> >> But more weird, there should not be two child inodes with the same
> >> filename ("depercated.txt", I assume the sxt one is caused by a memory
> >> bit corruption).
> >>
> >> So, any details on the operation with util-linux/deprecated.txt will
> >> help us to locate the root cause in kernel.
> >>
> >> Thanks,
> >> Qu
> >>
> >>
> >> On 2017=E5=B9=B407=E6=9C=8812=E6=97=A5 21:11, Filippe LeMarchand wrote:
> >>> Done, files added to same GDrive folder with corresponding names.
> >>> If it matters, subvol 4546 is my root filesystem (r/w snapshot create=
d with snapper rollback), and 5134 is its snapshot.
> >>>
> >>> In a letter dated Wednesday, July 12, 2017 15:44:52 MSK user Qu Wenru=
o wrote:
> >>>>
> >>>> On 2017=E5=B9=B407=E6=9C=8812=E6=97=A5 19:12, Filippe LeMarchand wro=
te:
> >>>>>> Maybe something wrong in grep happened which skip "(79177" ?
> >>>>> Yes, my bad. Now I used grep -E "\(79177| 79177" pattern, file on G=
Drive updated.
> >>>>
> >>>> It looks much better, thanks.
> >>>>
> >>>>>
> >>>>> And btrfs check --mode=3Dlowmem gives this:
> >>>>>
> >>>>> checking extents
> >>>>> ERROR: extent[1609877700608, 94208] referencer count mismatch (root=
: 260, owner: 61720, offset: 6742016) wanted: 2, have: 5
> >>>>> ERROR: extent[1630301675520, 39583744] referencer count mismatch (r=
oot: 260, owner: 5847554, offset: 0) wanted: 36, have: 114
> >>>>> ERROR: extent[1658646986752, 10551296] referencer count mismatch (r=
oot: 274, owner: 283675, offset: 0) wanted: 2, have: 5
> >>>>> ERROR: extent[1672239132672, 84381696] referencer count mismatch (r=
oot: 274, owner: 2521382, offset: 0) wanted: 21, have: 25
> >>>>> ERROR: errors found in extent allocation tree or chunk allocation
> >>>>
> >>>> Looks much like an exposed lowmem mode bug.
> >>>> Feel free to ignore these error from extent tree, they are just false
> >>>> alerts.
> >>>>
> >>>>> checking free space cache
> >>>>> checking fs roots
> >>>>> ERROR: root 4546 DIR_ITEM[79177 54846528] relative INODE_REF missin=
g namelen 14 filename deprecated.sxt filetype 1
> >>>>
> >>>> The error report is much better than original mode, and that's what =
I need.
> >>>>
> >>>> Now I can wipe out all other noise as we know exactly which tree and
> >>>> which DIR_ITEM/INODE_REF is causing the problem.
> >>>>
> >>>> Would you please update the dump result with "-t 4546" passed to
> >>>> btrfs-debug-tree like:
> >>>>
> >>>> # btrfs-debug-tree -t 4546 <device>| grep 79177
> >>>>
> >>>> Only "-t 4546" is added, to only dump the result of subvolume 4546.
> >>>> As always, all 3 grep results (2 "deprecated" and one 79177) need to=
 be
> >>>> updated.
> >>>>
> >>>> And it seems that my previous assumption is still right for this cas=
e.
> >>>> If it's caused by kernel, your dump would definitely help us to loca=
te
> >>>> the problem.
> >>>>
> >>>>> ERROR: root 4546 INODE REF[4222342 79177] and DIR_ITEM[79177 548465=
28] mismatch namelen 14 filename deprecated.txt filetype 1
> >>>>> ERROR: root 5134 DIR_ITEM[79177 54846528] relative INODE_REF missin=
g namelen 14 filename deprecated.sxt filetype 1
> >>>>
> >>>> Also for root 5134 please.
> >>>>
> >>>> Thanks,
> >>>> Qu
> >>>>
> >>>>> ERROR: errors found in fs roots
> >>>>> Checking filesystem on /dev/sda2
> >>>>> UUID: 12c84aa3-ce65-4390-807e-a72cc8a7445e
> >>>>> found 153429872640 bytes used, error(s) found
> >>>>> total csum bytes: 121991672
> >>>>> total tree bytes: 1940160512
> >>>>> total fs tree bytes: 1683767296
> >>>>> total extent tree bytes: 103841792
> >>>>> btree space waste bytes: 310722480
> >>>>> file data blocks allocated: 842455031808
> >>>>>     referenced 159286636544
> >>>>>
> >>>>> In a letter from Wednesday, July 12, 2017 10:15:18 MSK user Qu Wenr=
uo wrote:
> >>>>>> Sorry for the late reply.
> >>>>>>
> >>>>>> After investigating the dumps, I found the output is quite strange.
> >>>>>>
> >>>>>> 1) Mismatching output.
> >>>>>> In "btrfs-debug-tree-grep-79177.txt" I found only 79177 as offset =
for
> >>>>>> INODE_REF is here, while 79177 as objectid for DIR_ITEM/DIR_INDEX =
is not
> >>>>>> here at all.
> >>>>>>
> >>>>>> While in "btrfs-debug-tree-grep-deprecated-txt.txt" there is epect=
ed
> >>>>>> 79177 DIR_ITEM/DIR_INDEX.
> >>>>>>
> >>>>>> Maybe something wrong in grep happened which skip "(79177" ?
> >>>>>>
> >>>>>> 2) Mismatched hash
> >>>>>> The main problem I found is that, for key (79177 DIR_ITEM 54846528=
), the
> >>>>>> number 54846528 is the hash(crc32c) of filename, and it contains 2
> >>>>>> items, one for "deprecated.txt" and one for "deprecated.sxt".
> >>>>>>
> >>>>>> But we found that 54846528 only matches the hash for "deprecated.t=
xt",
> >>>>>> not "deprecated.sxt".
> >>>>>>
> >>>>>> I think that's the main problem.
> >>>>>>
> >>>>>> BTW, would you please try "btrfs check --mode=3Dlowmem" to see if =
lowmem
> >>>>>> mode reports similar (well, output may differ) error?
> >>>>>>
> >>>>>> If lowmem mode also reports error on such DIR_ITEM, I'm pretty sure
> >>>>>> that's the problem.
> >>>>>>
> >>>>>> However it may take some time before we can fix it in repair mode.
> >>>>>>
> >>>>>> Thanks,
> >>>>>> Qu
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> =E5=9C=A8 2017=E5=B9=B407=E6=9C=8804=E6=97=A5 21:24, Filippe LeMar=
chand =E5=86=99=E9=81=93:
> >>>>>>> Sure, here it is:
> >>>>>>> https://drive.google.com/drive/folders/0B1ax9Am81gx9YjJBVVA0LXRHe=
Gc
> >>>>>>>
> >>>>>>> In a letter dated Tuesday, July 4, 2017 16:16:36 MSK user Lu Feng=
qi wrote:
> >>>>>>>> On Mon, Jul 03, 2017 at 08:34:52AM +0800, Qu Wenruo wrote:
> >>>>>>>>>
> >>>>>>>>>
> >>>>>>>>> At 07/01/2017 07:59 PM, Filippe LeMarchand wrote:
> >>>>>>>>>> Hello everyone.
> >>>>>>>>>>
> >>>>>>>>>> I have an btrfs root partition on Intel 530 ssd, which mounts =
without errors and seem to work fine,
> >>>>>>>>>> but `btrfs check` gives me foloowing output (and --repair does=
n't remove errors):
> >>>>>>>>>>
> >>>>>>>>>> enabling repair mode
> >>>>>>>>>> Checking filesystem on /dev/sda2
> >>>>>>>>>> UUID: 12c84aa3-ce65-4390-807e-a72cc8a7445e
> >>>>>>>>>> checking extents
> >>>>>>>>>> Fixed 0 roots.
> >>>>>>>>>> checking free space cache
> >>>>>>>>>> cache and super generation don't match, space cache will be in=
validated
> >>>>>>>>>> checking fs roots
> >>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.s=
xt filetype 1 errors 6, no dir index, no inode ref
> >>>>>>>>>
> >>>>>>>>> This means that in dir whose inode number is 79177, it has a ch=
ild inode
> >>>>>>>>> pointer pointing to depercated.sxt.
> >>>>>>>>>
> >>>>>>>>> But it doesn't have dir index and corresponding inode ref, whic=
h is breaking
> >>>>>>>>> the cross reference rule of btrfs.
> >>>>>>>>>
> >>>>>>>>> Would you please run the following command to dump needed info =
for us to
> >>>>>>>>> debug?
> >>>>>>>>>
> >>>>>>>>> # btrfs-debug-tree /dev/sda2 | grep 79177 -C 10
> >>>>>>>>>
> >>>>>>>>> and
> >>>>>>>>>
> >>>>>>>>> # btrfs-debug-tree /dev/sda2 | grep deprecated.sxt -C 10
> >>>>>>>>>
> >>>>>>>>> and
> >>>>>>>>>
> >>>>>>>>> # btrfs-debug-tree /dev/sda2 | grep deprecated.txt -C 10
> >>>>>>>>>
> >>>>>>>>>
> >>>>>>>>> Considering the output has both .txt and .sxt, I think that's t=
he problem.
> >>>>>>>>> But such bit-flip should be detected by tree block csum.
> >>>>>>>>> I'm not sure what's wrong with it.
> >>>>>>>>>
> >>>>>>>>> Thanks,
> >>>>>>>>> Qu
> >>>>>>>>>
> >>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated=
=2Etxt filetype 1 errors 1, no dir item
> >>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.s=
xt filetype 1 errors 6, no dir index, no inode ref
> >>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated=
=2Etxt filetype 1 errors 1, no dir item
> >>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.s=
xt filetype 1 errors 6, no dir index, no inode ref
> >>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated=
=2Etxt filetype 1 errors 1, no dir item
> >>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.s=
xt filetype 1 errors 6, no dir index, no inode ref
> >>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated=
=2Etxt filetype 1 errors 1, no dir item
> >>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.s=
xt filetype 1 errors 6, no dir index, no inode ref
> >>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated=
=2Etxt filetype 1 errors 1, no dir item
> >>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.s=
xt filetype 1 errors 6, no dir index, no inode ref
> >>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated=
=2Etxt filetype 1 errors 1, no dir item
> >>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.s=
xt filetype 1 errors 6, no dir index, no inode ref
> >>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated=
=2Etxt filetype 1 errors 1, no dir item
> >>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.s=
xt filetype 1 errors 6, no dir index, no inode ref
> >>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated=
=2Etxt filetype 1 errors 1, no dir item
> >>>>>>>>>> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.s=
xt filetype 1 errors 6, no dir index, no inode ref
> >>>>>>>>>> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated=
=2Etxt filetype 1 errors 1, no dir item
> >>>>>>>>>> checking csums
> >>>>>>>>>> checking root refs
> >>>>>>>>>> found 23421812736 bytes used err is 0
> >>>>>>>>>> total csum bytes: 21531608
> >>>>>>>>>> total tree bytes: 776650752
> >>>>>>>>>> total fs tree bytes: 711278592
> >>>>>>>>>> total extent tree bytes: 36798464
> >>>>>>>>>> btree space waste bytes: 116002036
> >>>>>>>>>> file data blocks allocated: 850546470912
> >>>>>>>>>>       referenced 27611987968
> >>>>>>>>>>
> >>>>>>>>>> Is it dangerous and what should I do about it?
> >>>>>>>>>>
> >>>>>>>>>> I also tried --clear-space-cache, but it just removes the line=
 about space cache.
> >>>>>>>>>>
> >>>>>>>>>
> >>>>>>>>>
> >>>>>>>>> --
> >>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux=
=2Dbtrfs" in
> >>>>>>>>> the body of a message to majordomo@vger.kernel.org
> >>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.h=
tml
> >>>>>>>>
> >>>>>>>> I'm afraid that your mail may be rejected because the attachment=
 size
> >>>>>>>> exceeds the allowable limit(100kB) of btrfs mailing list. Could =
you
> >>>>>>>> share the attachment by google drive?
> >>>>>>>>
> >>>>>>>> Lastly, while Qu's timing is too tight, I will assist you on thi=
s issue.
> >>>>>>>>
>=20
--nextPart1843026.Zg9hFWJ8Sr
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

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
EwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJT
QSBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAL6znlesKHZ1QBbHOAOY08YYdiFQ8yV5C0y1oNF9Olg+nKcxLqf2
NHbZhGra0D00SOTq9bus3/mxgUsg/Wh/eXQ0pnp8tZ8XZWAnlyKMpjL+qUByRjXCA6RQyDMqVaVU
kbIr5SU0RDX/kSsKwer3H1pT/HUrBN0X8sKtPTdGX8XAWt/VdMLBrZBlgvnkCos+KQWWCo63OTTq
Rvaq8aWccm+KOMjTcE6s2mj6RkalweyDI7X+7U5lNo6jzC8RTXtVV4/Vwdax720YpMPJQaDaElmO
upyTf1Qib+cpukNJnQmwygjD8m046DQkLnpXNCAGjuJy1F5NATksUsbfJAr7FLUCAwEAAaOCATww
ggE4MB8GA1UdIwQYMBaAFLuvfgI9+qbxPISOre44mOzZMjLUMB0GA1UdDgQWBBSCr2yM+MX+lmF8
6B89K3FIXsSLwDAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADARBgNVHSAECjAI
MAYGBFUdIAAwTAYDVR0fBEUwQzBBoD+gPYY7aHR0cDovL2NybC5jb21vZG9jYS5jb20vQ09NT0RP
UlNBQ2VydGlmaWNhdGlvbkF1dGhvcml0eS5jcmwwcQYIKwYBBQUHAQEEZTBjMDsGCCsGAQUFBzAC
hi9odHRwOi8vY3J0LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FBZGRUcnVzdENBLmNydDAkBggrBgEF
BQcwAYYYaHR0cDovL29jc3AuY29tb2RvY2EuY29tMA0GCSqGSIb3DQEBDAUAA4ICAQB4XLKBKDRP
PO5fVs6fl1bsj6JrF/bz9kkIBtTYLzXN30D+03Hj6OxCDBEaIeNmsBhrJmuubvyE7HtoSmR809Ag
cYboW+rcTNZ/8u/Hv+GTrNI/AhqX2/kiQNxmgUPt/eJPs92Qclj0HnVyy9TnSvGkSDU7I5Px+TbO
+88G4zipA2psZaWeEykgzClZlPz1FjTCkk77ZXp5cQYYexE6zeeN4/0OqqoAloFrjAF4o50YJafX
8mnahjp3I2Y2mkjhk0xQfhNqbzlLWPoT3m7j7U26u7zg6swjOq8hITYc3/np5tM5aVyu6t99p17b
TbY7+1RTWBviN9YJzK8HxzObXYWBf/L+VGOYNsQDTxAk0Hbvb1j6KjUhg7fO294F29QIhhmiNOr8
4JHoy+fNLpfvYc/Q9EtFOI5ISYgOxLk3nD/whbUe9rmEQXLp8MB933Ij474gwwCPUpwv9mj2PMnX
oc7mbrS22XUSeTwxCTP9bcmUdp4jmIoWfhQm7X9w/Zgddg+JZ/YnIHOwsGsaTUgj7fIvxqith7Do
JC91WJ8Lce3CVJqb1XWeKIJ84F7YLXZN0oa7TktYgDdmQVxYkZo1c5noaDKH9Oq9cbm/vOYRUM1c
Wcef20Wkyk5S/GFyyPJwG0fR1nRas3DqAf4cXxMiEKcff7PNa4M3RGTqH0pWR8p6EjCCBTIwggQa
oAMCAQICEQDXdDjI2wGDsxF6weHvf8mUMA0GCSqGSIb3DQEBCwUAMIGXMQswCQYDVQQGEwJHQjEb
MBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFD
T01PRE8gQ0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRp
b24gYW5kIFNlY3VyZSBFbWFpbCBDQTAeFw0xNzA2MDgwMDAwMDBaFw0xODA2MDgyMzU5NTlaMCQx
IjAgBgkqhkiG9w0BCQEWE2dhc2ludmVpbkBnbWFpbC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQDIMvvH6x4GgcmPVYk/zAxFsdpSHo9zqW5CnI+fLlGLnEvn5TdcutXr0ToCsfeD
MXPO5c+pmR9bHjQTYIYHb6WPA6xvxjv1ZO/YkGDmSaiA7wxDdOAmsJVgaqV/ijNCZZBRkxoEXNQb
ABYij3fQYbcyoHEmT6lTu+AcBKf0M7yeclqSpwGABfco3/WLs7Dts4aDgsg2xxA/d2ZtU8+Bgw6J
ePSysugO1/xjJFO9g/OZksOTdm1GaEp/XpCmzQp2YNFiBSzLbphowdryOAWj5ypwvm237rfO1vEk
EUdrd/XXKQGs49lAzPcV4bZChnnrTR1BGJdZh3uWi/FO4XG55bA7AgMBAAGjggHpMIIB5TAfBgNV
HSMEGDAWgBSCr2yM+MX+lmF86B89K3FIXsSLwDAdBgNVHQ4EFgQUrzUVgwSsp6awdPonAkbSCzmP
LdQwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwIAYDVR0lBBkwFwYIKwYBBQUHAwQGCysG
AQQBsjEBAwUCMBEGCWCGSAGG+EIBAQQEAwIFIDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEBATAr
MCkGCCsGAQUFBwIBFh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+g
TaBLhklodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlv
bmFuZFNlY3VyZUVtYWlsQ0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6
Ly9jcnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJl
RW1haWxDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREE
FzAVgRNnYXNpbnZlaW5AZ21haWwuY29tMA0GCSqGSIb3DQEBCwUAA4IBAQC2YT8zrjNlQIP1roMw
sopvoUtJO/yDAP5M4GPdkS2VQc+gVygV2OhjyHCZcdBBgUwtMpNivjxcqjWtSYh6F5pernYPZXtz
cMn9oYG6S7H9JmKDYObF0w6WadMUAdbpnSJD2MydLsjOTE5timdd42ncTkZq3dVICCHSvXMs5sJG
DaQo3Vha5ECosxs9zC6wmDRlBghLeTppq/d1HHCksSkhUlCHEorNqEFm+hB1FHh/1akSVT8/GdRd
1f2IGsOZDSZCcBdR5c2wLz9RqwEQmuV6MUqeVRLuKRg1C27lhpCPmEeq+Y8LHNOFeT1P/uL0VVDM
skktNX6qc13tni1zDzZAMYICbzCCAmsCAQEwga0wgZcxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJH
cmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBM
aW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2Vj
dXJlIEVtYWlsIENBAhEA13Q4yNsBg7MResHh73/JlDANBglghkgBZQMEAgEFAKCBkzAYBgkqhkiG
9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNzA3MTQxMjA0MDNaMCgGCSqGSIb3
DQEJDzEbMBkwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMC8GCSqGSIb3DQEJBDEiBCD95wuZBoOW
q4R/4ripA/dzk1YSKzRE6k5H9/okyzsJmzANBgkqhkiG9w0BAQEFAASCAQAueSYz+x2OXe09dLPD
QarU49M3Dqt+cWgCKInMGa+FxHsm56A28alK4x5UckgymSG1u7UYEf61aWY7rPnOEN/T/Es7N5Ea
V/W2AJyYCwuEZD851eOn2rVolbHmmBF8k/tXvAWR2PCHw/tL0aEuWO0WBHD0N3xFYcxuSRMDfk/3
ln5H0ZELeVM4cXMf4WOT/91x0vXNtHO8kE0Xl3Xkn0vPUKRFF3wcdJNWnmgkYnjcYCXaLvV8HlW3
whahrthmbtu4ToD9u2wvURVCK6AxKrfy/Hmr8D0QZS6apeLvd9uexSYAk7U8scEPegolXZgRzF4Q
kGF/LIPmMNqCd8RFPxU+AAAAAAAA


--nextPart1843026.Zg9hFWJ8Sr--

