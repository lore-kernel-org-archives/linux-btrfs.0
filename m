Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57191 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab2GETYn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 15:24:43 -0400
Received: by wgbdr13 with SMTP id dr13so8613052wgb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jul 2012 12:24:42 -0700 (PDT)
Date: Thu, 5 Jul 2012 22:24:44 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: Zach Brown <zab@zabbo.net>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/7] Btrfs: introduce subvol uuids and times
Message-ID: <20120705192444.GA7950@zambezi.lan>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
 <1341409108-13567-5-git-send-email-ablock84@googlemail.com>
 <4FF5C9F2.903@zabbo.net>
 <CAB9VWqAoKXCU4T93_aMSC_2rgcQT7MVWVVaVPMhvHrG7sDVStQ@mail.gmail.com>
 <4FF5CCD0.5000107@zabbo.net>
 <20120705183343.GA5403@zambezi.lan>
 <4FF5DEF4.3060104@zabbo.net>
 <20120705185949.GB5403@zambezi.lan>
 <4FF5E485.2040107@zabbo.net>
 <CAB9VWqAH_NFxDNY=B-=-K+PwQ6ycEfwCVPyusx1rM+cxjzcA=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB9VWqAH_NFxDNY=B-=-K+PwQ6ycEfwCVPyusx1rM+cxjzcA=g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 05, 2012 at 09:18:41PM +0200, Alexander Block wrote:
> On Thu, Jul 5, 2012 at 9:01 PM, Zach Brown <zab@zabbo.net> wrote:
> > On 07/05/2012 11:59 AM, Ilya Dryomov wrote:
> >
> >> What if you are on a big-endian machine with a big-endian kernel and
> >> userspace?  Everything on-disk should be little-endian, so if you are
> >> going to write stuff you got from userspace to disk, at some point you
> >> have to make sure you are writing out bytes in the right order.
> >>
> >> Alex already does that, so my remarks are moot ;)
> >
> >
> > Yeah, indeed, we were only talking about the ioctl interface crossing
> > the user<->kernel barrier :).
> >
> I decided to not use __leXX variables in the new btrfs_ioctl_timespec
> structure because as most arguments found ioctls are currently in cpu
> dependent endianess. The kernel will then do the endianess conversion
> as it already did with struct timespec.

That's exactly the point of adding btrfs_ioctl_timespec instead of just
copying btrfs_timespec definition.

Thanks,

		Ilya
