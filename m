Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout60.mail01.mtsvc.net ([216.70.64.8]:50606 "EHLO
	mailout60.mail01.mtsvc.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560AbaG3PSz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 11:18:55 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70] helo=n23.mail01.mtsvc.net)
	by mailout60.mail01.mtsvc.net with esmtps (UNKNOWN:AES256-GCM-SHA384:256)
	(Exim 4.72)
	(envelope-from <peter@hurleysoftware.com>)
	id 1XCV0D-0004qE-7A
	for linux-btrfs@vger.kernel.org; Wed, 30 Jul 2014 10:37:13 -0400
Message-ID: <53D90309.9070909@hurleysoftware.com>
Date: Wed, 30 Jul 2014 10:36:57 -0400
From: Peter Hurley <peter@hurleysoftware.com>
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Hugo Mills <hugo@carfax.org.uk>, Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Work Queue for btrfs compression writes
References: <CAPDOMVjJHbCwDVyKQ+Vuse7G76FLSLq69Ja4kmopDbjtEb_Zkw@mail.gmail.com> <20140730093821.GJ31950@carfax.org.uk> <20140730141329.GC20353@thunk.org>
In-Reply-To: <20140730141329.GC20353@thunk.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/30/2014 10:13 AM, Theodore Ts'o wrote:
> On Wed, Jul 30, 2014 at 10:38:21AM +0100, Hugo Mills wrote:
>> qemu/kvm is good for this, because it has a mode
>> that bypasses the BIOS and bootloader emulation, and just directly
>> runs a kernel from a file on the host machine. This is fast. You can
>> pass large sparse files to the VM to act as scratch disks, plus keep
>> another smaller file for the guest OS (and a copy of it so that you
>> can throw one away and make another one quickly and easily).
> 
> Nick,
> 
> The xfstests-bld/kvm-xfstests git tree I pointed out to you has an
> example of a test infrastructure which does this for ext4.  It's been
> on my todo list to support other file systems, and I have some plans
> for how to do thi, but it's been low on my priority list.  If someone
> in the btrfs development community is interested in working with me on
> this, they should contact me.

Ted,

Where is that git tree? I've been planning to set up a unit test and
regression suite for tty/serial, and wouldn't mind cribbing the
infrastructure from someone's existing work.

Regards,
Peter Hurley

