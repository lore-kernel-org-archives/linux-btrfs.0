Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm40-vm8.bullet.mail.bf1.yahoo.com ([72.30.239.216]:40439 "HELO
	nm40-vm8.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750816Ab3LXGWs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Dec 2013 01:22:48 -0500
References: <1387780037.66690.YahooMailNeo@web162601.mail.bf1.yahoo.com> <20131223093953.GH17179@carfax.org.uk>
Message-ID: <1387865775.69186.YahooMailNeo@web162602.mail.bf1.yahoo.com>
Date: Mon, 23 Dec 2013 22:16:15 -0800 (PST)
From: Nacho Man <nacho2874@yahoo.com>
Reply-To: Nacho Man <nacho2874@yahoo.com>
Subject: Re: unlinked orphans.
To: Hugo Mills <hugo@carfax.org.uk>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
In-Reply-To: <20131223093953.GH17179@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Monday, December 23, 2013 4:39 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

On Sun, Dec 22, 2013 at 10:27:17PM -0800, Nacho Man wrote:
> Hello,
> I ran dmesg and saw a bunch of these:
> [564421.874063] BTRFS debug (device sda2): unlinked 32 orphans
> [568021.386733] BTRFS debug (device sda2): unlinked 32 orphans
> [569943.269610] BTRFS debug (device sda2): unlinked 32 orphans
> [570929.840278] BTRFS debug (device sda2): unlinked 32 orphans
> [570942.035251] BTRFS debug (device sda2): unlinked 33 orphans
> [571623.719086] BTRFS debug (device sda2): unlinked 32 orphans
> [572075.684003] BTRFS debug (device sda2): unlinked 32 orphans
> 
> I just counted and there's a 175 of them.  Do I have to worry?  I've been working on a toolchain and some other stuff for the PS3 so my hard drive was being accessed a bit.  Could it be related?  Thanks.

   No, this is harmless. Orphans are files that were deleted while
they were still held open by a process. POSIX semantics requires that
the file data is still readable by the process, but that the file's
hardlink(s) are no longer visible -- so there's no way of finding the
file again by "normal" methods. Once the process closes the file, it
is unlinked.


Thank you very much.  Is there a way to suppress these messages about orphaned files?  I'd still like to see messages if something goes wrong, just not so much the orphaned files...

