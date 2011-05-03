From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: abysmal performance
Date: Tue, 3 May 2011 08:41:37 -0500
Message-ID: <BANLkTikUwnf4E3n4mDLkkptPGA=rRTjPNg@mail.gmail.com>
References: <1304088305-sup-3784@localhost>
	<1304089239-sup-5110@think>
	<BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com>
	<20110430235539.6205.qmail@stuge.se>
	<ipolll$2h0$1@dough.gmane.org>
	<1304420831-sup-4737@think>
	<4DBFE75C.2000104@birkenwald.de>
	<1304422493-sup-6212@think>
	<4DBFEA48.3000406@birkenwald.de>
	<1304427015-sup-4772@think>
	<4DBFFD17.8080702@birkenwald.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Bernhard Schmidt <berni@birkenwald.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DBFFD17.8080702@birkenwald.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 3, 2011 at 8:03 AM, Bernhard Schmidt <berni@birkenwald.de> =
wrote:
> Hi,
>
>> Ok, looks like we could be doing a little better job when compressio=
n is
>> on to build out a bigger extent. =A0This shouldn't be causing troubl=
e on
>> an ssd at all but on your rotating disk it'll be slightly slower.
>>
>> Still most of these extents are somewhat close together, this is rou=
ghly
>> what mount -o ssd (which is enabled automatically when we detect a
>> non-rotating drive) would try for.
>>
>> The problematic files are going to have thousands of extents, this f=
ile
>> should be fine.
>
> Thanks, I'll check on my system with rotating disks at home when I ge=
t back.
>

I'd also be curious to see if mounting with "-o compress-force=3Dlzo"
affects anything.

As I recall, the compress-force option was added because performance
could be affected negatively when trying to optimize compression with
"-o compress".
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
