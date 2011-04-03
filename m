From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: minor ID for btrfs-control
Date: 03 Apr 2011 12:52:00 +0200
Message-ID: <Bj8mFnBD1uB@helmut.hullen.de>
References: <4D984AC5.3040207@libero.it>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D984AC5.3040207@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Goffredo,

Du meintest am 03.04.11:

>>> As wrote by Tomasz the minor number of the btrfs-control is
>>> allocated dynamically.

>> At which place?

> I replied you too fast. Btrfs register a "misc" device, but its
> number is not dynamically allocated (see [1] for further
> information), but it is static.

> $ grep BTRFS_MINOR -r include/
> include/linux/miscdevice.h:#define BTRFS_MINOR          234

Ah - there it is!
I'd only searched in fs/btrfs

> I can conclude that _now_ the minor is 234 and not 55. But I don't
> know if it is a _stable_ interface.

We'll see ... now I know the error message and the place where I can  
examine the actual major and minor value. Should be enough information  
for the next months ...

Thank you!

Viele Gruesse!
Helmut
