From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: looking for non existent devices
Date: Wed, 21 Mar 2012 20:12:02 +0200
Message-ID: <20120321181202.GA1973@zambezi.lan>
References: <C52pIRfT1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C52pIRfT1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 17, 2012 at 10:32:00AM +0100, Helmut Hullen wrote:
> Hallo, linux-btrfs,
> 
> some commands still look for non existent devices.
> 
> I don't use "udev".
> When I run
> 
>         btrfs filesystem show
> 
> only the existent devices are shown - fine.
> 
> When I run
> 
>         btrfs filesystem label
> 
> or
> 
>         btrfs scrub status /dev/sdxn
> 
> then I get a lot of error messages with (p.e.)
> 
>   failed to read /dev/hda6: No such device or address
>   failed to read /dev/sdm7: No such device or address
>   failed to read /dev/sr3: No such device or address

Hi Helmut,

I think this has been fixed in recent btrfs-progs, commit 32eff711.
Could test with that commit present please ?  (You can get it from
dangerdonteveruse branch of Chris' btrfs-progs repo [1], the 'danger'
tag is irrelevant as long as you don't try to run fsck from that branch)

[1] git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

Thanks,

		Ilya
