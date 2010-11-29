From: C Anthony Risinger <anthony@extof.me>
Subject: Re: [RFC-PATCH] Re: mounting arbitrary directories
Date: Mon, 29 Nov 2010 11:42:52 -0600
Message-ID: <AANLkTikvt1_kuJjF7w7toK-Mwu0kDNWm2p4yrfERZ3P3@mail.gmail.com>
References: <AANLkTi=7LY6y3BvGgkyYBTLwu=SYJjZZhL8kHusCn_vs@mail.gmail.com>
	<1290918133.14274.20.camel@nayuki>
	<-3532760747667207688@unknownmsgid>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Calvin Walton <calvin.walton@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <-3532760747667207688@unknownmsgid>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 28, 2010 at 4:07 AM, C Anthony Risinger <anthony@extof.me> =
wrote:
> On Nov 27, 2010, at 10:22 PM, Calvin Walton <calvin.walton@gmail.com>
> wrote:
>> On Sat, 2010-11-27 at 21:19 -0600, C Anthony Risinger wrote:
>>
>>> eg. if i have a "regular" directory (not a subvolume) in the top-
>>> level:
>>>
>>> /__boot
>>>
>>> i can mount it with:
>>>
>>> mount -o subvol=3D__boot /dev/sda /mnt
>>
>> The 'subvol' option actually works using the same mechanism as a bin=
d
>> mount. The fact that it works using a directory is purely a
>> coincidence
>> - I would not expect it to be officially supported, and you shouldn'=
t
>> rely on it.
>
> Hrrrm... Well I thought I'd be clever and use this little trick one
> time to update my kernel... Anyways I oops out like 3 times in a row
> (last func was <something>.clone in each IIRC) and now I'm stuck with
> only my mobile since my server isn't set up yet and my =A0SSD just
> failed on my netbook yesterday :-(
>
> Sooooo, if anyone can help me recover this partition long enough to
> grab a few things... I would be most grateful :-) I think I have
> everything critical, but I'd rather take another look :-) Right now I
> can't mount; mount is failing w/bad superblock.
>
> /me promises to never recklessly sabotage himself after being warned =
<
> 6 hrs earlier

any suggestions for me?  i dd'ed the corrupt partition to an external
disk because i need the machine back up and running, but if possible
i'd like to get the image running again.  i mounted it via loopback
and as expected got the same errors:

(will post the dmesg output next message -- left at home)
open_ctree_fd failed....
wanted XXXX found YYYY instead

the mount command itself fails with "bad superblock or ..."

i have seen others withe similar crash reports and IIRC correctly were
able to recover it (seems like something just didn't get updated right
before it locked...)

any ideas?

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
