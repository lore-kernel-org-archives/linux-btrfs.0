Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:44659 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3ASWxI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jan 2013 17:53:08 -0500
Received: by mail-pb0-f44.google.com with SMTP id uo1so2668217pbc.17
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Jan 2013 14:53:08 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 19 Jan 2013 19:53:08 -0300
Message-ID: <CAPVzhpyj8oXMGyoPop6FadcDRAyDTmvX7VPncBLo0wuUOKxvwA@mail.gmail.com>
Subject: btrfs: failed to read chunk tree on vde1 (f18 anaconda crash)
From: Reartes Guillermo <rtguille@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I reported a bug to anaconda (rhbz 901905), but it might be btfs related.

Anaconda does this:

18:49:10,317 INFO program: Running... mkfs.btrfs --data=single
--label=fedora /dev/vdb1 /dev/vdc1 /dev/vdd1 /dev/vde1
18:49:10,742 INFO program:
18:49:10,746 INFO program: WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
18:49:10,746 INFO program: WARNING! - see http://btrfs.wiki.kernel.org
before using
18:49:10,748 INFO program:
18:49:10,749 INFO program: SMALL VOLUME: forcing mixed metadata/data groups
18:49:10,750 INFO program: Created a data/metadata chunk of size 8388608
18:49:10,750 INFO program: adding device /dev/vdc1 id 2
18:49:10,751 INFO program: adding device /dev/vdd1 id 3
18:49:10,752 INFO program: adding device /dev/vde1 id 4
18:49:10,752 INFO program: fs created label fedora on /dev/vdb1
18:49:10,753 INFO program:      nodesize 4096 leafsize 4096 sectorsize
4096 size 2.93GB
18:49:10,754 INFO program: Btrfs Btrfs v0.19
18:49:10,987 INFO program: Running... udevadm settle --timeout=300
18:49:11,007 INFO program: Running... udevadm settle --timeout=300
18:49:11,036 INFO program: Running... udevadm settle --timeout=300
18:49:11,070 INFO program: Running... udevadm settle --timeout=300
21:49:11,121 INFO program: Running... /bin/mount -n -t btrfs -o
defaults /dev/vdb1 /tmp/btrfs-tmp.5205bBZQ
21:49:11,135 ERR program: mount: wrong fs type, bad option, bad
superblock on /dev/vdb1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so

In the syslog file this is shown:

21:49:10,371 INFO kernel:[  435.624404] device label fedora devid 1
transid 3 /dev/vdb1
21:49:10,371 INFO kernel:[  435.624720] device label fedora devid 1
transid 3 /dev/vdb1
21:49:10,385 INFO kernel:[  435.638653] device label fedora devid 1
transid 3 /dev/vdb1
21:49:10,396 INFO kernel:[  435.649839] device label fedora devid 2
transid 3 /dev/vdc1
21:49:10,404 INFO kernel:[  435.657442] device label fedora devid 3
transid 3 /dev/vdd1
21:49:10,434 INFO kernel:[  435.687677] device label fedora devid 4
transid 3 /dev/vde1
21:49:10,746 INFO kernel:[  435.999309] device label fedora devid 1
transid 4 /dev/vdb1
21:49:10,918 INFO kernel:[  436.171992] device label fedora devid 3
transid 4 /dev/vdd1
21:49:10,925 INFO kernel:[  436.178937] device label fedora devid 3
transid 4 /dev/vdd1
21:49:10,928 INFO kernel:[  436.181545] device label fedora devid 4
transid 4 /dev/vde1
21:49:10,929 INFO kernel:[  436.182475] device label fedora devid 1
transid 4 /dev/vdc1
21:49:10,930 INFO kernel:[  436.183409] device label fedora devid 4
transid 4 /dev/vde1
21:49:10,932 INFO kernel:[  436.185171] device label fedora devid 1
transid 4 /dev/vdc1
21:49:10,971 INFO kernel:[  436.224843] device label fedora devid 1
transid 4 /dev/vdb1
21:49:11,130 INFO kernel:[  436.383110] device label fedora devid 1
transid 4 /dev/vdb1
21:49:11,133 INFO kernel:[  436.386297] btrfs: disk space caching is enabled
21:49:11,133 WARNING kernel:[  436.386697] btrfs: failed to read chunk
tree on vde1
21:49:11,134 WARNING kernel:[  436.387183] btrfs: open_ctree failed

I booted again and did both the mk.btrfs and the mount manually and i
got the same error.

Is it a known issue?

Thanks in advance.
