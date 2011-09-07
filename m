From: cwillu <cwillu@cwillu.com>
Subject: Re: mount a multi-device filesystem using a loopback device
Date: Tue, 6 Sep 2011 22:37:15 -0600
Message-ID: <CAE5mzvjjHh2SZ42o7spb0LQZzsnmf4Dn1hN-JQ-HcFSeZa2dXA@mail.gmail.com>
References: <4E66F090.4030507@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: jeff.liu@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E66F090.4030507@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

> 1.  Create and format two images, the 1st in 400Mbytes, and 2nd in 286Mbytes.
> root@pibroch:/btrfs-progs# ls -lh /usr/src/linux-3.0/img*
> -rw-r--r-- 1 jeff jeff 400M 2011-09-07 12:00 /usr/src/linux-3.0/img0
> -rw-r--r-- 1 jeff jeff 286M 2011-09-07 12:00 /usr/src/linux-3.0/img1

Very small btrfs filesystem require special handling, mixed block
groups in particular, which I believe also requires an updated mkfs
from the integration repo.
