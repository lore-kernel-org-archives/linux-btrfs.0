Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:24806 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2JGJ0f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2012 05:26:35 -0400
Message-ID: <50714AC8.4010100@petaramesh.org>
Date: Sun, 07 Oct 2012 11:26:32 +0200
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: BTRFS, getting darn slower everyday
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have 4 machines, all converted to BTRFS about 6 months ago, now all
running Ubuntu Quantal with kernel 3.5.0-17

The matter is that all these machines are now getting slower and slower
everyday, every disk access causing the disk to be 100% busy for long
periods, to the point that I'm now seriously considering migrating
everything back to ext4...

>From the start BTRFS was "not very fast", still satisfactory, but now it
becomes truly unusable.

On one machine, I know have a typical complete boot time to a usable GUI
that is over 4 minutes, with the HD still very busy for a couple more
minutes afterwards, where it used to be around 35-40 seconds in ext4 !

Is there anything I could do to speed things back (without losing all my
snapshots or doubling the size of data on disk)...?

I already had made the move back from BTRFS to ext4 about 18 months ago,
I found it had improved so was back to BTRFS, and I wouldn't have to
revert back again :-/

Any advice or help greatly appreciated.

TIA.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

