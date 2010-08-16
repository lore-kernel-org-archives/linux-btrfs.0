From: Evert Vorster <evorster@gmail.com>
Subject: Fwd: 2.6.36-rc1 btrfs still unstable
Date: Mon, 16 Aug 2010 16:11:15 +0000
Message-ID: <AANLkTi=7BKfWhuRE2pQjQxM5cCVEW_L0ySUXSZnoELuo@mail.gmail.com>
References: <1281948382.1888.7.camel@chotu>
	<20100816121658.GT3315@think>
	<7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5BC@mail.corp.imt-systems.com>
	<m3iq3a4l46.fsf@pullcord.laptop.org>
	<AANLkTin-q4N9g3=ymsiJy051xts3b2vioNdqku6DMEzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin-q4N9g3=ymsiJy051xts3b2vioNdqku6DMEzQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I thought this would go to the list automatically.

Here it is now.


---------- Forwarded message ----------
=46rom: Evert Vorster <evorster@gmail.com>
Date: Mon, Aug 16, 2010 at 4:04 PM
Subject: Re: 2.6.36-rc1 btrfs still unstable
To: Chris Ball <cjb@laptop.org>


I lost a btrfs not long ago, and this is the reason I am on this list.
Lucky for me, I have more than one backup of everything. Most people
that use computers do not. Also, they unplug USB disks without
unmounting, etc....

I don't think the signboards are big enough.

Most people assume that there is some way of fixing a broken file
system, and finding out the btrfs does not have one usually is quite
surprising and just a little too late.

I was under the impression that with atomic writes it's impossible to
mess up a file system?

-Evert-

On Mon, Aug 16, 2010 at 3:45 PM, Chris Ball <cjb@laptop.org> wrote:
> Hi,
>
> =A0 > the other big question is:
> =A0 >
> =A0 > Is btrfs with 2.6.36 really rockstable and ready to use in
> =A0 > productive environments?
>
> No, certainly not until there's a working fsck tool -- at the moment
> it's rather easy to kill a btrfs by just losing power.
>
> I just added a paragraph to the main page of the wiki about this,
> since we've had a few people on IRC express surprise that their
> filesystem aren't fixable after power loss. =A0Feel free to reword:
>
> =A0 Note that Btrfs does not yet have a fsck tool that can fix errors=
=2E
> =A0 While Btrfs is stable on a stable machine, it is currently possib=
le
> =A0 to corrupt a filesystem irrecoverably if your machine crashes or
> =A0 loses power. =A0This will be fixed when the fsck tool is ready.
>
> - Chris.
> --
> Chris Ball =A0 <cjb@laptop.org>
> One Laptop Per Child
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--
http://magnatune.com - Music shared the way it should be.



--=20
http://magnatune.com - Music shared the way it should be.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
