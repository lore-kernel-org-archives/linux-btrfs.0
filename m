Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBA9C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 22:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A691217F5
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 22:13:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mokrynskyi.com header.i=@mokrynskyi.com header.b="FhXmxo3Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfACWNc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 17:13:32 -0500
Received: from mx.mokrynskyi.com ([46.4.12.50]:32788 "EHLO mx.mokrynskyi.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728281AbfACWNb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 17:13:31 -0500
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2019 17:13:30 EST
Received: from localhost (localhost [127.0.0.1])
        by mx.mokrynskyi.com (Postfix) with ESMTP id 7EE1D2A3A
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 22:06:19 +0000 (UTC)
Authentication-Results: mx.mokrynskyi.com (amavisd-new);
        dkim=pass (1024-bit key) reason="pass (just generated, assumed good)"
        header.d=mokrynskyi.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mokrynskyi.com;
         h=content-transfer-encoding:content-language:content-type
        :content-type:mime-version:user-agent:date:date:message-id
        :organization:subject:subject:from:from:to; s=dkim; t=
        1546553179; x=1547417180; bh=127wiAVoLEBQ3GWhC6f4RCuKNRmFiuz5GZ7
        p10rR3TI=; b=FhXmxo3ZXI3+OnOvphgckiN8jxG/UDcVYDJywcf5llP0hlxDje9
        o6K8nqM2E10dNh5vbywSDZE/a3tTBc7GgUw1dK9nb4nuV39LIJLsr5EnP4D5msqr
        yFmhaOsyf/a0sFCO6KYQ31fTOiKJU9p+65ICgFkyzL5wpiQYbHc0S5RU=
X-Virus-Scanned: Debian amavisd-new at mx.mokrynskyi.com
Received: from mx.mokrynskyi.com ([127.0.0.1])
        by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vrDzaVlt9NcH for <linux-btrfs@vger.kernel.org>;
        Thu,  3 Jan 2019 22:06:19 +0000 (UTC)
Received: from [192.168.1.2] (bomann.znet.kiev.ua [176.122.88.128])
        by mx.mokrynskyi.com (Postfix) with ESMTPSA id EB2612A37
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 22:06:18 +0000 (UTC)
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
From:   Nazar Mokrynskyi <nazar@mokrynskyi.com>
Subject: Unrecoverable btrfs corruption (backref bytes do not match extent
 backref)
Organization: CleverStyle, Ecoisme
Message-ID: <73e828f0-057c-830e-a6b2-570dccbdf484@mokrynskyi.com>
Date:   Fri, 4 Jan 2019 00:06:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:65.0) Gecko/20100101
 Thunderbird/65.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: uk
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Today I have faced yet another BTRFS corruption, the only major software =
change in recent days was upgrade to Linux 4.20, so this is something to =
keep in mind.
Previous corruption happened with kernel 4.14 a bit over a year ago I thi=
nk, so filesystem was with high probability created in December 2017.

This time I saved an image of corrupted partition, so I can make more exp=
eriments with it.

A bit of history:
1) several days ago I was running scrub and found some inode errors, it b=
oiled down to /var/lib/mysql/ibdata1 file (/var/lib/mysql have CoW disabl=
ed), so I've replaced that file with file from backup, made fresh snapsho=
t and removed old snapshots that had corrupted file in it, scrub was happ=
y after that
2) today everything worked fine until on reboot system booted into initra=
mfs complaining about something with btrfs...

My setup: BTRFS under full-disk LUKS, no partition table:
/dev/mapper/system / btrfs compress=3Dlzo,noatime,ssd,subvol=3D/root 0 1

btrfs-progs v4.19.1, Ubuntu 19.04 (develoment branch with proposed packag=
es enabled), kernel 4.20.0 with ACS override patch

After inspection turned out that scrub is still perfectly fine, no compla=
ins, however:

