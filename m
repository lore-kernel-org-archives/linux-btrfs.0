From: Gordan Bobic <gordan@bobich.net>
Subject: Re: SSD optimizations
Date: Mon, 13 Dec 2010 15:04:27 +0000
Message-ID: <4D0635FB.5050604@bobich.net>
References: <1292174654.11248.10.camel@paddy-desktop>	<4D05630E.7070809@bobich.net>	<20101213051157.GA19543@attic.humilis.net>	<4D05E681.5090004@bobich.net> <AANLkTikEpDp6ky-J3V7Aa2oNEg-mF8ZUU7qfaDdxdrKo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: sander@humilis.net, jarktasaa@gmail.com,
	linux-btrfs@vger.kernel.org
To: Peter Harris <git@peter.is-a-geek.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikEpDp6ky-J3V7Aa2oNEg-mF8ZUU7qfaDdxdrKo@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 13/12/2010 14:33, Peter Harris wrote:
> On Mon, Dec 13, 2010 at 4:25 AM, Gordan Bobic wrote:
>> I suggest you back your opinion up with some hard data before making such
>> statements. Here's a quick test - make an ext2 fs and a btrfs on two similar
>> disk partitions (any disk, for the sake of the experiment it doesn't have to
>> be an ssd)
>
> Okay, here's some hard data.
>
> Acer Aspire One ZG5 with an SSDPAMM0008G1 (cheap/slow) SSD, Fedora 13.
>
> Doing a standard yum update, measuring the yum cleanup phase while
> browsing with Firefox:
>
> Default extN: machine becomes completely unusable for minutes.
> btrfs with ssd_spread: machine functions normally, cleanup finishes in
> (often much) under 15 seconds.
>
> Regardless of what vmstat says, btrfs is clearly faster on this hardware.

extN is too broad. ext2, ext3, or ext4? If ext4, with journal or 
without? I am talking specifically about extN _without_ a journal. I use 
ext2 and ext4-without-a-journal on all my cheap flash (mostly SD/CF 
cards and USB sticks) with a deadline scheduler and I have not observed 
any massive slowdown like you describe.

Either way, there is also the longevity of the flash to be considered, 
and vmstat's write reading is very indicative of that.

Gordan
