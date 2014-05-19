Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56825 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbaESNJY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 09:09:24 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so7729313wgg.6
        for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 06:09:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B7F2379062E32745A8651FBDB20F64592FCF3D03@Server.waterlogic.com.au>
References: <CAF_AmaOyqgxn8rPs4rKugUz9ZkGoc4mt+Q8Q-nLJF_hPxUufZw@mail.gmail.com>
	<CAG1y0sf9tW+151DMvihWgRFnbUs3Q=uKyL3W4_heU7rYBQz0=w@mail.gmail.com>
	<CAF_AmaOJF4W5uABSvrtBGg7NUzcmE03Qtom+THKFEP_oYH3gmg@mail.gmail.com>
	<B7F2379062E32745A8651FBDB20F64592FCF3D03@Server.waterlogic.com.au>
Date: Mon, 19 May 2014 15:09:22 +0200
Message-ID: <CAF_AmaM1WMHzVB28eHz1+JAz1Zt_tqiJHmBTJOtg8AGfiS9LAw@mail.gmail.com>
Subject: Re: Convert btrfs software code to ASIC
From: Le Nguyen Tran <lntran.de@gmail.com>
To: Paul Jones <paul@pauljones.id.au>
Cc: "Fajar A. Nugraha" <list@fajar.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Paul,

Thank you for your advice. Actually, I currently have ideas to
implement database management (like list, tree), and dynamic memory
allocation in hardware to accelerate the file system operations. I
still do not have a clear picture about which part is implemented by
processor (as your advice) and which part is accelerated by hardware.
I now need to understand the operation of btrfs source code to
determine. I hope that one of you can help me and if it work, we can
start-up our own business.

Thanks.

Nguyen.

On 5/19/14, Paul Jones <paul@pauljones.id.au> wrote:
> Hi Nguyen,
>  Perhaps a better idea would be to use a low-cost low-power som module to
> run Linux and btrfs code, and use an FPGA/ASIC to offload
> compression/encryption/checksums and to possibly act as a raid controller.
> Since btrfs will be under heavy development for the foreseeable future I
> doubt it would be a good idea to lock it into silicon. Using this approach
> the mature technologies can be hardware accelerated, and the software parts
> are available for easy upgrades.
> It also significantly reduces risk for your project, and VCs like that sort
> of thing!
>
> Regards,
> Paul.
>
> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org
> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Le Nguyen Tran
> Sent: Monday, 19 May 2014 9:07 PM
> To: Fajar A. Nugraha
> Cc: linux-btrfs
> Subject: Re: Convert btrfs software code to ASIC
>
> Hi Nugraha,
>
> Thank you so much for your information. Frankly speaking, no one can confirm
> a new start-up idea works or not. The probability of failure is always high.
> However, the benefit if it works is also very high.
>
> I do not plan to exactly replicate the C source code. There are always some
> techniques in ASIC design to implement which are not the same as in software
> (less flexible but faster).
>
> The main advantages of my proposed chip are:
> - Very high performance: Performance of ASIC chip is normally more than 10x
> higher than performance of processors because processor run only 1-4
> instructions sequentially. That is very suitable for server when there are
> many requests from users.
> - Low-cost: In side the chip, we can customized for our function only.
> In my plan, we do not need cache (which covers a very large area), and we
> can use low cost technology 0.18um.
> - Low-power: Processors run instructions sequentially and access memory ( or
> cache). As a result, they consume much more power than ASIC chip (also can
> be 10x higher).
>
> Actually ARM processors like mediatek cannot be comparable with ASIC chip.
> However, as I mentioned, it is just my draft idea. I still to work more to
> verify my idea.
>
> Thanks.
>
> Nguyen.
>
> On 5/19/14, Fajar A. Nugraha <list@fajar.net> wrote:
>> On Mon, May 19, 2014 at 3:40 PM, Le Nguyen Tran <lntran.de@gmail.com>
>> wrote:
>>> Hi,
>>>
>>> I am Nguyen. I am not a software development engineer but an IC
>>> (chip) development engineer. I have a plan to develop an IC
>>> controller for Network Attached Storage (NAS). The main idea is
>>> converting software code into hardware implementation. Because the
>>> chip is customized for NAS, its performance is high, and its cost is
>>> lower than using micro processor like Atom or Xeon (for servers).
>>>
>>> I plan to use btrfs as the file system specification for my NAS. The
>>> main point is that I need to understand the btrfs sofware code in
>>> order to covert them into hardware implementation. I am wandering if
>>> any of you can help me. If we can make the chip in a good shape, we
>>> can start up a company and have our own business.
>>
>> I'm not sure if that's a good idea.
>>
>> AFAIK btrfs depends a lot on other linux subsystems (e.g. vfs, block,
>> etc). Rather than converting/reimplementing everything, if your aim is
>> lower cost, you might have easier time using something like a mediatek
>> SOC (the ones used on smartphones) and run a custom-built linux with
>> btrfs support on it.
>>
>> For documentation,
>> https://btrfs.wiki.kernel.org/index.php/Main_Page#Developer_documentat
>> ion
>> is probably the best place to start
>>
>> --
>> Fajar
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
>
