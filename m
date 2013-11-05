Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:49363 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3KEMQo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 07:16:44 -0500
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: "Hans-Kristian Bakke" <hkbakke@gmail.com>
Subject: Re: csum failure messages
Date: Tue, 5 Nov 2013 23:16:34 +1100
Cc: linux-btrfs@vger.kernel.org
References: <201311051224.44255.russell@coker.com.au> <CAD_cGvE-FtFxZerOKN7T11-L=cEgh_8i-=YcgwG+g1aye6Zn6w@mail.gmail.com>
In-Reply-To: <CAD_cGvE-FtFxZerOKN7T11-L=cEgh_8i-=YcgwG+g1aye6Zn6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201311052316.34979.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 5 Nov 2013, "Hans-Kristian Bakke" <hkbakke@gmail.com> wrote:
> As you were in the process of a rebalance these errors may actually be
> caused by this serious bug "Btrfs: relocate csums properly with
> prealloc extents".
> 
> I hit that myself with several preallocated files made by rtorrent
> during a rebalance and I lost several huge files as a consequence. The
> only way I could rebalance without large scale corruptions was to
> manually patch the 3.11.6 kernel with the small patch that fixes the
> issue.
> For some reason this patch is not pushed upstream yet. I think that is
> strange as it leads to corruption and actual data loss and it is 100%
> reproducible with preallocated files. Only systemd logs is mentioned
> in the bug reports, but in my case it was actually hitting several
> terabytes of files created by rtorrent.

I run systemd to I guess it's the systemd logs.  That's fortunate as such logs 
aren't important to me.  Thanks for providing this information.

I've just run a scrub and I saw the following output.  There was nothing 
useful or apparently relevant in the kernel message log either.  So scrub is 
just telling me that there are 57 errors without giving me a clue as to which 
files might need to be restored from backup.

# btrfs scrub start -B /
scrub done for c55218a6-abb5-4e35-9a20-33fb1fa05879
        scrub started at Tue Nov  5 11:32:03 2013 and finished after 6762 
seconds
        total bytes scrubbed: 140.06GB with 57 errors
        error details: csum=57
        corrected errors: 0, uncorrectable errors: 57, unverified errors: 0

I can imagine a balance operation being unable to conveniently display all the 
data that one might desire.  But a scrub really should go through everything 
and should know where the inconsistencies are.  In this case the scrub gave me 
less information than the balance.

I presume that my filesystem is still corrupt.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
