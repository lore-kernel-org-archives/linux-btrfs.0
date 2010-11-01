From: cwillu <cwillu@cwillu.com>
Subject: Re: btrfs-convert fails
Date: Mon, 1 Nov 2010 06:20:04 -0600
Message-ID: <AANLkTi=qwtEwBTxsqEBzQ78QA852wh9RDG-HNmABpj22@mail.gmail.com>
References: <20101101104943.00007ff9@unknown>
	<B$1ssrji1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <B$1ssrji1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 1, 2010 at 5:55 AM, Helmut Hullen <Hullen@t-online.de> wrot=
e:
> Hallo, Felix,
>
> Du meintest am 01.11.10:
>
>>>>> =A0btrfs-convert: extent-tree.c:2529: btrfs_reserve_extent:
>>>>> Assertion =A0 =A0 `!(ret)' failed
>>>>> =A0Abgebrochen
>
>>>> Try btrfs-convert -r /dev/xxx, hopefully it will recover your ext2=
=2E
>
>>> Restoring is (now) no problem, I'm still testing. But in some days
>>> (or weeks) I want to convert a partition with 1,5 TByte (which has
>>> no backup) ...
>
>> don't use btrfs for important files if you got no backup yet. It's
>> quite stable and a lot of ppl don't have problem with it, but there
>> are some cases where it could be very ugly, like a powerloss while
>> writing etc.
>
> In these special cases: no big problem. The 1.5 TByte partition conta=
ins
> my videos (at least most of them), and there is a kind of backup on
> another machine in the family (some kilometers away).
>
> And my machine works behind an UPS. But what about a shutdown initiat=
ed
> by this UPS after (p.e.) 3 minutes powerloss?

Problems resulting from powerloss should be limited to faulty hardware
(in which case you're screwed regardless of the filesystem) and lack
of barrier support (which should show up in dmesg soon after the first
write goes to disk).  I'm told that the devs do quite a bit of crash
testing, and I have yet to lose a btrfs filesystem to a powerloss on a
variety of crappy hardware.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
