From: Roman Kapusta <roman.kapusta@gmail.com>
Subject: Re: some issues with lots of snapshots
Date: Fri, 29 Oct 2010 08:31:05 +0200
Message-ID: <AANLkTi=r+Q4Q8wEC9SB6wG9zFF1nmTwQ=qQ7=6vxbu2Z@mail.gmail.com>
References: <20101026102853.GX13205@jeru.org> <20101026151528.555ccee9@zaphod>
 <20101027083948.GA13205@jeru.org> <20101028180341.7dd5ad12@zaphod>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Pat Regan <thehead@patshead.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101028180341.7dd5ad12@zaphod>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 29, 2010 at 00:03, Pat Regan <thehead@patshead.com> wrote:
> On Wed, 27 Oct 2010 10:39:48 +0200
> Xavier Nicollet <nicollet@jeru.org> wrote:
>
>> Le 26 octobre 2010 =C3=A0 15:15, Pat Regan a =C3=A9crit:
>> > I turned off the 5-minute snapshots and I'm now just keeping 4
>> > weekly, 7 daily, and 24 hourly snapshots alive.
>>
>> I have just rebooted and I am going with /15 minutes interval.
>>
>
> I'm just replying so this is documented somewhere.
>
> After I read your message I decided to turn on snaphots at 15 minute
> intervals yesterday. =C2=A0This morning I had snapshot processing fil=
ling up
> my process list again.

I think there is no problem with snapshot creation every 5 or 15
minutes, but problem is with deleting old snapshots every 5 or 15
minutes. Can you try to run cleanup of old snapshots only once per day
to check if it will improve?

>
> My laptop is a quad core i7 and the btrfs file system is on an Intel
> X25-M 80 gig. =C2=A0I don't know if a fast drives increases or decrea=
ses the
> likelihood of having this problem or not.
>
> Pat
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
