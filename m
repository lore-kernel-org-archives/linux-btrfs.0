From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: LABEL only 1 device
Date: 27 Feb 2012 22:15:00 +0100
Message-ID: <C3f4teQD1uB@helmut.hullen.de>
References: <pan.2012.02.27.16.48.34@cox.net>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.02.27.16.48.34@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Duncan,

Du meintest am 27.02.12:

>>>    I've said this several times: Your expectations are wrong. You
>>> don't label partitions.

>> Yes - now I know.
>> But I'm afraid other people also expect wrong - when I use
>> mkfs.ext[234] then this option works (in another way than with
>> "mkfs.btrfs").

> AFAIK, it works in the same way... that is, it labels the, in that
> case, ext2/3/4 filesystem, in this case (mkfs.btrfs), btrfs
> filesystem.

> From the manpages:

> mkfs.btrfs (aka mkbtrfs):

>        -L, --label name
>               Specify a label for the filesystem.

> mkfs.ext2/3/4 (aka mke2fs):

>        -L new-volume-label
>               Set  the  volume  label  for the filesystem to
> 	      new-volume-label.  The maximum length of the
>               volume label is 16 bytes.

But there's a small difference:

        mke2fs -L MyLabel /dev/sdn4

only sets/changes the label (ok - it tests the type of the partition and  
refuses labeling if the type doesn't fit).

        mkfs.btrfs -L MyLabel /dev/sdn4

not only sets/changes the label but also (re-)creates a btrfs  
filesystem, using the default parameters.

I had to learn this difference ...

Viele Gruesse!
Helmut
