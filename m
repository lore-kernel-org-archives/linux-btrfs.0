From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH] Btrfs-progs: update btrfs-debug-tree
Date: Fri, 20 Feb 2009 11:24:04 -0500
Message-ID: <499ED924.2090705@suse.com>
References: <499D04FF.5020600@cn.fujitsu.com>  <499DFBAC.1020602@suse.com> <1235140108.13249.0.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Shen Feng <shen@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1235140108.13249.0.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Chris Mason wrote:
> On Thu, 2009-02-19 at 19:39 -0500, Jeff Mahoney wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Shen Feng wrote:
>>> output objectid in btrfs_disk_key with human readable strings.
>>> Other updates are included for more readable output.
>> This gets messy fast. I'd like to see some sort of generic extensible
>> printk mechanism in the kernel. 
> 
> This is a btrfs-progs patch ;)

Heh, oops. That's an important bit of information.

>> Maybe I've been spoiled by the reiserfs
>> type printing but it seems a lot nicer to do eprintk(&ops, "key: %k\n");
>> than to split them out into different printks. Since the core behavior
>> ends up in vsnprintf, you get it for things like panic for free too.
>> Ideally, the tprintk(&ops, ...) would be hidden behind a btrfs_warning()
>> or something.
>>
>> I have a patch set that implements an extensible printk so that every
>> single pointer type doesn't need to be added to lib/vsprintf.c's pointer().
>>
> 
> That would be interesting, I do miss the old reiserfs %k

Let me clean them up a bit and send to LKML. I can probably do that
later today. I decided to rename it to eprintk from a pretty ugly
printk_custom.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkme2SMACgkQLPWxlyuTD7ITSwCeO3XaNGY29kA/5oBcdDL7DqpH
B5wAnRv7RYjzX5h4pX+FbjTGTBGAFy7S
=a5iu
-----END PGP SIGNATURE-----
