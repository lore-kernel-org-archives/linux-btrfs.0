From: Chris Mason <chris.mason@oracle.com>
Subject: Re: too many links when creating 40 000 dirs
Date: Thu, 02 Apr 2009 12:10:24 -0400
Message-ID: <1238688624.29739.5.camel@think.oraclecorp.com>
References: <2db2c6b80904020236s447e798esd1109554a4b6d146@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Rekrutacja119 <rekrutacja119@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2db2c6b80904020236s447e798esd1109554a4b6d146@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-04-02 at 11:36 +0200, Rekrutacja119 wrote:
> i have problems creating more than 39 999 subdirectories in the same
> directory in btrfs. i'm using version from kernel 2.6.29 and
> mkfs.btrfs 0.18
> 
> linux:/t # mount|grep btrfs
> /dev/mapper/sys-test on /t type btrfs (rw)
> linux:/t # ls|wc -l
> 31999
> linux:/t # mkdir test123
> mkdir: cannot create directory `test123': Too many links
> linux:/t #
> 
> any idea why?

Hmmm, I'm a little surprised, btrfs doesn't actually maintain a link
count for directories.  If you use the stat program on /t it should say
the link count is one.  (please try this).

The btrfs mkdir call doesn't check the link count either.  Could you
please triple check another FS wasn't mounted on top of /t?

-chris



