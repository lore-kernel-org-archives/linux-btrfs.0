Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 50-193-208-193-static.hfc.comcastbusiness.net ([50.193.208.193]:52212
	"EHLO tetsuo.zabbo.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2GETB0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 15:01:26 -0400
Message-ID: <4FF5E485.2040107@zabbo.net>
Date: Thu, 05 Jul 2012 12:01:25 -0700
From: Zach Brown <zab@zabbo.net>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: Alexander Block <ablock84@googlemail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/7] Btrfs: introduce subvol uuids and times
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com> <1341409108-13567-5-git-send-email-ablock84@googlemail.com> <4FF5C9F2.903@zabbo.net> <CAB9VWqAoKXCU4T93_aMSC_2rgcQT7MVWVVaVPMhvHrG7sDVStQ@mail.gmail.com> <4FF5CCD0.5000107@zabbo.net> <20120705183343.GA5403@zambezi.lan> <4FF5DEF4.3060104@zabbo.net> <20120705185949.GB5403@zambezi.lan>
In-Reply-To: <20120705185949.GB5403@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/05/2012 11:59 AM, Ilya Dryomov wrote:

> What if you are on a big-endian machine with a big-endian kernel and
> userspace?  Everything on-disk should be little-endian, so if you are
> going to write stuff you got from userspace to disk, at some point you
> have to make sure you are writing out bytes in the right order.
>
> Alex already does that, so my remarks are moot ;)

Yeah, indeed, we were only talking about the ioctl interface crossing
the user<->kernel barrier :).

- z
