Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:39486 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbcAGT2d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jan 2016 14:28:33 -0500
Subject: Re: btrfs trim erases bootloader area
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        The development of GNU GRUB <grub-devel@gnu.org>,
        linux-btrfs@vger.kernel.org
References: <568EB86F.7070800@gmail.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <568EBA24.6030700@googlemail.com>
Date: Thu, 7 Jan 2016 20:19:00 +0100
MIME-Version: 1.0
In-Reply-To: <568EB86F.7070800@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/07/16 20:11, Andrei Borzenkov wrote:
> As discussed on opensuse-factory list, running fstrim on btrfs erases
> bootloader area, rendering system unbootable. See
> 
> https://lists.opensuse.org/opensuse-factory/2016-01/msg00067.html
> https://lists.opensuse.org/opensuse-factory/2016-01/msg00090.html
> 
> and follow-ups that demonstrate that beginning of device gets zeroed out.
> 
> Not sure what we can do, but from GRUB side I can only see disabling
> embedding support on btrfs entirely.

Since you're probably not on the btrfs list and missed it earlier
today: http://www.spinics.net/lists/linux-btrfs/msg50860.html

-h