root@ubuntu:~# btrfsck /dev/mapper/luks-739967f1-9770-470a-a031-8d8b8bcdb=
350
warning, bad space info total_bytes 2155872256 used 2155876352
warning, bad space info total_bytes 3229614080 used 3229618176
warning, bad space info total_bytes 4303355904 used 4303360000
warning, bad space info total_bytes 5377097728 used 5377101824
warning, bad space info total_bytes 6450839552 used 6450843648
warning, bad space info total_bytes 7524581376 used 7524585472
warning, bad space info total_bytes 8598323200 used 8598327296
warning, bad space info total_bytes 9672065024 used 9672069120
warning, bad space info total_bytes 10745806848 used 10745810944
warning, bad space info total_bytes 11819548672 used 11819552768
warning, bad space info total_bytes 12893290496 used 12893294592
warning, bad space info total_bytes 13967032320 used 13967036416
warning, bad space info total_bytes 15040774144 used 15040778240
warning, bad space info total_bytes 16114515968 used 16114520064
warning, bad space info total_bytes 17188257792 used 17188261888
warning, bad space info total_bytes 18261999616 used 18262003712
warning, bad space info total_bytes 19335741440 used 19335745536
warning, bad space info total_bytes 20409483264 used 20409487360
warning, bad space info total_bytes 21483225088 used 21483229184
warning, bad space info total_bytes 22556966912 used 22556971008
warning, bad space info total_bytes 23630708736 used 23630712832
warning, bad space info total_bytes 24704450560 used 24704454656
warning, bad space info total_bytes 25778192384 used 25778196480
warning, bad space info total_bytes 26851934208 used 26851938304
warning, bad space info total_bytes 27925676032 used 27925680128
warning, bad space info total_bytes 28999417856 used 28999421952
warning, bad space info total_bytes 30073159680 used 30073163776
warning, bad space info total_bytes 31146901504 used 31146905600
warning, bad space info total_bytes 32220643328 used 32220647424
Checking filesystem on /dev/mapper/luks-739967f1-9770-470a-a031-8d8b8bcdb=
350
UUID: 5170aca4-061a-4c6c-ab00-bd7fc8ae6030
checking extents
extent item 3114475520 has multiple extent items
ref mismatch on [3114475520 4096] extent item 1, found 2
backref bytes do not match extent backref, bytenr=3D3114475520, ref bytes=
=3D4096, backref bytes=3D36864
backpointer mismatch on [3114475520 4096]
ERROR: errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
checking csums
checking root refs
found 39409483813 bytes used, error(s) found
total csum bytes: 35990412
total tree bytes: 2395095040
total fs tree bytes: 2249408512
total extent tree bytes: 96534528
btree space waste bytes: 456622616
file data blocks allocated: 174319587328
=C2=A0referenced 61677670400

I've removed all secondary subvolumes (like for Docker) and snapshots, bu=
t issue persisted.

Then I've tried `btrfs balance` and it failed at around 10-20% remaining.

I think after that scrub started complaining about errors or just stop in=
creasing scrub progress.

This is where I made 256G partition image.

Since I have proper backups, I gave `btrfsck --repair` a try just in case=
 it does anything useful at least once, but it just repeatedly prints fol=
lowing without any meaningful CPU or disk activity:

ref mismatch on [3114475520 36864] extent item 1, found 2
backref bytes do not match extent backref, bytenr=3D3114475520, ref bytes=
=3D36864, backref bytes=3D4096
backpointer mismatch on [3114475520 36864]
attempting to repair backref discrepency for bytenr 3114475520

The actual corruption happened in /docker subvolume somewhere amongst reg=
ular files. I get segfaults when I try to do anything there, sometimes ke=
rnel can lock up. Other files seem to be perfectly fine.

Removing /docker subvolume locked the kernel if I recall correctly.


If this seems anything important and you want me to run some commands to =
check what happened exactly, I can start VMs with this partition image co=
nnected and do whatever is needed. I can't send image anywhere though, si=
nce it contains sensitive information.

NOTE: I don't need help with partition or data recovery, I'm used to thes=
e kinds of crashes and have backups, so no data were lost.

P.S. I really wish BTRFS can stop accidentally corrupting itself one day.

--=20
Sincerely, Nazar Mokrynskyi
github.com/nazar-pc

