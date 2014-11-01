Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57705 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbaKANJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Nov 2014 09:09:38 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]) by mail.gmx.com
 (mrgmx003) with ESMTPSA (Nemesis) id 0LqzIJ-1YG1ER1AtX-00ebXv for
 <linux-btrfs@vger.kernel.org>; Sat, 01 Nov 2014 14:09:36 +0100
Received: by mail-qc0-f180.google.com with SMTP id o8so7252307qcw.11
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Nov 2014 06:09:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1414739937.5809.51.camel@localhost.localdomain>
References: <CAHOQfW0CF1CrHrZ_T_G49kXh6scKK59aYYZn48fi112RfHX=wg@mail.gmail.com>
	<545062CC.6020206@oracle.com>
	<CAHOQfW2hKtjJ=oCGp2KbvbtBsWxQpo+zforzrashVO7zDAmLHg@mail.gmail.com>
	<5451B65A.9090302@oracle.com>
	<CAHOQfW1PJ4m4KEHkwp4sKBL9ttNwv+ZpLPG4PKx9ewXWsCJhQQ@mail.gmail.com>
	<1414739937.5809.51.camel@localhost.localdomain>
Date: Sat, 1 Nov 2014 14:09:34 +0100
Message-ID: <CAHOQfW0vOHZ37XJSfXYPAas3LGWFR-YbYWoo3bNLK_ZiMWeCbw@mail.gmail.com>
Subject: Re: [offlist]Re: read block failed check_tree_block / Couldn't read
 chunk tree
From: Rene Thomas <re.thomas@gmx.de>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Gui,

no worries. I'am happy with the btrfs fi sh (with or without patch)
I'll try your paches. At the moment I have started to recover the data
from an other device where some parts of the data was stored before.

Since there was no progress during mkfs I don't now what was affected
on the disc. After a short time I've closed the terminal I've used.

I guess the attemp to recover the data make things worse. At least the
Filesystem was in ro state and accesible before I shutdown the system.
Maybe this was the right time to save the data :-)

Thanks
René
