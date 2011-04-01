From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: btrfs balancing start - and stop?
Date: Fri, 01 Apr 2011 17:24:32 +0300
Message-ID: <4D95E020.7030905@gmail.com>
References: <Bj0igski1uB@helmut.hullen.de> <4D95D19F.7060101@gmail.com> <20110401133736.GB2984@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
To: Hugo Mills <hugo-lkml@carfax.org.uk>, helmut@hullen.de,
	Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110401133736.GB2984@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 1/4/2011 4:37 =CE=BC=CE=BC, Hugo Mills wrote:
> On Fri, Apr 01, 2011 at 04:22:39PM +0300, Konstantinos Skarlatos wrot=
e:
>> On 1/4/2011 3:12 =CE=BC=CE=BC, Helmut Hullen wrote:
>>> Du meintest am 01.04.11:
>>>
>>> "dmesg" counts down the number of remaining "jobs".
>> are you sure? here is a snippet of dmesg from a balance i did
>> yesterday (2.6.38.1)
>>
>> btrfs: relocating block group 15338569728 flags 9
>> btrfs: found 17296 extents
>> btrfs: found 17296 extents
>> btrfs: relocating block group 13191086080 flags 9
>> btrfs: found 21029 extents
>> btrfs: found 21029 extents
>> btrfs: relocating block group 11043602432 flags 9
>> btrfs: found 4728 extents
>> btrfs: found 4728 extents
>     Count the number of block groups in the system (1GiB for data,
> 256MiB for metdata on a typical filesystem), and subtract the number
> of "relocating block group" messages... Not ideal, but it's possible.
>
>     The balance cancel patch I mentioned earlier also supplies an
> additional patch for monitoring progress, which does show up in the
> dmesg output (as well as user-space support for prettier output).
Great, I think it is very important to have a human-readable progress=20
monitor for operations like that.
>     Hugo.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
