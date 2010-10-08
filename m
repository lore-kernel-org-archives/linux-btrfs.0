From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Slow link/Capacity changed + Kernel OOPS... possible hardware
 issues, ideas?
Date: Thu, 7 Oct 2010 23:34:14 -0500
Message-ID: <AANLkTimKA-vbsEaAFBa22UCi+LrBPp3cf_Qrqqt3Z7MX@mail.gmail.com>
References: <AANLkTikcaAFvosjpnZpG9Rp8C1Q+nqb1=Uaftyzh5fXp@mail.gmail.com>
	<m37hhtmku4.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m37hhtmku4.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 7, 2010 at 10:20 PM, Chris Ball <cjb@laptop.org> wrote:
> Hi,
>
> =A0 > can anyone point me in the right direction? =A0it looks like ma=
ybe
> =A0 > the SSD is failing to me (all the "slow link" and "capacity
> =A0 > changed to 0" stuff), but i really don't know. =A0i knew there =
was
> =A0 > a reason they were selling these things cheap on Newegg!!!
>
> Yes, the read errors are coming all the way up from the hardware;
> I don't think this is a btrfs problem.
>
> There's not much btrfs could do to help, except (over time) grow
> to handle I/O errors without BUG()ing out.

hmm, i'll have to keep playing with it i guess.  /dev/sda1 is a ext2
boot partition; i tar + ssh'ed that several times to my other machine
without problems... i thought it would trip an issue if it really was
hardware, but it didn't, even after 30+ times.

i'll try to reinstall i guess, unless anyone has other input.  i'll
probably just have to ask ASUS to replace it, because i don't think
i've even had it 6mo yet...

>:-O

thanks,

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
