From: jim owens <jowens@hp.com>
Subject: Re: RAID-10 arrays built with btrfs & md report 2x difference in
 	available size?
Date: Sat, 30 Jan 2010 10:36:53 -0500
Message-ID: <4B645215.6060006@hp.com>
References: <048D5581-1D1D-4F82-9FE3-0DBC1106EDB4@kupper.org>	 <c67eed301001291413p51f248d6y7f3b2ac9ba02c447@mail.gmail.com>	 <4B63634F.6090600@computer.org> <4B63735E.1060609@hp.com> <c67eed301001291553m8d59819oaab942b42e10c35d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: RK <rkasl@computer.org>, linux-btrfs <linux-btrfs@vger.kernel.org>
To: 0bo0 <0.bugs.only.0@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c67eed301001291553m8d59819oaab942b42e10c35d@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

0bo0 wrote:
> On Fri, Jan 29, 2010 at 3:46 PM, jim owens <jowens@hp.com> wrote:
>> but it is the only method
>> that can remain accurate under the mixed raid modes possible
>> on a per-file-basis in btrfs.
> 
> can you clarify, then, the intention/goal behind cmason's
> 
> "df is lying.  The total bytes in the FS include all 4 drives.  I need to
> fix up the math for the total available space."

Well I don't have the message where Chris said that, but I know he
did not mean that "df" will be changed to report like an md raid.

> Is the goal NOT to accurately represent the actual available space?

Yes, but in btrfs "accurate" is RAW byte count, however...

> Seems rather odd that users are simply to know/accept that "available
> space" in btrfs RAID-10 != "available space" in md RIAD-10 ...

Developers are aware that users want a method to get space values
that reflect the raid state(s) of their filesystem.

So Josef Bacik has sent patches to btrfs and btrfs-progs that
allow you to see raid-mode data and metadata adjusted values
with btrfs-ctrl -i instead of using "df".

These patches have not been merged yet so you will have to pull
them and apply yourself.

But there remains the fact that the command "df" is not accurate
and will never be accurate for many other filesystems.  It is just
that the user perception of error is much larger with some btrfs
raid modes.

And at the end of the day, you can not say md value == fs value
is a requirement. 

jim
