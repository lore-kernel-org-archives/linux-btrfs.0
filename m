From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Slow link/Capacity changed + Kernel OOPS... possible hardware
 issues, ideas?
Date: Fri, 8 Oct 2010 18:28:32 -0500
Message-ID: <AANLkTi=iq1Qovx99K7zjfKxPbrXtMoVBGExr3SuJnWD=@mail.gmail.com>
References: <AANLkTikcaAFvosjpnZpG9Rp8C1Q+nqb1=Uaftyzh5fXp@mail.gmail.com>
	<20101008145319.GK4804@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	C Anthony Risinger <anthony@extof.me>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101008145319.GK4804@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 8, 2010 at 9:53 AM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> On Thu, Oct 07, 2010 at 10:07:47PM -0500, C Anthony Risinger wrote:
>>
>> the mayhem starts with:
>>
>> "Oct =A08 02:38:26 (none) kernel: btrfs bad tree block start 2463035=
8016
>> 24630292480"
>
> Ok, so the drive has decided to jumble up our blocks a little bit. =A0=
This
> message means we're finding the wrong data at a given offset.
>
> I can help you copy things off but I don't think this FS is going to =
be
> good any longer. =A0Are you interested in copying the latest bits off=
 or
> do you just want to cut your losses?

yeah i thought about it a bit today... i _really_ appreciate the offer
but i don't want to waste your time; there wasn't anything on it that
i needed, no worries, i can just set up again, and this time i'll make
sure i actually backup the whole system.

however, do you think my SSD drive is bad (especially from the later
errors)?  i copied /boot off the disk just fine ~20+ times; i thought
if it was bad it would have randomly failed but it didn't.

how would you recommend that i test to see if the SSD is still good?
since if it's not, i can probably get ASUS to replace it.

thanks,

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
