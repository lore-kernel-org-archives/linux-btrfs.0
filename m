Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:36323 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbcCBKrj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 05:47:39 -0500
Received: by mail-yw0-f180.google.com with SMTP id e63so172873271ywc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Mar 2016 02:47:39 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 2 Mar 2016 10:47:38 +0000
Message-ID: <CAGTZdkyxxjfTP+1Ej-vpmMr7zRU7S_WHDQVzL1AcCe0iSQVx=w@mail.gmail.com>
Subject: BTRFS Raid 6 corruption - please help with restore
From: Stuart Gittings <gittings.s@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi - I have some corruption on a 12 drive Raid 6 volume.  Here's the
basics - if someone could help with restore it would save me a ton of
time (and some data loss - I have critical data backed up, but not
all).

stuart@debian:~$ uname -a
Linux debian 4.3.0-0.bpo.1-amd64 #1 SMP Debian 4.3.3-7~bpo8+1
(2016-01-19) x86_64 GNU/Linux

stuart@debian:~$ sudo btrfs --version
btrfs-progs v4.4

 sudo btrfs fi sh
Label: none  uuid: 7f994e11-e146-4dee-80f0-c16ac3073e91
        Total devices 12 FS bytes used 14.25TiB
        devid    1 size 2.73TiB used 167.14GiB path /dev/sdc
        devid    2 size 5.46TiB used 1.75TiB path /dev/sdd
        devid    3 size 5.46TiB used 1.75TiB path /dev/sde
        devid    4 size 2.73TiB used 167.14GiB path /dev/sdn
        devid    5 size 5.46TiB used 1.75TiB path /dev/sdf
        devid    6 size 2.73TiB used 1.75TiB path /dev/sdm
        devid    9 size 2.73TiB used 1.75TiB path /dev/sdj
        devid   10 size 2.73TiB used 1.75TiB path /dev/sdi
        devid   11 size 2.73TiB used 1.75TiB path /dev/sdg
        devid   13 size 2.73TiB used 1.75TiB path /dev/sdl
        devid   14 size 2.73TiB used 1.75TiB path /dev/sdk
        devid   15 size 2.73TiB used 1.75TiB path /dev/sdh

sudo mount -t btrfs -oro,recover /dev/sdc /data
mount: wrong fs type, bad option, bad superblock on /dev/sdc,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

dmesg:

[ 5642.118303] BTRFS info (device sdc): enabling auto recovery
[ 5642.118313] BTRFS info (device sdc): disk space caching is enabled
[ 5642.118316] BTRFS: has skinny extents
[ 5642.130145] btree_readpage_end_io_hook: 39 callbacks suppressed
[ 5642.130148] BTRFS (device sdc): bad tree block start
13629298965300190098 47255853072384
[ 5642.130759] BTRFS (device sdc): bad tree block start
10584834564968318131 47255853105152
[ 5642.131289] BTRFS (device sdc): bad tree block start
2775635947161390306 47255853121536
[ 5644.730012] BTRFS: bdev /dev/sdc errs: wr 1664846, rd 210656, flush
18054, corrupt 0, gen 0
[ 5644.801291] BTRFS (device sdc): bad tree block start
8578409561856120450 47254279438336
[ 5644.801304] BTRFS (device sdc): bad tree block start
18087369170870825197 47254279454720
[ 5644.831199] BTRFS (device sdc): bad tree block start
9721403008164124267 47254277718016
[ 5644.842763] BTRFS (device sdc): bad tree block start
18087369170870825197 47254279454720
[ 5644.891992] BTRFS (device sdc): bad tree block start
17582844917171188859 47254194176000
[ 5644.951366] BTRFS (device sdc): bad tree block start
3962496226683925584 47254278586368
[ 5645.097168] BTRFS (device sdc): bad tree block start
17049293152820168762 47255619846144
[ 5646.159819] BTRFS: Failed to read block groups: -5
[ 5646.215905] BTRFS: open_ctree failed
stuart@debian:~$

Finally:
 sudo btrfs restore /dev/sdc /backup
checksum verify failed on 47255853072384 found 70F58CCA wanted AE18D5BC
checksum verify failed on 47255853072384 found 70F58CCA wanted AE18D5BC
checksum verify failed on 47255853072384 found 805B1FF7 wanted B76A652F
checksum verify failed on 47255853072384 found 70F58CCA wanted AE18D5BC
bytenr mismatch, want=47255853072384, have=13629298965300190098
Couldn't read chunk tree
Could not open root, trying backup super
warning, device 3 is missing
warning, device 2 is missing
warning, device 5 is missing
warning, device 4 is missing
bytenr mismatch, want=47255851761664, have=47255851958272
Couldn't read chunk root
Could not open root, trying backup super
warning, device 3 is missing
warning, device 2 is missing
warning, device 5 is missing
warning, device 4 is missing
bytenr mismatch, want=47255851761664, have=47255851958272
Couldn't read chunk root
Could not open root, trying backup super

Thanks in advance to anyone who might be able to suggest ideas.

Stuart
