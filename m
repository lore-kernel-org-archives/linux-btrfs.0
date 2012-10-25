Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47883 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992662Ab2JYUkX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 16:40:23 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so647362eaa.19
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 13:40:22 -0700 (PDT)
Message-ID: <5089A3DC.1080305@gmail.com>
Date: Thu, 25 Oct 2012 22:41:00 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
References: <50899151.1070503@inwind.it> <3BC0780A-C657-4195-BBAB-FFBDDBD989FB@colorremedies.com> <CAE5mzvi=czHnRcBUkyTn7NxzCRiZ-5GcZtZt8KGEX0tUiUz73g@mail.gmail.com>
In-Reply-To: <CAE5mzvi=czHnRcBUkyTn7NxzCRiZ-5GcZtZt8KGEX0tUiUz73g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-25 22:11, cwillu wrote:
>>> 3. How does Data: total=72GB before rebalance, but is 5GB after
>>> rebalance? This was a brand new file system, file system
>>> installed, with maybe 2-3 updates, and a dozen or two reboots.
>>> That's it. No VM's created on that volume (it's a VDI itself),
>>> and the VDI file itself never grew beyond 9GB.
> Combine the previous two answers: You had 72GB allocated to block 
> groups which are mostly empty.  After the balance, the contents of 
> those groups have been shuffled around such that most of them could
> be freed.

Did btrfs rebalance when it needs spaces ? The example reported by Chris
suggested that due to the filesystem history, btrfs allocate some chunk
that became empty.
If the user/admin don't make a (re)balance, is btrfs capable to move
some chunk from the DATA pool to the METADATA pool when the space became
low autonomously ?
I don't think, but I want a confirmation.

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
