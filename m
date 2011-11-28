From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: wrong / too less space on raid
Date: Sun, 27 Nov 2011 23:01:07 -0500
Message-ID: <4ED30783.7080204@cfl.rr.com>
References: <1322397922.11404.15.camel@master.beowulf.me> <4ED2E596.7010309@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: source <source@disable-microsoft.net>, linux-btrfs@vger.kernel.org
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED2E596.7010309@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/27/2011 08:36 PM, Miao Xie wrote:
> This number is just a appraised number, not rigorous. It tells us
> how much space we can use to make up raid0 block groups which are
> used to store the file data.

More specifically, the available space that df reports is the amount of space available to store file data, which means it doesn't count the space reserved for metadata block groups, even though a not insignificant amount of that space may be free for metadata allocations.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7TB4AACgkQJ4UciIs+XuLdOACaA3hrErj82plyPOxXEoM+kHd3
5XkAnR3vR+0bhGlewjKTSEsVNZgc0mka
=UNVc
-----END PGP SIGNATURE-----
