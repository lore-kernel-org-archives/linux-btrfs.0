Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52711 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab2GES7u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 14:59:50 -0400
Received: by wgbdr13 with SMTP id dr13so8596195wgb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jul 2012 11:59:49 -0700 (PDT)
Date: Thu, 5 Jul 2012 21:59:49 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Zach Brown <zab@zabbo.net>
Cc: Alexander Block <ablock84@googlemail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/7] Btrfs: introduce subvol uuids and times
Message-ID: <20120705185949.GB5403@zambezi.lan>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
 <1341409108-13567-5-git-send-email-ablock84@googlemail.com>
 <4FF5C9F2.903@zabbo.net>
 <CAB9VWqAoKXCU4T93_aMSC_2rgcQT7MVWVVaVPMhvHrG7sDVStQ@mail.gmail.com>
 <4FF5CCD0.5000107@zabbo.net>
 <20120705183343.GA5403@zambezi.lan>
 <4FF5DEF4.3060104@zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FF5DEF4.3060104@zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 05, 2012 at 11:37:40AM -0700, Zach Brown wrote:
> 
> >and take endianess into account with le{64,32}_to_cpu and
> >cpu_to_le{64,32} macros.
> 
> The kernel doesn't support system calls from userspace of a different
> endianness, no worries there :)

What if you are on a big-endian machine with a big-endian kernel and
userspace?  Everything on-disk should be little-endian, so if you are
going to write stuff you got from userspace to disk, at some point you
have to make sure you are writing out bytes in the right order.

Alex already does that, so my remarks are moot ;)

+       root_item->stime.sec = cpu_to_le64(sa->stime.tv_sec);
+       root_item->stime.nsec = cpu_to_le64(sa->stime.tv_nsec);
+       root_item->rtime.sec = cpu_to_le64(sa->rtime.tv_sec);
+       root_item->rtime.nsec = cpu_to_le64(sa->rtime.tv_nsec);

Thanks,

		Ilya
