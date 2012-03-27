From: Chris Samuel <chris@csamuel.org>
Subject: Re: btrfs: open_ctree failed
Date: Tue, 27 Mar 2012 11:20:55 +1100
Message-ID: <4F7107E7.8050908@csamuel.org>
References: <CANDob0+rwkLGeJg4kP+TpPpN8VOdrOV684F5YiLC6+BkzYehHA@mail.gmail.com> <CANDob0+cBXnNH1dZ5socF7vaNoAB8wHACA4cN-w_1Z4T=VKUbA@mail.gmail.com> <20120326215740.GA2597@carfax.org.uk> <CANDob0JDQKObq8L2s8E7D9x_=k=MgsaMu=g0DBaZqGqCO_O70Q@mail.gmail.com> <20120326224729.GB2597@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, Not Zippy <notzippy@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120326224729.GB2597@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 27/03/12 09:47, Hugo Mills wrote:

>    I'd definitely recommend running as recent a kernel as you can --
> either the last released (3.3 in this case)

I'm not sure I'd recommend 3.3; there were a number of reports of a
regression regarding preamture ENOSPC in that code which was bisected to
a particular change but I didn't see any evidence of it being fixed in
3.3 (only 2 unrelated fixes were merged after rc6, where this problem
was confirmed).

 https://lkml.org/lkml/2012/3/9/624

I'm currently running 3.2.13 from the Ubuntu site here:

 http://kernel.ubuntu.com/~kernel-ppa/mainline/

I just download the deb via Lynx and install it with dpkg -i $PACKAGE.

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
