Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:59797 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbbGJGHo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 02:07:44 -0400
MIME-Version: 1.0
Message-ID: <trinity-e4ad648c-63a0-49ee-986b-1c336ac314e9-1436508462072@3capp-webde-bs27>
From: conchur@web.de
To: "Chris Murphy" <lists@colorremedies.com>
Cc: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Subject: Aw: Re: [BUG] Fails to duplicate metadata/system
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Jul 2015 08:07:42 +0200
In-Reply-To: <CAJCQCtRvVSPjBc6GnMu8rB1WDS_xjFXabHXHE7HxWugDo_rRTw@mail.gmail.com>
References: <trinity-6ce0e74d-59bd-46bc-a3d6-a45d130708b7-1436484868276@3capp-webde-bs53>,
 <CAJCQCtRvVSPjBc6GnMu8rB1WDS_xjFXabHXHE7HxWugDo_rRTw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Gesendet: Freitag, 10. Juli 2015 um 02:51 Uhr
> Von: "Chris Murphy" <lists@colorremedies.com>
> An: conchur@web.de
> Cc: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
> Betreff: Re: [BUG] Fails to duplicate metadata/system
> On Thu, Jul 9, 2015 at 5:34 PM, <conchur@web.de> wrote:
> > Hi,
> >
> > I've noticed that a single device partition was using metadata.single and system.single instead of metadata.dup and system.dup. All tests to force conversion to dup failed.
> >
> 
> Try only -mconvert=dup and without -f flag and see if it works. I'm
> pretty sure system chunks are treated in parity with metadata chunks
> now so it doesn't need to be separately listed. And -f isn't needed
> except to reduce redundancy.

-f is also needed when operating on -s

I already tried all that and nothing worked

> If that's not it, I'm going to speculate maybe try kernel 4.0.6 and
> higher, as there was a bug in 4.0 that prevented chunk conversions but
> I thought that only applied to raid profiles, not single vs dup. The
> fix for that was commit 153c35b6cccc0c72de9fae06c8e2c8b2c47d79d4.

I have now downgraded to 3.16 and it was possible to change from single to dup. This is enough for me.


--
Chris Murphy
