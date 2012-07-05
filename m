Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 50-193-208-193-static.hfc.comcastbusiness.net ([50.193.208.193]:52200
	"EHLO tetsuo.zabbo.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab2GERUR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 13:20:17 -0400
Message-ID: <4FF5CCD0.5000107@zabbo.net>
Date: Thu, 05 Jul 2012 10:20:16 -0700
From: Zach Brown <zab@zabbo.net>
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/7] Btrfs: introduce subvol uuids and times
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com> <1341409108-13567-5-git-send-email-ablock84@googlemail.com> <4FF5C9F2.903@zabbo.net> <CAB9VWqAoKXCU4T93_aMSC_2rgcQT7MVWVVaVPMhvHrG7sDVStQ@mail.gmail.com>
In-Reply-To: <CAB9VWqAoKXCU4T93_aMSC_2rgcQT7MVWVVaVPMhvHrG7sDVStQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/05/2012 10:14 AM, Alexander Block wrote:
> On Thu, Jul 5, 2012 at 7:08 PM, Zach Brown<zab@zabbo.net>  wrote:
>>
>> Careful, timespec will be different sizes in 32bit userspace and a 64bit
>> kernel.  I'd use btrfs_timespec to get a fixed size timespec and avoid
>> all the compat_timespec noise.  (I'd then also worry about padding and
>> might pack the struct.. I always lose track of the best practice across
>> all archs.)

> Hmm we currently don't have ctree.h in ioctl.h. Can I include it there
> or are there problems with that? As an alternative I could define my
> own struct for that.

Hmm, yeah, it looks like ioctl.h is well isolated and doesn't really
have a precedent for pulling in format bits from the kernel
implementation.

I'd do as you suggested and just make its own ioctl_timespec with a
comment that its duplicating other similar structures to keep ioctl.h
from getting tangled up in the kernel-side includes.

- z
