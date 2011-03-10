From: Clemens Eisserer <linuxhippy@gmail.com>
Subject: Re: BTRFS fsck tool
Date: Thu, 10 Mar 2011 13:21:24 +0100
Message-ID: <AANLkTi=z-uXPhJcYj4y_ur2SVU5kStA9NqaCXvoN=6CX@mail.gmail.com>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com>
	<4D7591CC.6060301@shiftmail.org>
	<AANLkTimaX2K=Uf-HZ7+dWN20Qt7Xntj+NoRiC7xN770=@mail.gmail.com>
	<20110308065255.24100.qmail@stuge.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110308065255.24100.qmail@stuge.se>
List-ID: <linux-btrfs.vger.kernel.org>

Well, the missing file-system checker is the main reason I don't use
btrfs in production environments.
The other issue are servere performance problems in corner cases (e.g.
when deleting 15GB data takes 100% cpu and hours)

- Clemens

2011/3/8 Peter Stuge <peter@stuge.se>:
> Hi,
>
> Alexey A Nikitin wrote:
>> I went experimenting with btrfs RAID0 on my USB setup .. because
>> I'm a reckless experimenter when it doesn't involve production
>> systems.
>
> I encountered the same broken root node issue. (see thread resize ate
> my root node) and I'd like to understand it better. Hopefully there
> will come something out of this. I'm surprised that my resize broke
> the filesystem for mounting, when it looked good right after the
> resize.
>
> When I looked through the archive and found your thread I started
> thinking, and I am not absolutely sure if there was some disk
> activity when I cut power to my system, but I believe there was not.
> (I ran reboot, but soft poweroff doesn't work with recent kernels. At
> the Rebooting system message I switched hard power off.)
>
>
> //Peter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
