From: Gregory Maxwell <gmaxwell@gmail.com>
Subject: Re: worse than expected compression ratios with -o compress
Date: Thu, 21 Jan 2010 15:04:56 -0500
Message-ID: <e692861c1001211204u7b16efe9tf7ee5703054caf76@mail.gmail.com>
References: <alpine.DEB.2.00.1001161048330.16549@alumni-linux.ccs.neu.edu>
	 <20100118141240.GA10710@localhost.localdomain>
	 <20100118212951.GC4065@think>
	 <alpine.DEB.2.00.1001181706590.31608@alumni-linux.ccs.neu.edu>
	 <20100120163011.GE3001@think>
	 <alpine.DEB.2.00.1001211224530.19136@alumni-linux.ccs.neu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Jim Faulkner <jfaulkne@ccs.neu.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1001211224530.19136@alumni-linux.ccs.neu.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2010 at 1:16 PM, Jim Faulkner <jfaulkne@ccs.neu.edu> wr=
ote:
>
> On Wed, 20 Jan 2010, Chris Mason wrote:
>
>> Please let me know if this improves your ratios
>
> It most certainly does! =C2=A0It also greatly reduced the time requir=
ed to copy
> the data to my (not very fast) disk. =C2=A0All my testing was done on=
 2.6.32.4.
> The line numbers in your patch were a little off for 2.6.32.4, but I =
did
> manage to apply it cleanly. =C2=A0Here's the results of my testing:
[snip]
> I'd be very happy to see the -o compress-force option in the mainline=
 kernel
> someday!


Sweet. But I think a force mount option is an unreasonably blunt tool.

I think two things would be nice:

(1) Fix the compression decision, I think this example suggests that
something is broken. (I'd noticed poorer than expected compression on
my laptop, but I'd chalked it up to the 64k blocks=E2=80=A6 now I'm not=
 so
confident)

(2) An IOCTL for compression control.  Userspace knows best, some
files ought to have a different compression policy.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
