Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sender163-mail.zoho.com ([74.201.84.163]:24597 "EHLO
	sender163-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbcFFCko (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 22:40:44 -0400
From: "James Johnston" <johnstonj.public@codenest.com>
To: "'Chris Murphy'" <lists@colorremedies.com>,
        "'Mladen Milinkovic'" <maxrd2@smoothware.net>
Cc: "'Austin S. Hemmelgarn'" <ahferroin7@gmail.com>,
        "'Martin'" <rc6encrypted@gmail.com>,
        "'Btrfs BTRFS'" <linux-btrfs@vger.kernel.org>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>	<aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>	<CAJCQCtQ4i0PWisxi708EmrTuPHH7hNEkKfY28GjTG2s4Sk3DYQ@mail.gmail.com>	<73123a36-6502-d735-c813-fce43b620e5a@smoothware.net> <CAJCQCtTDbb47n8G0Skay5QEcY_9Qjjv_gRyCkG+-L7YKyes=7g@mail.gmail.com>
In-Reply-To: <CAJCQCtTDbb47n8G0Skay5QEcY_9Qjjv_gRyCkG+-L7YKyes=7g@mail.gmail.com>
Subject: RE: Recommended why to use btrfs for production?
Date: Mon, 6 Jun 2016 02:40:36 -0000
Message-ID: <0b4e01d1bf9c$cf89c110$6e9d4330$@codenest.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/06/2016 at 01:47, Chris Murphy wrote:
> On Sun, Jun 5, 2016 at 4:45 AM, Mladen Milinkovic <maxrd2@smoothware.net> wrote:
> > On 06/03/2016 04:05 PM, Chris Murphy wrote:
> >> Make certain the kernel command timer value is greater than the driver
> >> error recovery timeout. The former is found in sysfs, per block
> >> device, the latter can be get and set with smartctl. Wrong
> >> configuration is common (it's actually the default) when using
> >> consumer drives, and inevitably leads to problems, even the loss of
> >> the entire array. It really is a terrible default.
> >
> > Since it's first time i've heard of this I did some googling.
> >
> > Here's some nice article about these timeouts:
> > http://strugglers.net/~andy/blog/2015/11/09/linux-software-raid-and-drive-
> timeouts/comment-page-1/
> >
> > And some udev rules that should apply this automatically:
> > http://comments.gmane.org/gmane.linux.raid/48193
> 
> Yes it's a constant problem that pops up on the linux-raid list.
> Sometimes the list is quiet on this issue but it really seems like
> it's once a week. From last week...
> 
> http://www.spinics.net/lists/raid/msg52447.html

It seems like it would be useful if the distributions or the kernel could
automatically set the kernel timeout to an appropriate value.  If the TLER can be
indeed be queried via smartctl, then it would be easy to automatically read it,
and then calculate a suitable timeout.  A RAID-oriented drive would end up leaving
the current 30 seconds, while if it can't successfully query for TLER or the drive
just doesn't support it, then assume a consumer drive and set timeout for 180
seconds.

That way, zero user configuration would be needed in the common case.  Or is it
not that simple?

James


