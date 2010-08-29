From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: machine gets unresponsive during btrfs balance
Date: Sun, 29 Aug 2010 15:52:51 +0200
Message-ID: <4C7A6633.80008@gmail.com>
References: <4C639F42.3050206@gmail.com> <201008261527.54056.johannes.hirte@fem.tu-ilmenau.de> <4C766E8D.7000103@gmail.com> <201008261838.30509.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: "Yan, Zheng " <yanzheng@21cn.com>, linux-btrfs@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201008261838.30509.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 26.08.2010 18:38, Johannes Hirte wrote:
> On Thursday 26 August 2010 15:39:25 Andreas Philipp wrote:
>> On 26.08.2010 15:27, Johannes Hirte wrote:
>>> Looks like another manifestation of the csum bug. Are you able
>>> to read all files from the affected volume? Did you tried a
>>> balance with an 2.6.34 kernel after the test with 2.6.35?
>>>
>> Till now I did not see any unreadable files but I did not do a
>> complete test. No, I did not try to balance with an 2.6.34
>> kernel. If it helps I can switch back and try.
>
> I hope it helps to localize the error. It's still not clear where
> this starts an what kernels are affected.
>
Unfortunately, I cannot reboot at until next Monday. But in the
meantime, I do a "test read" of all files on the volume to see whether
something cannot be read, too.

Regards,
Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJMemYyAAoJEJIcBJ3+XkgiEOgQALeGqTtd8SxZr+GgqLvWusMu
sdwszFOi/4azNZ848DAt8Xs47X/6c0K+I2ZfzQqXTGJFlGCviKa4JDxQeQf9Fy6A
q9aayLMOKqBMVTPSjIIR/y/GO6YT3M62jhnehT1wGO27JJWZzrL8xsXVpJxzJflI
V67pMbPT1FJLGKmFpJbB2AIPUuNNaSwaG9170rTlD5fCpwSE4mzzeHJK21ihG5p6
4YdGGW+ak6iB86RkYPZU69XlKOgzb1opHDcGE6rSGRncj6fdyNXhmEUiiM/RNzs8
9yFQ8TspGGnmiszrpqZ6K6b2ajEpqxtGPbOj87Xc6dRfo5/ByrXhpdHpd70gfTRZ
oMcqcyt/wfIMXonOKrkJi+Zqb2K2SzellNQ2rMpDzdJK48J7tNTw/wfoZ+l44zNm
vtCWQa04KBfhkIgqEf8GHpq4RwIaDJ4twW2TjWZNLFCTa7i1HDgmyY5K34pYmAXT
ToOgOq4b6WnnEBC0+5Fm5AYm8eknwUtRxSvH1MZyGAHQndw+38EoXgP5fe8JOsqL
VVHP1eaXBS06eSrhSYmj10bvmnn6rOBG7LxJLYlsFvrHdx/TgxMxcMDMBtWM5vsk
Lmlo0RizVlMjlsGINSKXSouv/y9h6Pyp5CVc4Xw9ByGGGkBX3bH8mI8TKdKey5y7
jUsZn1LtF3rYTBIgET5N
=8PvR
-----END PGP SIGNATURE-----

