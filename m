From: "Ryusuke Konishi" <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH] Btrfs: fix build errors of extent_io.c
Date: Tue, 6 Jan 2009 02:29:17 +0900
Message-ID: <c4a7c9420901050929q37f4b640wdebad72fe227e456@mail.gmail.com>
References: <20081224.175640.119553873.ryusuke@osrg.net>
	 <1231170459.4290.90.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231170459.4290.90.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

2009/1/6 Chris Mason <chris.mason@oracle.com>:
> On Wed, 2008-12-24 at 17:56 +0900, Ryusuke Konishi wrote:
>> Hi Chris,
>>
>> I've started to read and try btrfs, and soon met the following build
>> errors.  The attached patch fixes the problem.
>>
>> Could you check this?
>>
>
> Strange, I wonder why your gcc complains and mine doesn't ;)  I'll fix
> these up thouhg.

Because I tried it on a powerpc ;)
The check of EXPORT_SYMBOL macros seems to be more strict
than that of x86.

As you can tell, my intention was to test endian problems,
and, so far, btrfs is perfectly working on both architectures
(except I met a freeze due to a disk full).
I mean the compatibilty of disk image was achieved between
x86 and ppc64 without problems.

Ryusuke
