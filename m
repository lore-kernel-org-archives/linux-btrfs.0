From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: btrfs-convert fails
Date: 01 Nov 2010 09:02:00 +0100
Message-ID: <B$1sRYTD1uB@helmut.hullen.de>
References: <AANLkTimFGe1PSbns4ps_wGSpSVMNhWehd=zoA8XnAu5_@mail.gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimFGe1PSbns4ps_wGSpSVMNhWehd=zoA8XnAu5_@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Yan,

Du meintest am 01.11.10:

>> I've tried to convert a 12 GByte ext2 partition (nearly full, 280
>> MByte free) with btrfs-convert.
>>
>> After about 15 minutes (700-MHz-CPU) the system tells
>>
>> =A0...
>> =A0creating ext2fs image file
>> =A0cleaning up system chunk
>> =A0btrfs-convert: extent-tree.c:2529: btrfs_reserve_extent: Assertio=
n
>> =A0 =A0 `!(ret)' failed
>> =A0Abgebrochen

> Try btrfs-convert -r /dev/xxx, hopefully it will recover your ext2.

Restoring is (now) no problem, I'm still testing. But in some days (or =
=20
weeks) I want to convert a partition with 1,5 TByte (which has no =20
backup) ...

Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
