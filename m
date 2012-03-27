From: Not Zippy <notzippy@gmail.com>
Subject: Re: btrfs: open_ctree failed
Date: Tue, 27 Mar 2012 05:58:17 -0700
Message-ID: <CANDob0KMJXQT47MusDnwTMLV5E=whSOSp+E8zAw2ZF6hTsNyOg@mail.gmail.com>
References: <CANDob0+rwkLGeJg4kP+TpPpN8VOdrOV684F5YiLC6+BkzYehHA@mail.gmail.com>
 <CANDob0+cBXnNH1dZ5socF7vaNoAB8wHACA4cN-w_1Z4T=VKUbA@mail.gmail.com>
 <20120326215740.GA2597@carfax.org.uk> <CANDob0JDQKObq8L2s8E7D9x_=k=MgsaMu=g0DBaZqGqCO_O70Q@mail.gmail.com>
 <20120326224729.GB2597@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, Not Zippy <notzippy@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120326224729.GB2597@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

One entire subvolume was restored. But there were 4 subvolumes on that
partition. Is there a way to specify/force the restore of a different
subvolume ?

find-root seems to only find a single root.

thanks

On Mon, Mar 26, 2012 at 3:47 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Mar 26, 2012 at 03:36:13PM -0700, Not Zippy wrote:
>> Hugo
>> I did try the dangerdonteveruse branch and thats the error btrfsck
>> --repair gave me.
>
> =A0 Oooh, a brave one, I see. ;)
>
>> Looks like the btrfs-restore command may work (thanks!). And yes I
>> do have backups for the important data - I had some other data on
>> there which would need to be d/l again..
>
> =A0 Excellent. We don't need to set the hounds onto you, then.
>
>> I don't dabble that much with the kernel - this is a straight ubuntu
>> which I regularly do their updates - Can I advance the kernel beyond=
 ?
>
> =A0 Yes, there's a PPA[1] for it (documented in the "Getting Started"
> page on the btrfs wiki at [2]).
>
> [1] http://kernel.ubuntu.com/~kernel-ppa/mainline/
> [2] http://btrfs.ipv5.de/index.php?title=3DGetting_started#Ubuntu_Lin=
ux
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
