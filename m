Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab3JUMhb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 08:37:31 -0400
Date: Mon, 21 Oct 2013 14:37:28 +0200
From: David Sterba <dsterba@suse.cz>
To: david pu <pulq.ustc@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: task btrfs-transacti:1076 blocked for more than 120 seconds
Message-ID: <20131021123728.GJ1032@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CA+yNr1dyhC1=Rv=wuzV-YzSdEOmEEB=OLo=SJwmSMvsvhmmZ-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+yNr1dyhC1=Rv=wuzV-YzSdEOmEEB=OLo=SJwmSMvsvhmmZ-g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 21, 2013 at 04:36:41PM +0800, david pu wrote:
> I'm running into btrfs-transaction hang issue with below call trace
> from dmesg[1].
> when this issue happens, all filesystem r/w access will be blocked and
> no response in terminal. I'm using Ubuntu raring(linux 3.2 kernel)
> 64bit kernel as below:
> Linux dpu-e6410 3.2.0-36-generic #57-Ubuntu SMP Tue Jan 8 21:44:52 UTC
> 2013 x86_64 x86_64 x86_64 GNU/Linux
> 
> is it a known issue? How to recover from such task hung status?

The message can occur when

1) system is under heavy load or fragmentation slows down the IO, this
is harmless, the warnings stop after a few cycles

2) it's a bug and the system cannot move forward due to a deadlock, the
warnings appear repeatedly and the IO seems to be stalled

For a 3.2 kernel it's possible that the bug is there.

david
