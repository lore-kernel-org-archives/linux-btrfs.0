Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43374 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab2E3JKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 May 2012 05:10:16 -0400
Received: by yhmm54 with SMTP id m54so3040353yhm.19
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2012 02:10:16 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 30 May 2012 11:10:15 +0200
Message-ID: <CAP4s+CE4z+wG++TV-T1Er9cSoiFfecJN175S0_g7ERRrAV96BQ@mail.gmail.com>
Subject: Btrfsck stuck when checking fs roots
From: Joan <aseques@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello i've a data partition in my system formated as btrfs,  I can
mount the partition without problems, but from time to time I've some
lockings in the disk that force me to reboot the system.
Lately I have been having problems when unmounting the disk too

I have been running for several weeks the kernel 3.3.1, and my
btrfs-tools are version 0.19+20120328-1 (from debian wheezy)

This is the output I am getting from btrfsck, and it always ends up
aborting the "checking fs roots" part.


$ btrfsck /dev/sda1
....................
ref mismatch on [2188599418880 2072576] extent item 1, found 0
Incorrect local backref count on 2188599418880 root 261 owner 26476652
offset 0 found 0 wanted 1 back 0x6b3435e8
backpointer mismatch on [2188599418880 2072576]
owner ref check failed [2188599418880 2072576]
ref mismatch on [2188877869056 4231168] extent item 1, found 0
Incorrect local backref count on 2188877869056 root 261 owner 26476649
offset 0 found 0 wanted 1 back 0x97bc7798
backpointer mismatch on [2188877869056 4231168]
owner ref check failed [2188877869056 4231168]
ref mismatch on [2188882100224 3911680] extent item 1, found 0
Incorrect local backref count on 2188882100224 root 261 owner 26476654
offset 0 found 0 wanted 1 back 0x97bc7840
backpointer mismatch on [2188882100224 3911680]
owner ref check failed [2188882100224 3911680]
ref mismatch on [2188886011904 1798144] extent item 1, found 0
Incorrect local backref count on 2188886011904 root 261 owner 26476657
offset 0 found 0 wanted 1 back 0x97bc78e8
backpointer mismatch on [2188886011904 1798144]
owner ref check failed [2188886011904 1798144]
ref mismatch on [2188900532224 1875968] extent item 1, found 0
Incorrect local backref count on 2188900532224 root 261 owner 26476659
offset 0 found 0 wanted 1 back 0x97bc7b70
backpointer mismatch on [2188900532224 1875968]
owner ref check failed [2188900532224 1875968]
ref mismatch on [2188902408192 2080768] extent item 1, found 0
Incorrect local backref count on 2188902408192 root 261 owner 26476664
offset 0 found 0 wanted 1 back 0x97bc7c18
backpointer mismatch on [2188902408192 2080768]
owner ref check failed [2188902408192 2080768]
Errors found in extent allocation tree
checking fs roots
Aborted

Is there anything I can do to force a check only in this part while
getting more debug?
