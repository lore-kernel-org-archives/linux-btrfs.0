From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: 07 May 2012 19:52:00 +0200
Message-ID: <C8PD2qZuCXB@helmut.hullen.de>
References: <4FA802C2.6010909@gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA802C2.6010909@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Felix,

Du meintest am 07.05.12:

>> I'm just going back to ext4 - then one broken disk doesn't disturb
>> the contents of the other disks.

> ?! If you use raid0 one broken disk will always disturb the contents
> of the other disks, that is what raid0 does, no matter what
> filesystem you use.

Yes - I know. But btrfs promises that I can add bigger disks and delete  
smaller disks "on the fly". For something like a video collection which  
will grow on and on an interesting feature. And such a (big) collection  
does need a "gradfather-father-son" backup, that's no critical data.

With a file system like ext2/3/4 I can work with several directories  
which are mounted together, but (as said before) one broken disk doesn't  
disturb the others.

Viele Gruesse!
Helmut
