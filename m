From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: btrfs-convert fails
Date: 01 Nov 2010 12:55:00 +0100
Message-ID: <B$1ssrji1uB@helmut.hullen.de>
References: <20101101104943.00007ff9@unknown>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101101104943.00007ff9@unknown>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Felix,

Du meintest am 01.11.10:

>>>> =A0btrfs-convert: extent-tree.c:2529: btrfs_reserve_extent:
>>>> Assertion =A0 =A0 `!(ret)' failed
>>>> =A0Abgebrochen

>>> Try btrfs-convert -r /dev/xxx, hopefully it will recover your ext2.

>> Restoring is (now) no problem, I'm still testing. But in some days
>> (or weeks) I want to convert a partition with 1,5 TByte (which has
>> no backup) ...

> don't use btrfs for important files if you got no backup yet. It's
> quite stable and a lot of ppl don't have problem with it, but there
> are some cases where it could be very ugly, like a powerloss while
> writing etc.

In these special cases: no big problem. The 1.5 TByte partition contain=
s =20
my videos (at least most of them), and there is a kind of backup on =20
another machine in the family (some kilometers away).

And my machine works behind an UPS. But what about a shutdown initiated=
 =20
by this UPS after (p.e.) 3 minutes powerloss?

Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
