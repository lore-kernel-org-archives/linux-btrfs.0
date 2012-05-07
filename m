From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: 07 May 2012 20:25:00 +0200
Message-ID: <C8PDD0cPCXB@helmut.hullen.de>
References: <20120507180047.GG8938@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120507180047.GG8938@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 07.05.12:

>> With a file system like ext2/3/4 I can work with several directories
>> which are mounted together, but (as said before) one broken disk
>> doesn't disturb the others.

>    mkfs.btrfs -m raid1 -d single should give you that.

What's the difference to

     mkfs.btrfs -m raid1 -d raid0

(what I have used the last time)?

Viele Gruesse!
Helmut
