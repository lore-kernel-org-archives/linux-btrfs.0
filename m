Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bl2on0069.outbound.protection.outlook.com ([65.55.169.69]:29666
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750744AbbLZG2F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Dec 2015 01:28:05 -0500
From: David Schulz <dschulz@ucalgary.ca>
To: Duncan <1i5t5.duncan@cox.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Loss of connection to Half of the drives
Date: Sat, 26 Dec 2015 06:12:38 +0000
Message-ID: <50B1AB1702491A47883230E9A266A9880CD1FEE6@ITCIMEXCH02.uc.ucalgary.ca>
References: <CAD=LdFREn-jTEXTHw_Q+zbnva3dSWtb_aKcYS+6paidBjH7U8A@mail.gmail.com>
	<CAJCQCtStfVppb-NU0EjeAVf6cs08cdcWCEDYLx4zMoOzbG0W+A@mail.gmail.com>
	<CAC=t97Ac07=ZFZ1nShfWc0ik50D90hBJM3bSEiLmHbKK36G9Xw@mail.gmail.com>
	<pan$9b1ad$a377a340$8346d054$a731dd54@cox.net>
	<CAC=t97BW6vYgi7edM=PknJDep9nJxDbOYpgPKi6L2u-J3hMwqQ@mail.gmail.com>
	<pan$82f3e$e3af006a$d15f1d6c$4b07b3ba@cox.net>
	<CAC=t97BsV1FJr+icGLY8XKyLjejG-k0frSuPWZtRu=N5znfXEw@mail.gmail.com>
	<CAJCQCtRXBPBsiAH65JKFy7+5sFM7fnrAKg-7ESaoeUTsmMqdrg@mail.gmail.com>
 <pan$88899$a0c696db$cb878db4$9a294bbd@cox.net>
In-Reply-To: <pan$88899$a0c696db$cb878db4$9a294bbd@cox.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

HI Everyone,

I suppose I have an answer to my initial question.  Thanks for all the discussion.  I'd just like to stress the importance in my opinion of btrfs understanding that drives are missing/dead and to halt all operations that would advance the metadata in the case of a temporary disconnection of a portion of the drives.  Even if it requires a tool to restore consistency after this sort of failure.

I mentioned the btrfs rescue command with the mismatching fsid message.  After dd'ing /dev/zero to all but the boot drive, the fsid mismatch went away, but the tool still segfaults on the filesystem after losing 1/2 of the drives, so at best, the fsid mismatch error was just cosmetic.

-Dave


> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Duncan
> Sent: Thursday, December 24, 2015 5:23 PM
> To: linux-btrfs@vger.kernel.org
> Subject: Re: Loss of connection to Half of the drives
> 
> Chris Murphy posted on Thu, 24 Dec 2015 13:57:35 -0700 as excerpted:
> 
> >> All this makes me ask why?  Why implement Raid10 in this non-standard
> >> fashion and create this mess of compromise?
> >
> > Because it was a straightforward extension of how the file system
> > already behaves. To implement drive based copies rather than chunk
> > based copies is a totally different strategy that actually negates how
> > btrfs does allocation, and would require things like logically
> > checking for mirrored pairs being the same size +/- maybe 1% similar to
> mdadm.
> >
> > And keep in mind the raid10 multiple device failure is not fixed, not
> > just any additional failure is OK. It just depends on aviation's
> > equivalent of "big sky theory" for air traffic separation. Yes the
> > probability of mirror A's two drives dying is next to zero, but it's
> > not zero. If you're building arrays depending on it being zero, well
> > that's not a good idea. The way to look at it is more of a bonus of
> > uptime, rather than depending on it in design. You design for it's
> > scaleable performance, which it does have.
> 
> This.
> 
> Raid10 doesn't guard against any random two devices going down, let alone a
> random half of all devices, and anyone running a raid10 with the assumption
> that it does is simply asking for trouble.
> 
> What it /does/ do, in the device-scope raid10 case, is minimize the /chance/
> that two devices down will take out the entire array, particularly on big raid10
> arrays, because the chances of any random two devices being the two devices
> mirroring the same content goes down as the number of total devices goes up.
> 
> But as Chris Murphy says, btrfs is inherently chunk-scope, not drive- scope.  In
> fact, that's a very large part of its multi-device flexibility in the first place.  And
> raid10 functionality was a straightforward extension of the existing raid1 and
> raid0 functionality, simply combining them into one at the same filesystem
> level with comparatively little extra code.  And that, again, was due to the
> incredible flexibility that chunk-scope granularity exposes.
> 
> Of course one drawback is that with chunk-scope allocation, the per- device
> allocation of successive chunks is likely to vary, meaning you lose the low
> device-scope chance of two random devices taking the entire array down,
> because the chances of those two random devices containing /both/ mirrors of
> _some_ chunk-strips is much higher than it is with device-scope allocation and
> both copies of the device-scope mirror, but that's a taken tradeoff that allowed
> the exposure of striped-mirrors
> raid10 functionality in the first place, and as Chris and I are both saying, any
> admin relying on chance to cover his *** in the two-device failure case on a
> raid10 is already asking for trouble.
> 
> But there are known workarounds for that problem, the layers on top of layers
> scenario, raid0+1 or raid1+0, each with its own advantages and disadvantages.
> Of course, btrfs arguably being a layering violation incorporating both
> filesystem and block level layers, tho it's done with specific advantages in mind,
> does by definition of implementation have to be the top layer, which does
> impose some limits if other btrfs features such as checksumming and data
> integrity are wanted, but it remains simply a question of matching the tradeoffs
> the technology makes against the ones you're willing to make, within the
> limitations of the available tradeoffs pool, of course.
> 
> 
> Meanwhile, there has been discussion of enhancements to the chunk allocator
> that would let you pick allocation schemes.  Presumably, this would include the
> ability to nail down mirror allocation to specific devices, which seems to be the
> requested feature here.  However, while definitely possible within the flexible
> framework btrfs' chunk-scope allocation provides, to my knowledge at least,
> this isn't anywhere on the existing near or intermediate term roadmap, so
> implementation by current developers is likely out beyond the five year time
> frame, along with a lot of other such features, making it effectively "bluesky",
> aka, possible, and would be nice, but no near or intermediate term plans, tho if
> someone with that itch to scratch appears with the patches ready to go, who
> moreover is willing to join the btrfs team and help maintain them longer term,
> assuming there's no huge personality clash, the feature could be implemented
> rather sooner, perhaps with initial implementation in a year or two and relative
> stability in two to three.
> 
> In that regard, it's more ENOTIMPLEMENTED, rather than EBLACKLISTED.
> There's all sorts of features that /could/ be implemented, and this one simply
> hasn't been a priority for existing developers, given the other features they've
> found to be more pressing.  But it may indeed eventually come, five or ten
> years out, sooner if a suitable developer with suitable interest and social
> compatibility with existing devs is found to champion the cause.
> 
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master -- and if you use the program, he
> is your master."  Richard Stallman
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
