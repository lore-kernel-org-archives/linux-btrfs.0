From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: version
Date: 27 Jan 2011 14:28:00 +0100
Message-ID: <BeeuL9Wy1uB@helmut.hullen.de>
References: <1296114256-sup-4788@think>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296114256-sup-4788@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Chris,

Du meintest am 27.01.11:

>> crashes with the "dmesg" lines
>>
>> --------------------- dmesg -------------------
>>
>> bio too big device sdc (256 > 240)
>> bio too big device sdc (256 > 240)
>> bio too big device sdc (256 > 240)
>> bio too big device sdc (256 > 240)
>> ------------[ cut here ]------------
>> kernel BUG at fs/btrfs/volumes.c:2097!

> Ugh, this one is an old friend I thought I had fixed up.  The two
> devices have different limits on the max size of the bio, and we're
> using one that is too large.

> I'll get it fixed for the next rc.

Seems to be not related to SSD or CFdisk; I've run the same commands  
with two real HDs and got the same error messages.

That problem appears with Kernel 2.6.38-rc2, it doesn't appear with  
Kernel 2.6.37 (but there I've still the ENOSPC problem).

Viele Gruesse!
Helmut
