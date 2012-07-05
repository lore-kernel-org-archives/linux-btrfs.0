Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53863 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab2GETnh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 15:43:37 -0400
Received: by pbbrp8 with SMTP id rp8so13252496pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jul 2012 12:43:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120705192444.GA7950@zambezi.lan>
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
	<20120705192444.GA7950@zambezi.lan>
Date: Thu, 5 Jul 2012 21:43:36 +0200
Message-ID: <CAB9VWqBHJEtdURCm+6kk4cVo1nHrWX--AWwwD2_brsqEPLPKEA@mail.gmail.com>
Subject: Re: [RFC PATCH 4/7] Btrfs: introduce subvol uuids and times
From: Alexander Block <ablock84@googlemail.com>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Zach Brown <zab@zabbo.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 5, 2012 at 9:24 PM, Ilya Dryomov <idryomov@gmail.com> wrote:
> On Thu, Jul 05, 2012 at 09:18:41PM +0200, Alexander Block wrote:
>> On Thu, Jul 5, 2012 at 9:01 PM, Zach Brown <zab@zabbo.net> wrote:
>> > On 07/05/2012 11:59 AM, Ilya Dryomov wrote:
>> >
>> >> What if you are on a big-endian machine with a big-endian kernel and
>> >> userspace?  Everything on-disk should be little-endian, so if you are
>> >> going to write stuff you got from userspace to disk, at some point you
>> >> have to make sure you are writing out bytes in the right order.
>> >>
>> >> Alex already does that, so my remarks are moot ;)
>> >
>> >
>> > Yeah, indeed, we were only talking about the ioctl interface crossing
>> > the user<->kernel barrier :).
>> >
>> I decided to not use __leXX variables in the new btrfs_ioctl_timespec
>> structure because as most arguments found ioctls are currently in cpu
>> dependent endianess. The kernel will then do the endianess conversion
>> as it already did with struct timespec.
>
> That's exactly the point of adding btrfs_ioctl_timespec instead of just
> copying btrfs_timespec definition.
Pushed to kernel and user space repos.
>
> Thanks,
>
>                 Ilya
