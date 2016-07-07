Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53819 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbcGGNuH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 09:50:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id C1222202BB
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jul 2016 09:50:00 -0400 (EDT)
Received: from [192.168.1.129] (unknown [2.235.201.237])
	by mail.messagingengine.com (Postfix) with ESMTPA id 85A85F29F4
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jul 2016 09:49:51 -0400 (EDT)
To: linux-btrfs@vger.kernel.org
From: Francesco Turco <fturco@fastmail.fm>
Subject: Frequent btrfs corruption on a USB flash drive
Message-ID: <0120508a-b9e7-b9e7-4f27-79f982ee07fe@fastmail.fm>
Date: Thu, 7 Jul 2016 15:49:47 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------9EBF33F312BA62FF22FBF1BE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------9EBF33F312BA62FF22FBF1BE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

I have a USB flash drive with an encrypted Btrfs filesystem where I
store daily backups. My problem is that this btrfs filesystem gets
corrupted very often, after a few days of usage. Usually I just reformat
it and move along, but this time I'd like to understand the root cause
of the problem and fix it.

I can mount the partition without problems, but then when using commands
such as rsync or even humble ls I get the following error message:

$ rsync /home/fturco/Buffer/E-book/
/run/media/fturco/5283147c-b7b4-448f-97b0-b235344a56a3/Buffer/E-book/
--recursive
rsync:
readlink_stat("/run/media/fturco/5283147c-b7b4-448f-97b0-b235344a56a3/Riviste")
failed: Stale file handle (116)
rsync:
readlink_stat("/run/media/fturco/5283147c-b7b4-448f-97b0-b235344a56a3/Backup")
failed: Stale file handle (116)
rsync:
readdir("/run/media/fturco/5283147c-b7b4-448f-97b0-b235344a56a3/Calibre
(TMSU)"): Input/output error (5)

The previous command gets stuck and I had to manually stop it.

The following command doesn't return any output, but its exit code is 1
(failure):

$ btrfs filesystem show
/run/media/fturco/5283147c-b7b4-448f-97b0-b235344a56a3
$

Btrfs-check reports many errors. I attached the output to this e-mail
message.

Output from dmesg:

$ dmesg | tail
[18756.159963] BTRFS error (device dm-4): bad tree block start
6592115285688248773 35323904
[18756.160828] BTRFS error (device dm-4): bad tree block start
8533404122473270145 35323904
[18756.161821] BTRFS error (device dm-4): bad tree block start
6592115285688248773 35323904
[18756.163047] BTRFS error (device dm-4): bad tree block start
8533404122473270145 35323904
[18756.163921] BTRFS error (device dm-4): bad tree block start
6592115285688248773 35323904
[18756.164806] BTRFS error (device dm-4): bad tree block start
8533404122473270145 35323904
[18756.165673] BTRFS error (device dm-4): bad tree block start
6592115285688248773 35323904
[18756.166548] BTRFS error (device dm-4): bad tree block start
8533404122473270145 35323904
[18757.950603] BTRFS error (device dm-4): bad tree block start
6592115285688248773 35323904
[18757.951492] BTRFS error (device dm-4): bad tree block start
8533404122473270145 35323904

I checked this USB flash drive with badblocks in non-destructive
read-write mode. No errors.

If I format this partition as Ext4 instead of Btrfs I can use it without
problems, but my goal is to use Btrfs on all devices.

My GNU/Linux distribution is Parabola GNU/Linux-libre.
Kernel version is: 4.6.3.
Btrfs-progs version is: 4.6

Please tell me if you need other details. Thanks.

-- 
Website: http://www.fturco.net/
GPG key: 6712 2364 B2FE 30E1 4791 EB82 7BB1 1F53 29DE CD34

--------------9EBF33F312BA62FF22FBF1BE
Content-Type: text/x-log;
 name="btrfs-check.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="btrfs-check.log"

# btrfs check --readonly /dev/mapper/luks-08e23ed4-a2a1-41f0-a5f6-794ff06=
47ada
Checking filesystem on /dev/mapper/luks-08e23ed4-a2a1-41f0-a5f6-794ff0647=
ada
UUID: 5283147c-b7b4-448f-97b0-b235344a56a3
checking extents
checksum verify failed on 35274752 found E042416D wanted 4CD1CFA0
checksum verify failed on 35274752 found E042416D wanted 4CD1CFA0
checksum verify failed on 35274752 found E8B38F1B wanted B3F4F728
checksum verify failed on 35274752 found E042416D wanted 4CD1CFA0
bytenr mismatch, want=3D35274752, have=3D6970279768983377651
checksum verify failed on 35291136 found 6B9667D1 wanted CDED2E29
checksum verify failed on 35291136 found 6B9667D1 wanted CDED2E29
checksum verify failed on 35291136 found 607F5103 wanted F21126A3
checksum verify failed on 35291136 found 6B9667D1 wanted CDED2E29
bytenr mismatch, want=3D35291136, have=3D16962852950865328208
checksum verify failed on 35307520 found 088ACE59 wanted 22164173
checksum verify failed on 35307520 found 088ACE59 wanted 22164173
checksum verify failed on 35307520 found F59BACEE wanted E647A1CD
checksum verify failed on 35307520 found 088ACE59 wanted 22164173
bytenr mismatch, want=3D35307520, have=3D16013504349018505369
checksum verify failed on 35323904 found CA154283 wanted 10E9FA6B
checksum verify failed on 35323904 found CA154283 wanted 10E9FA6B
checksum verify failed on 35323904 found 4DA7B234 wanted 794014C7
checksum verify failed on 35323904 found 4DA7B234 wanted 794014C7
bytenr mismatch, want=3D35323904, have=3D8533404122473270145
parent transid verify failed on 35340288 wanted 44 found 37
parent transid verify failed on 35340288 wanted 44 found 37
parent transid verify failed on 35340288 wanted 44 found 37
parent transid verify failed on 35340288 wanted 44 found 37
Ignoring transid failure
leaf parent key incorrect 35340288
bad block 35340288
Errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
parent transid verify failed on 35340288 wanted 44 found 37
Ignoring transid failure
parent transid verify failed on 35340288 wanted 44 found 37
Ignoring transid failure
parent transid verify failed on 35340288 wanted 44 found 37
Ignoring transid failure
parent transid verify failed on 35340288 wanted 44 found 37
Ignoring transid failure
checksum verify failed on 35274752 found E042416D wanted 4CD1CFA0
checksum verify failed on 35274752 found E042416D wanted 4CD1CFA0
checksum verify failed on 35274752 found E8B38F1B wanted B3F4F728
checksum verify failed on 35274752 found E042416D wanted 4CD1CFA0
bytenr mismatch, want=3D35274752, have=3D6970279768983377651
The following tree block(s) is corrupted in tree 5:
	tree block bytenr: 29425664, level: 1, node key: (258, 84, 2712298389)
root 5 inode 258 errors 200, dir isize wrong
root 5 inode 259 errors 2001, no inode item, link count wrong
	unresolved ref dir 256 index 4 namelen 7 name Xournal filetype 2 errors =
4, no inode ref
root 5 inode 260 errors 2001, no inode item, link count wrong
	unresolved ref dir 256 index 5 namelen 6 name Buffer filetype 2 errors 4=
, no inode ref
root 5 inode 262 errors 2001, no inode item, link count wrong
	unresolved ref dir 256 index 6 namelen 6 name E-book filetype 2 errors 4=
, no inode ref
root 5 inode 263 errors 2001, no inode item, link count wrong
	unresolved ref dir 256 index 7 namelen 7 name Riviste filetype 2 errors =
4, no inode ref
root 5 inode 264 errors 2001, no inode item, link count wrong
	unresolved ref dir 256 index 8 namelen 6 name Backup filetype 2 errors 4=
, no inode ref
root 5 inode 298 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 3 namelen 4 name AAAS filetype 2 errors 4, =
no inode ref
root 5 inode 299 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 4 namelen 12 name Aaron Swartz filetype 2 e=
rrors 4, no inode ref
root 5 inode 301 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 6 namelen 11 name Adam Haeder filetype 2 er=
rors 4, no inode ref
root 5 inode 302 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 7 namelen 15 name Adriano Fragano filetype =
2 errors 4, no inode ref
root 5 inode 303 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 8 namelen 17 name AgireOra Edizioni filetyp=
e 2 errors 4, no inode ref
root 5 inode 306 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 11 namelen 12 name Alex Vermeer filetype 2 =
errors 4, no inode ref
root 5 inode 309 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 14 namelen 12 name Allen Downey filetype 2 =
errors 4, no inode ref
root 5 inode 314 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 19 namelen 12 name Asher Miller filetype 2 =
errors 4, no inode ref
root 5 inode 315 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 20 namelen 34 name Australian Conservation =
Foundation filetype 2 errors 4, no inode ref
root 5 inode 317 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 22 namelen 16 name Benjamin Crowell filetyp=
e 2 errors 4, no inode ref
root 5 inode 318 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 23 namelen 17 name Bernardo Parrella filety=
pe 2 errors 4, no inode ref
root 5 inode 319 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 24 namelen 15 name Biagio Tinghino filetype=
 2 errors 4, no inode ref
root 5 inode 325 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 30 namelen 11 name Brian Czech filetype 2 e=
rrors 4, no inode ref
root 5 inode 329 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 34 namelen 6 name CASSEC filetype 2 errors =
4, no inode ref
root 5 inode 330 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 35 namelen 10 name Carl Stitz filetype 2 er=
rors 4, no inode ref
root 5 inode 331 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 36 namelen 15 name Carola Frediani filetype=
 2 errors 4, no inode ref
root 5 inode 333 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 38 namelen 15 name Carsten Dominik filetype=
 2 errors 4, no inode ref
root 5 inode 334 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 39 namelen 18 name Charles Eisenstein filet=
ype 2 errors 4, no inode ref
root 5 inode 335 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 40 namelen 12 name Chris Sakkas filetype 2 =
errors 4, no inode ref
root 5 inode 337 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 42 namelen 18 name Christoph Schiller filet=
ype 2 errors 4, no inode ref
root 5 inode 342 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 47 namelen 24 name Colleen Patrick-Goudreau=
 filetype 2 errors 4, no inode ref
root 5 inode 343 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 48 namelen 35 name Comitato per un consumo =
consapevole filetype 2 errors 4, no inode ref
root 5 inode 344 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 49 namelen 13 name Consorzio RFX filetype 2=
 errors 4, no inode ref
root 5 inode 350 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 55 namelen 17 name Daniele Giacomini filety=
pe 2 errors 4, no inode ref
root 5 inode 351 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 56 namelen 20 name Danielle Niernenberg fil=
etype 2 errors 4, no inode ref
root 5 inode 352 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 57 namelen 17 name Dave Witte Morris filety=
pe 2 errors 4, no inode ref
root 5 inode 353 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 58 namelen 15 name David A. Santos filetype=
 2 errors 4, no inode ref
root 5 inode 355 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 60 namelen 13 name David Cherney filetype 2=
 errors 4, no inode ref
root 5 inode 358 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 63 namelen 12 name David MacKay filetype 2 =
errors 4, no inode ref
root 5 inode 367 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 72 namelen 11 name Elias Zakon filetype 2 e=
rrors 4, no inode ref
root 5 inode 368 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 73 namelen 18 name Emanuele Campiglio filet=
ype 2 errors 4, no inode ref
root 5 inode 369 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 74 namelen 19 name Emily Moran Barwick file=
type 2 errors 4, no inode ref
root 5 inode 373 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 78 namelen 37 name European Fusion Developm=
ent Agreement filetype 2 errors 4, no inode ref
root 5 inode 374 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 79 namelen 13 name FLOSS Manuals filetype 2=
 errors 4, no inode ref
root 5 inode 375 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 80 namelen 32 name FOM-Institute for Plasma=
 Physics filetype 2 errors 4, no inode ref
root 5 inode 376 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 81 namelen 18 name Francesco Gesualdi filet=
ype 2 errors 4, no inode ref
root 5 inode 378 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 83 namelen 27 name Friends of the Earth Eur=
ope filetype 2 errors 4, no inode ref
root 5 inode 383 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 88 namelen 22 name Heinrich Boll Stiftung f=
iletype 2 errors 4, no inode ref
root 5 inode 384 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 89 namelen 11 name Hubble Site filetype 2 e=
rrors 4, no inode ref
root 5 inode 388 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 93 namelen 33 name International Society fo=
r Ecology filetype 2 errors 4, no inode ref
root 5 inode 389 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 94 namelen 5 name Istat filetype 2 errors 4=
, no inode ref
root 5 inode 390 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 95 namelen 37 name Istituto Nazionale di Fi=
sica Nucleare filetype 2 errors 4, no inode ref
root 5 inode 393 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 98 namelen 16 name James Kent Lewis filetyp=
e 2 errors 4, no inode ref
root 5 inode 395 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 100 namelen 10 name Jim Fowler filetype 2 e=
rrors 4, no inode ref
root 5 inode 396 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 101 namelen 12 name Jim Hefferon filetype 2=
 errors 4, no inode ref
root 5 inode 399 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 104 namelen 13 name John December filetype =
2 errors 4, no inode ref
root 5 inode 410 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 115 namelen 13 name Justin Victor filetype =
2 errors 4, no inode ref
root 5 inode 412 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 117 namelen 12 name Kate Raworth filetype 2=
 errors 4, no inode ref
root 5 inode 413 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 118 namelen 16 name Katherine Darton filety=
pe 2 errors 4, no inode ref
root 5 inode 414 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 119 namelen 12 name Keith Curtis filetype 2=
 errors 4, no inode ref
root 5 inode 415 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 120 namelen 13 name Kevin Houston filetype =
2 errors 4, no inode ref
root 5 inode 416 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 121 namelen 14 name Lars Wirzenius filetype=
 2 errors 4, no inode ref
root 5 inode 417 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 122 namelen 11 name Leo Babauta filetype 2 =
errors 4, no inode ref
root 5 inode 418 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 123 namelen 15 name Lester R. Brown filetyp=
e 2 errors 4, no inode ref
root 5 inode 419 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 124 namelen 14 name Lindsay Wilson filetype=
 2 errors 4, no inode ref
root 5 inode 420 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 125 namelen 11 name Linup Front filetype 2 =
errors 4, no inode ref
root 5 inode 421 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 126 namelen 16 name Lorenzo Pantieri filety=
pe 2 errors 4, no inode ref
root 5 inode 423 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 128 namelen 15 name Luciano Battaia filetyp=
e 2 errors 4, no inode ref
root 5 inode 424 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 129 namelen 15 name Lydia Pintscher filetyp=
e 2 errors 4, no inode ref
root 5 inode 425 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 130 namelen 14 name Magnus Vinding filetype=
 2 errors 4, no inode ref
root 5 inode 426 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 131 namelen 18 name Manuel Castelletti file=
type 2 errors 4, no inode ref
root 5 inode 427 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 132 namelen 16 name Marco Degiovanni filety=
pe 2 errors 4, no inode ref
root 5 inode 429 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 134 namelen 16 name Marijn Haverbeke filety=
pe 2 errors 4, no inode ref
root 5 inode 430 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 135 namelen 13 name Marina Berati filetype =
2 errors 4, no inode ref
root 5 inode 433 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 138 namelen 12 name Mark Pilgrim filetype 2=
 errors 4, no inode ref
root 5 inode 438 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 143 namelen 16 name Massimo Ubertini filety=
pe 2 errors 4, no inode ref
root 5 inode 440 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 145 namelen 16 name Matthew Boelkins filety=
pe 2 errors 4, no inode ref
root 5 inode 442 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 147 namelen 17 name Maurizio Pallante filet=
ype 2 errors 4, no inode ref
root 5 inode 453 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 158 namelen 4 name Mind filetype 2 errors 4=
, no inode ref
root 5 inode 455 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 160 namelen 4 name NASA filetype 2 errors 4=
, no inode ref
root 5 inode 458 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 163 namelen 24 name New Economics Foundatio=
n filetype 2 errors 4, no inode ref
root 5 inode 459 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 164 namelen 16 name OpenStax College filety=
pe 2 errors 4, no inode ref
root 5 inode 460 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 165 namelen 5 name Oxfam filetype 2 errors =
4, no inode ref
root 5 inode 461 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 166 namelen 12 name P. D. Magnus filetype 2=
 errors 4, no inode ref
root 5 inode 463 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 168 namelen 15 name Paul N. Edwards filetyp=
e 2 errors 4, no inode ref
root 5 inode 466 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 171 namelen 21 name Post Carbon Institute f=
iletype 2 errors 4, no inode ref
root 5 inode 467 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 172 namelen 24 name Ravishankar Somasundara=
m filetype 2 errors 4, no inode ref
root 5 inode 469 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 174 namelen 17 name Regione Lombardia filet=
ype 2 errors 4, no inode ref
root 5 inode 474 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 179 namelen 16 name Richard Heinberg filety=
pe 2 errors 4, no inode ref
root 5 inode 477 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 182 namelen 16 name Richard Stallman filety=
pe 2 errors 4, no inode ref
root 5 inode 480 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 185 namelen 16 name Robert A. Beezer filety=
pe 2 errors 4, no inode ref
root 5 inode 482 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 187 namelen 15 name Robert Goodland filetyp=
e 2 errors 4, no inode ref
root 5 inode 486 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 191 namelen 16 name Samuel Alexander filety=
pe 2 errors 4, no inode ref
root 5 inode 487 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 192 namelen 11 name Sara Seager filetype 2 =
errors 4, no inode ref
root 5 inode 489 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 194 namelen 12 name Scott Chacon filetype 2=
 errors 4, no inode ref
root 5 inode 491 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 196 namelen 19 name Sense About Science fil=
etype 2 errors 4, no inode ref
root 5 inode 492 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 197 namelen 27 name Share the World's Resou=
rces filetype 2 errors 4, no inode ref
root 5 inode 493 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 198 namelen 16 name Simone Aliprandi filety=
pe 2 errors 4, no inode ref
root 5 inode 494 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 199 namelen 15 name Stefan Kottwitz filetyp=
e 2 errors 4, no inode ref
root 5 inode 502 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 207 namelen 34 name Sustainable Development=
 Commission filetype 2 errors 4, no inode ref
root 5 inode 504 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 209 namelen 13 name Ted Sundstrom filetype =
2 errors 4, no inode ref
root 5 inode 505 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 210 namelen 13 name Terry Hancock filetype =
2 errors 4, no inode ref
root 5 inode 506 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 211 namelen 24 name The Climate Mobilizatio=
n filetype 2 errors 4, no inode ref
root 5 inode 507 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 212 namelen 19 name The Gaia Foundation fil=
etype 2 errors 4, no inode ref
root 5 inode 508 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 213 namelen 28 name The New Economics Found=
ation filetype 2 errors 4, no inode ref
root 5 inode 509 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 214 namelen 17 name The Royal Society filet=
ype 2 errors 4, no inode ref
root 5 inode 510 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 215 namelen 24 name The Worldwatch Institut=
e filetype 2 errors 4, no inode ref
root 5 inode 512 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 217 namelen 14 name Thomas Tradler filetype=
 2 errors 4, no inode ref
root 5 inode 513 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 218 namelen 14 name Tobias Oetiker filetype=
 2 errors 4, no inode ref
root 5 inode 514 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 219 namelen 9 name Tom Blees filetype 2 err=
ors 4, no inode ref
root 5 inode 516 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 221 namelen 7 name Unknown filetype 2 error=
s 4, no inode ref
root 5 inode 518 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 223 namelen 14 name Vegan Outreach filetype=
 2 errors 4, no inode ref
root 5 inode 519 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 224 namelen 9 name VeganHome filetype 2 err=
ors 4, no inode ref
root 5 inode 520 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 225 namelen 3 name WWF filetype 2 errors 4,=
 no inode ref
root 5 inode 523 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 228 namelen 19 name William A. R. Weiss fil=
etype 2 errors 4, no inode ref
root 5 inode 524 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 229 namelen 14 name William Shotts filetype=
 2 errors 4, no inode ref
root 5 inode 525 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 230 namelen 16 name World Beyond War filety=
pe 2 errors 4, no inode ref
root 5 inode 1753 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Alan J. Sangster filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 1756 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Alexandru Buium filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1757 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Ali Almossawi filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1760 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Andrew Burgess filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1762 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Andrew T. Guzman filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 1763 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Annie Leonard filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1766 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Antonio Scuglia filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1767 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Armin Navabi filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1768 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name B. S. Vatsa filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 1769 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 9 name Ben Forta filetype 2 error=
s 6, no dir index, no inode ref
root 5 inode 1771 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 9 name Ben Moore filetype 2 error=
s 6, no dir index, no inode ref
root 5 inode 1772 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 10 name Ben Rogers filetype 2 err=
ors 6, no dir index, no inode ref
root 5 inode 1773 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Bill Mckibben filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1774 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 17 name Bjarne Stroustrup filetyp=
e 2 errors 6, no dir index, no inode ref
root 5 inode 1776 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 9 name Brian Cox filetype 2 error=
s 6, no dir index, no inode ref
root 5 inode 1777 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Brian E. Blank filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1778 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Brian Kernighan filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1779 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Brian Overland filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1780 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 10 name Brian Ward filetype 2 err=
ors 6, no dir index, no inode ref
root 5 inode 1783 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Carlo Gubitosa filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1784 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Carlo Rovelli filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1787 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Cay Horstmann filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1790 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Charles Fletcher filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 1791 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Charles Saylan filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1792 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Chicco Testa filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1793 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Chris Goodall filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1794 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name Chris Impey filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 1795 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Chris Martenson filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1796 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Chris Williams filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1799 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Claudio Canuto filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1800 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Clive Hamilton filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1802 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 21 name Constance Lever-Tracy fil=
etype 2 errors 6, no dir index, no inode ref
root 5 inode 1803 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Curtis Gedak filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1804 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Cynthia Y. Young filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 1805 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name D. P. Acharjya filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1806 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Dale Jamieson filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1809 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Daniel Berleant filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1810 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 19 name Daniel C. Alexander filet=
ype 2 errors 6, no dir index, no inode ref
root 5 inode 1811 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Daniel Rosenthal filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 1814 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Dave Goldberg filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1816 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name David Allen filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 1817 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name David Archer filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1818 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name David Buchan filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1819 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name David Makinson filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1820 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 10 name David Owen filetype 2 err=
ors 6, no dir index, no inode ref
root 5 inode 1822 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 21 name Deborah Hughes-Hallet fil=
etype 2 errors 6, no dir index, no inode ref
root 5 inode 1823 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 22 name Deborah Hughes-Hallett fi=
letype 2 errors 6, no dir index, no inode ref
root 5 inode 1825 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 17 name Donald R. Liddick filetyp=
e 2 errors 6, no dir index, no inode ref
root 5 inode 1827 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 17 name Douglas A. Vakoch filetyp=
e 2 errors 6, no dir index, no inode ref
root 5 inode 1830 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 17 name Earl W. Swokowski filetyp=
e 2 errors 6, no dir index, no inode ref
root 5 inode 1831 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 9 name Ed Tittel filetype 2 error=
s 6, no dir index, no inode ref
root 5 inode 1832 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 25 name Edzard Ernst, Simon Singh=
 filetype 2 errors 6, no dir index, no inode ref
root 5 inode 1833 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 20 name Elaine Iljon Foreman file=
type 2 errors 6, no dir index, no inode ref
root 5 inode 1834 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Elizabeth Castro filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 1835 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Elizabeth May filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1836 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 17 name Elliott Mendelson filetyp=
e 2 errors 6, no dir index, no inode ref
root 5 inode 1839 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Eric Chaisson filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1840 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Erik Seedhouse filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1841 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 21 name Ferdinando Santacroce fil=
etype 2 errors 6, no dir index, no inode ref
root 5 inode 1842 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 23 name Fernando J. Ballesteros f=
iletype 2 errors 6, no dir index, no inode ref
root 5 inode 1843 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 20 name Filipe Duarte Santos file=
type 2 errors 6, no dir index, no inode ref
root 5 inode 1844 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Francis F. Chen filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1845 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 22 name Francis Mark Mondimore fi=
letype 2 errors 6, no dir index, no inode ref
root 5 inode 1846 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Frank Ackerman filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1848 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Fred Magdoff filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1849 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name G. Tyler Miller filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1850 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Gabriele Lolli filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1852 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Gary J. Bronson filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1854 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name George Gratzer filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1857 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 18 name Gianfranco Bertone filety=
pe 2 errors 6, no dir index, no inode ref
root 5 inode 1858 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Glenn Greenwald filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1861 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Hal Marcovitz filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1865 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Hermann Scheer filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1867 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 8 name Ian Lunn filetype 2 errors=
 6, no dir index, no inode ref
root 5 inode 1868 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name Ivor Horton filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 1869 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 19 name J. Glenn Brookshear filet=
ype 2 errors 6, no dir index, no inode ref
root 5 inode 1871 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name James A. Dator filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1872 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name James Barrat filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1873 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name James Hansen filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1875 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Jamie Bartlett filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1876 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Jean Gallier filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1877 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Jearl Walker filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1880 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Jeremy Rifkin filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1881 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 18 name Jerome E. Kaufmann filety=
pe 2 errors 6, no dir index, no inode ref
root 5 inode 1882 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Jim DeFranza filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1883 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 10 name John Forge filetype 2 err=
ors 6, no dir index, no inode ref
root 5 inode 1884 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name John Gribbin filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1885 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 18 name John Michael Greer filety=
pe 2 errors 6, no dir index, no inode ref
root 5 inode 1886 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 17 name John Paul Mueller filetyp=
e 2 errors 6, no dir index, no inode ref
root 5 inode 1887 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name John Pollock filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1888 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name John S. Conery filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1889 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name John W. Coburn filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1891 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Jose Goldemberg filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1892 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 18 name Joseph M. Siracusa filety=
pe 2 errors 6, no dir index, no inode ref
root 5 inode 1893 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 19 name Juan Jorge Schaffer filet=
ype 2 errors 6, no dir index, no inode ref
root 5 inode 1894 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Julie C. Meloni filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1895 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Julie Miller filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1896 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Katie Cunningham filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 1899 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name Kent D. Lee filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 1900 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Kevin Ferland filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1901 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Kevin Houston filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1902 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Kuldeep Singh filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1903 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Kyle Forinash filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1904 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Lajos Kovacs filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1905 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Larry E. Knop filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1906 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Lee Billings filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1909 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Lewis Dartnell filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1910 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Linda Gilbert filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1911 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name Linux Voice filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 1915 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Luca Codignola filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1916 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Mara Prentiss filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1919 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Margherita Hack filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1920 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Mark Diesendorf filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1923 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Mark Miodownik filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1924 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 9 name Mark Ryan filetype 2 error=
s 6, no dir index, no inode ref
root 5 inode 1925 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Marq De Villiers filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 1928 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 18 name Martin L. Weitzman filety=
pe 2 errors 6, no dir index, no inode ref
root 5 inode 1929 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 19 name Marvin L. Bittinger filet=
ype 2 errors 6, no dir index, no inode ref
root 5 inode 1931 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 9 name Matt West filetype 2 error=
s 6, no dir index, no inode ref
root 5 inode 1932 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Matthew Hedman filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1934 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Michael Carroll filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1935 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 22 name Michael D. Mastrandrea fi=
letype 2 errors 6, no dir index, no inode ref
root 5 inode 1936 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 17 name Michael Huesemann filetyp=
e 2 errors 6, no dir index, no inode ref
root 5 inode 1937 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Michael Sullivan filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 1939 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name Naomi Klein filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 1945 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Norm Christensen filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 1948 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Ozzie Zehner filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1949 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 19 name Patricia D. Netzley filet=
ype 2 errors 6, no dir index, no inode ref
root 5 inode 1950 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Patrick Jones filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1951 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 31 name Patrick Moriarty, Damon H=
onnery filetype 2 errors 6, no dir index, no inode ref
root 5 inode 1954 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Paul S. Wang filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1955 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 9 name Paul Zorn filetype 2 error=
s 6, no dir index, no inode ref
root 5 inode 1956 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Peggy J. Parks filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1958 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Peter D. Lax filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1959 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Peter E. Hodgson filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 1960 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Peter H. Raven filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1965 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 17 name Richard A. Muller filetyp=
e 2 errors 6, no dir index, no inode ref
root 5 inode 1966 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Richard Dawkins filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1967 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Richard Heinberg filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 1968 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 18 name Richard N. Aufmann filety=
pe 2 errors 6, no dir index, no inode ref
root 5 inode 1969 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Richard Reese filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1971 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Robert Curley filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1972 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Roberto Bermejo filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1975 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 10 name Ron Larson filetype 2 err=
ors 6, no dir index, no inode ref
root 5 inode 1976 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name Roz Shafran filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 1977 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 17 name Rutger Van Santen filetyp=
e 2 errors 6, no dir index, no inode ref
root 5 inode 1978 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Ryan Stephens filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1979 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name S. C. Hitchcock filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1980 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name S. Ponnusamy filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1981 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Save Goldberg filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1982 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Scott Mueller filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 1983 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Seth Shostak filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 1984 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Shantanu Tushar filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 1988 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 18 name Stephen M. Tomecek filety=
pe 2 errors 6, no dir index, no inode ref
root 5 inode 1992 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Steven G. Krantz filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 1993 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Steven J. Leon filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1994 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Stuart A. Kallen filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 1995 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Stuart Yarnold filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 1997 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name Ted Trainer filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 1999 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 20 name Thomas W. Hungerford file=
type 2 errors 6, no dir index, no inode ref
root 5 inode 2000 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Tim Di Muzio filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 2002 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 18 name Timothy Paul Smith filety=
pe 2 errors 6, no dir index, no inode ref
root 5 inode 2003 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name Tom Jenkyns filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 2009 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 7 name Unknown filetype 2 errors =
6, no dir index, no inode ref
root 5 inode 2011 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name Ward Wilson filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 2012 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name William Nordhaus filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 2014 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Y. Daniel Liang filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 2015 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Yves Biollay filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 4005 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Alexei White filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 4007 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 10 name Andrew Rex filetype 2 err=
ors 6, no dir index, no inode ref
root 5 inode 4008 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Antonio Zoppetti filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 4009 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name Bill Bryson filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 4010 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Bill Lubanovic filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 4011 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Bruce Sutherland filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 4012 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name Buzz Aldrin filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 4013 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Chris Sidwells filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 4014 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 19 name Christopher Schmitt filet=
ype 2 errors 6, no dir index, no inode ref
root 5 inode 4016 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 10 name Craig Cook filetype 2 err=
ors 6, no dir index, no inode ref
root 5 inode 4018 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 2 name DK filetype 2 errors 6, no=
 dir index, no inode ref
root 5 inode 4020 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 21 name Edward R. Scheinerman fil=
etype 2 errors 6, no dir index, no inode ref
root 5 inode 4022 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 18 name George S. Tselikis filety=
pe 2 errors 6, no dir index, no inode ref
root 5 inode 4023 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Gerard 't Hooft filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 4024 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Lucas John Mix filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 4026 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Richard Blum filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 4027 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name Richard Fox filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 4029 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Wheeler M. Sears filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 4223 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Dennis Bailey filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 4224 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Richard Stallman filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 4226 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 17 name Yuval Noah Harari filetyp=
e 2 errors 6, no dir index, no inode ref
root 5 inode 4298 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Amedeo Balbi filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 4299 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 8 name Bill Nye filetype 2 errors=
 6, no dir index, no inode ref
root 5 inode 4300 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 20 name Cynthia Stokes Brown file=
type 2 errors 6, no dir index, no inode ref
root 5 inode 4301 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name David Suzuki filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 4302 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 12 name Duncan Clark filetype 2 e=
rrors 6, no dir index, no inode ref
root 5 inode 4303 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 17 name Erik Brynjolfsson filetyp=
e 2 errors 6, no dir index, no inode ref
root 5 inode 4304 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 10 name Fred Spier filetype 2 err=
ors 6, no dir index, no inode ref
root 5 inode 4305 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Hugh D. Young filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 4306 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 17 name J. Douglas Faires filetyp=
e 2 errors 6, no dir index, no inode ref
root 5 inode 4308 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name Joseph Romm filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 4310 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Mark Dugopolski filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 4311 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 10 name Mark Lynas filetype 2 err=
ors 6, no dir index, no inode ref
root 5 inode 4313 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Mauro Bonaiuti filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 4314 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Mickey Petersen filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 4316 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Neil A. Fiore filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 4317 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 33 name Raymond A. Serway, John W=
=2E Jewett filetype 2 errors 6, no dir index, no inode ref
root 5 inode 4319 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Stephen Emmott filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 4320 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Susan Freinkel filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 4436 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 249 namelen 11 name metadata.db filetype 1 =
errors 4, no inode ref
root 5 inode 4437 errors 2001, no inode item, link count wrong
	unresolved ref dir 257 index 251 namelen 29 name metadata_db_prefs_backu=
p.json filetype 1 errors 4, no inode ref
root 5 inode 4438 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 20 name A. C. Fischer Cripps file=
type 2 errors 6, no dir index, no inode ref
root 5 inode 4442 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Barrie W. Jones filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 4443 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Carolyn Wheater filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 4444 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Clay A. Johnson filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 4446 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name David Garfinkle filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 4447 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name Don Lincoln filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 4448 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Elaine Scarry filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 4449 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Erik Gregersen filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 4454 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 9 name Joel Hass filetype 2 error=
s 6, no dir index, no inode ref
root 5 inode 4456 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 19 name John Graham Cumming filet=
ype 2 errors 6, no dir index, no inode ref
root 5 inode 4457 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name John Horgan filetype 2 er=
rors 6, no dir index, no inode ref
root 5 inode 4462 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Marsha Collier filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 4467 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 20 name Monica Ramirez Basco file=
type 2 errors 6, no dir index, no inode ref
root 5 inode 4471 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Peter Meszaros filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 4474 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Rob Hengeveld filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 4475 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Robert Blitzer filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 4476 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 16 name Robert Hargraves filetype=
 2 errors 6, no dir index, no inode ref
root 5 inode 4477 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Sarah L. Burch filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 4478 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 9 name Sean Lang filetype 2 error=
s 6, no dir index, no inode ref
root 5 inode 4479 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 14 name Stephen Abbott filetype 2=
 errors 6, no dir index, no inode ref
root 5 inode 4481 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 15 name Stephen Hawking filetype =
2 errors 6, no dir index, no inode ref
root 5 inode 4482 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 13 name Sylvia Forman filetype 2 =
errors 6, no dir index, no inode ref
root 5 inode 4496 errors 2001, no inode item, link count wrong
	unresolved ref dir 258 index 0 namelen 11 name metadata.db filetype 1 er=
rors 6, no dir index, no inode ref
found 35578380288 bytes used err is 1
total csum bytes: 0
total tree bytes: 1736704
total fs tree bytes: 1179648
total extent tree bytes: 507904
btree space waste bytes: 550073
file data blocks allocated: 7687172096
 referenced 7687172096

--------------9EBF33F312BA62FF22FBF1BE--
