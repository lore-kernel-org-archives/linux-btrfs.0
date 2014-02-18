Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10909 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482AbaBRQ07 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 11:26:59 -0500
Message-ID: <530389CF.4080203@fb.com>
Date: Tue, 18 Feb 2014 11:26:55 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix a deadlock on chunk mutex
References: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>	<20121218135242.GC2403@localhost.localdomain>	<CAOcd+r2q6+RU_8k_m8=7wr5cjBZ3hLXr1QZCmvWB1hLZyRfoZQ@mail.gmail.com>	<5303850C.7030008@fb.com> <CAOcd+r14jqCUKQZPbcvwMYqqsYFo_pgiW=G=Yyhifmt6Tkw_UA@mail.gmail.com>
In-Reply-To: <CAOcd+r14jqCUKQZPbcvwMYqqsYFo_pgiW=G=Yyhifmt6Tkw_UA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/18/2014 11:24 AM, Alex Lyakas wrote:
> Hi Josef, is this the commit to look at: 
> 6df9a95e63395f595d0d1eb5d561dd6c91c40270 Btrfs: make the chunk 
> allocator completely tree lockless
> 
> or some other commits are also relevant?
> 

It's been so long but I'm pretty sure everything you need is in that
patch.  Thanks,

Josef
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTA4nPAAoJEANb+wAKly3BlNwP/AyG7LtDo6YYaYvXJyBJa1Vj
hq2C48lwQhSjAYfn5QJ05AUOgL4xAb1THSjDqTIyoyEXGwBnRLEaX3/MFygthrxi
9u137ys1C/EQr3fmRecdz6Qpojkf5EAxiK8J0nL+G/BXoJYdwCYUj4oLOgqwP6/X
/XhsqyCLmj8jATndYCz7Z68xfutF37xtId0mWEsRrnvMqrT5nDvA/WpkzYE+ovc3
OhffFHfHJAf94qMb6EtSpH3E2MJDIYfp6cIAEgEK2ougZLnf0lkjcCXd2B6fRLcY
9WuZaVsi4J+vqGxVwnxDaJ7TbjEDXbl+bnAs5R5VDKZUy56zOxNA9//ejCuYtl/P
r5K0PKZXu81wiK22DbF0hhZfzdkElnVqx8DSgwTyyo5aJTj6cNuDRdPmTz4TEbib
N8z7rGC85Y4Z9Z1Gwnj3cD6pKQU4+anUhkIWNFVM9SpWbjYXgjjTMAj/LaM6GhJL
OptTORUwu4+9hGnfu7ItL8uyVrBwyh9cUcbru79D0+YyyWR5fDsgYFCtvUuhJ16q
vrViGT2MVyt4ZevvJMG02997sC8OCyeF4W0eQgyvgSOJToeoOJ57j8z/mSUntqDE
94f6hqOBjN6UY6/2FFILeMH0xuF0Li5JUOYB5Da99iHByeHQ4hrBWVyyvZfqW4vN
YY32d8J7Ine1N7/IZdVh
=jn5g
-----END PGP SIGNATURE-----
