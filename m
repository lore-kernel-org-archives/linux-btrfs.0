Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-07v.sys.comcast.net ([69.252.207.39]:34202 "EHLO
        resqmta-ch2-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730946AbeG1W0p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Jul 2018 18:26:45 -0400
Date: Sat, 28 Jul 2018 16:50:49 -0400 (EDT)
From: jkexcel <jkexcel@comcast.net>
Reply-To: jkexcel <jkexcel@comcast.net>
To: linux-btrfs@vger.kernel.org
Message-ID: <1438689914.6655.1532811050018@connect.xfinity.com>
Subject: btrfs-convert missing in btrfs-tools v4.15.1
MIME-Version: 1.0
Content-Type: multipart/alternative;
        boundary="----=_Part_6654_1787011089.1532811050017"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

------=_Part_6654_1787011089.1532811050017
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

I'm an end user trying to use btrfs-convert but when I installed btrfs-tools and its dependency btrfs-progs on kubuntu 18.04, the installation was successful, and it shows that v4.15.1-1build1 was installed.


However, when using the command  # brtfs-convert  /dev/sda4 (with the drive unmounted) the resulting error appears "command not found"


I also tried command "btrfs convert" in case this was folded into the main tool, but this also failed.


1. Is btrfs-convert still available?

2. Where can I find it?

3. Has btrfs-convert been replaced? what is it's new name?

4. Is it safe to use a downgraded version of btrfs-tools ie: 4.14 or older?
------=_Part_6654_1787011089.1532811050017
MIME-Version: 1.0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html>
<html><head>
    <meta charset=3D"UTF-8">
</head><body><p style=3D"color: rgb(51, 51, 51); font-family: helvetica,ari=
al,sans-serif; font-size: 12pt;">I&#39;m an end user trying to use btrfs-co=
nvert but when I installed btrfs-tools and its dependency btrfs-progs on ku=
buntu 18.04, the installation was successful, and it shows that v4.15.1-1bu=
ild1 was installed.</p><p style=3D"color: rgb(51, 51, 51); font-family: hel=
vetica,arial,sans-serif; font-size: 12pt;"><br></p><p style=3D"color: rgb(5=
1, 51, 51); font-family: helvetica,arial,sans-serif; font-size: 12pt;">Howe=
ver, when using the command&#160; # brtfs-convert&#160; /dev/sda4 (with the=
 drive unmounted) the resulting error appears &#34;command not found&#34;</=
p><p style=3D"color: rgb(51, 51, 51); font-family: helvetica,arial,sans-ser=
if; font-size: 12pt;"><br></p><p style=3D"color: rgb(51, 51, 51); font-fami=
ly: helvetica,arial,sans-serif; font-size: 12pt;">I also tried command &#34=
;btrfs convert&#34; in case this was folded into the main tool, but this al=
so failed.</p><p style=3D"color: rgb(51, 51, 51); font-family: helvetica,ar=
ial,sans-serif; font-size: 12pt;"><br></p><p style=3D"color: rgb(51, 51, 51=
); font-family: helvetica,arial,sans-serif; font-size: 12pt;">1. Is btrfs-c=
onvert still available?</p><p style=3D"color: rgb(51, 51, 51); font-family:=
 helvetica,arial,sans-serif; font-size: 12pt;">2. Where can I find it?</p><=
p style=3D"color: rgb(51, 51, 51); font-family: helvetica,arial,sans-serif;=
 font-size: 12pt;">3. Has btrfs-convert been replaced? what is it&#39;s new=
 name?</p><p style=3D"color: rgb(51, 51, 51); font-family: helvetica,arial,=
sans-serif; font-size: 12pt;">4. Is it safe to use a downgraded version of =
btrfs-tools ie: 4.14 or older?</p></body></html>
=20
------=_Part_6654_1787011089.1532811050017--
