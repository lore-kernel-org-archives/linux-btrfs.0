From: 0bo0 <0.bugs.only.0@gmail.com>
Subject: Re: RAID-10 arrays built with btrfs & md report 2x difference in
	available size?
Date: Fri, 29 Jan 2010 15:53:01 -0800
Message-ID: <c67eed301001291553m8d59819oaab942b42e10c35d@mail.gmail.com>
References: <048D5581-1D1D-4F82-9FE3-0DBC1106EDB4@kupper.org>
	 <c67eed301001291413p51f248d6y7f3b2ac9ba02c447@mail.gmail.com>
	 <4B63634F.6090600@computer.org> <4B63735E.1060609@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: RK <rkasl@computer.org>, linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B63735E.1060609@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 29, 2010 at 3:46 PM, jim owens <jowens@hp.com> wrote:
> but it is the only method
> that can remain accurate under the mixed raid modes possible
> on a per-file-basis in btrfs.

can you clarify, then, the intention/goal behind cmason's

"df is lying.  The total bytes in the FS include all 4 drives.  I need to
fix up the math for the total available space."

Is the goal NOT to accurately represent the actual available space?
Seems rather odd that users are simply to know/accept that "available
space" in btrfs RAID-10 != "available space" in md RIAD-10 ...
