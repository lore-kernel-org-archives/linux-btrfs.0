Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f48.google.com ([209.85.213.48]:36616 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbbACFbP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jan 2015 00:31:15 -0500
Received: by mail-yh0-f48.google.com with SMTP id i57so9221843yha.7
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Jan 2015 21:31:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54A36A7C.1000005@ubuntu.com>
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>
	<CAJCQCtQ-DkJh5tg1gWuv6EW=enm66jx16jrtXhXiPvhauRnJ9w@mail.gmail.com>
	<20141223211605.GC436@hungrycats.org>
	<CAJCQCtTK2OinQZakArtX4BD=JAz6UJr=dhc2xUbcqJJL1v6Kkw@mail.gmail.com>
	<549F7539.4050801@ubuntu.com>
	<CAJCQCtQOxfoeE9xRLpqohHK8WXW63x1gsOgJQEc8TtbRp67RoA@mail.gmail.com>
	<54A30F19.5050801@ubuntu.com>
	<CAJCQCtSyu7dvp9SoF4u6QV9hF3jAQLtpYv8-6MOHSoP_NQyQ7A@mail.gmail.com>
	<54A36A7C.1000005@ubuntu.com>
Date: Fri, 2 Jan 2015 22:31:13 -0700
Message-ID: <CAJCQCtR5qZmD2RgfQMSUe9BLtUtimTyf-itBM1Y+9hiRftfwgg@mail.gmail.com>
Subject: Re: Uncorrectable errors on RAID-1?
From: Chris Murphy <lists@colorremedies.com>
To: Phillip Susi <psusi@ubuntu.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 30, 2014 at 8:16 PM, Phillip Susi <psusi@ubuntu.com> wrote:
> Just because I want a raid doesn't mean I need it to operate reliably
> 24x7.  For that matter, it has long been established that power
> cycling drives puts more wear and tear on them and as a general rule,
> leaving them on 24x7 results in them lasting longer.

It's not a made to order hard drive industry. Maybe one day you'll be
able to 3D print your own with its own specs.

>
>> And of course you completely ignored, and deleted, my point about
>> the difference in warranties.
>
> Because I don't care?

Sticking fingers in your ears doesn't change the fact there's a
measurable difference in support requirements.


> It's nice and all that they warranty the more
> expensive drive more, and it may possibly even mean that they are
> actually more reliable ( but not likely ), but that doesn't mean that
> the system should have an unnecessarily terrible response to the
> behavior of the cheaper drives.  Is it worth recommending the more
> expensive drives?  Sure... but the system should also handle the
> cheaper drives with grace.

This is architecture astronaut territory.

The system only has a terrible response for two reasons: 1. The user
spec'd the wrong hardware for the use case; 2. The distro isn't
automatically leveraging existing ways to mitigate that user mistake
by changing either SCT ERC on the drives, or the SCSI command timer
for each block device.

Now, even though that solution *might* mean long recoveries on
occasion, it's still better than link reset behavior which is what we
have today because it causes the underlying problem to be fixed by
md/dm/Btrfs once the read error is reported. But no distro has
implemented this $500 man hour solution. Instead you're suggesting a
$500,000 fix that will take hundreds of man hours and end user testing
to find all the edge cases. It's like, seriously, WTF?


>> Does the SATA specification require configurable SCT ERC? Does it
>> require even supporting SCT ERC? I think your argument is flawed
>> by mis-distributing the economic burden while simultaneously
>> denying one even exists or that these companies should just eat the
>> cost differential if it does. In any case the argument is asinine.
>
> There didn't used to be any such thing; drives simply did not *ever*
> go into absurdly long internal retries so there was no need.  The fact
> that they do these days I consider a misfeature, and one that *can* be
> worked around in software, which is the point here.

Ok well I think that's hubris unless you're a hard drive engineer.
You're referring to how drives behaved over a decade ago, when bad
sectors were persistent rather than remapped, and we had to scan the
drive at format time to build a map so the bad ones wouldn't be used
by the filesystem.


>> When the encoded data signal weakens, they effectively becomes
>> fuzzy bits. Each read produces different results. Obviously this is
>> a very rare condition or there'd be widespread panic. However, it's
>> common and expected enough that the drive manufacturers are all, to
>> very little varying degree, dealing with this problem in a similar
>> way, which is multiple reads.
>
> Sure, but the noise introduced by the read ( as opposed to the noise
> in the actual signal on the platter ) isn't that large, and so
> retrying 10,000 times isn't going to give any better results than
> retrying say, 100 times, and if the user really desires that many
> retries, they have always been able to do so in the software level
> rather than depending on the drive to try that much.  There is no
> reason for the drives to have increased their internal retries that
> much, and then deliberately withed the essentially zero cost ability
> to limit those internal retries, other than to drive customers to pay
> for the more expensive models.

http://www.seagate.com/files/www-content/support-content/documentation/product-manuals/en-us/Enterprise/Savvio/Savvio%2015K.3/100629381e.pdf

That's a high end SAS drive. It's default is to retry up to 20 times,
which takes ~1.4 seconds, per sector. But also note how it says
lowering the default increases the unrecoverable error rate. That
makes sense. So even if the probability is low that retrying up to 120
seconds could work, statistically it affects the unrecoverable error
rate positively to increase the default.

If I'm going to be a conspiracy theorist, I'd say the recoveries are
getting longer by default in order to keep the specifications
reporting sane unrecoverable error rates.

Maybe you'd prefer seeing these big, cheap, "green" drives have
shorter ERC times, with a commensurate reality check with their
unrecoverable error rate, which right now is already two orders
magnitude higher than enterprise SAS drives. So what if this means
that rate is 3 or 4 orders magnitude higher?

Now I'm just going to wait for you to suggest that sucks donkey tail
and how the manufacturer's should produce drives with the same UER as
drives 10 years ago *and* with the same error recovery times, and
charge no additional money.

OK good luck with that!

-- 
Chris Murphy
