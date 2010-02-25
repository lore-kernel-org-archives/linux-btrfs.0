From: Gustavo Alves <gjalves@gjalves.com.br>
Subject: Re: assertion failures
Date: Thu, 25 Feb 2010 15:28:19 -0300
Message-ID: <69e11d1f1002251028s3df20904yb9e90be36c883bbe@mail.gmail.com>
References: <20100225004004.GK25641@think>
	 <20100225140420.4EBA940954@viridian.itc.virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100225140420.4EBA940954@viridian.itc.virginia.edu>
List-ID: <linux-btrfs.vger.kernel.org>

I've got the same error before in a similar situation (24 partitions,
only two with problems). Unfortunally I erased all data after this
error. Strange that all I've done was shutdown and poweron the
machine.

----
Gustavo Junior Alves


On Thu, Feb 25, 2010 at 11:04 AM, Bill Pemberton
<wfp5p@viridian.itc.virginia.edu> wrote:
>
> >
> > I don't suppose you have the dmesg errors from the crash? =A0This e=
rror
> > shows the header in the block is incorrect, so either something was
> > written to the wrong place or not written at all.
> >
> > Have you memtest86 on this system?
> >
> > How did it crash...was a power off used to reset the machine?
> >
>
> No dmesg. =A0This has happened on two different machines that both ha=
ve
> other active btrfs filesystems, so I suspect it's not a memory issue.
> In both cases it was the same data that was being copied when the
> crash occurred.
>
> I didn't deal with the reboot in the first case, so I don't have much
> in the way of details. =A0In the second case the kernel seemed convin=
ced
> the array was having problems (and the load went way up), but the
> array was convinced it was fine. =A0A normal reboot hung and the serv=
er
> had to be powered off.
>
> Since it appears that the same operation caused the problem in both
> cases, I'm going to try to reproduce it. =A0I'll let you know if I ca=
n
> reproduce it.
>
> --
> Bill
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
