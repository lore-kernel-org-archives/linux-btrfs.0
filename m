Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51621 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1756659AbdKOVcB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 16:32:01 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eF5Hf-0004mw-KF
        for linux-btrfs@vger.kernel.org; Wed, 15 Nov 2017 22:31:47 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: zstd compression
Date: Wed, 15 Nov 2017 21:31:39 +0000 (UTC)
Message-ID: <pan$c02ea$c0c093a$d0320b0d$d9d43196@cox.net>
References: <CAK5rZE51onZEE_f2xg4nxPriU9YQq5AARDLs-BTZL2RaGSCTXA@mail.gmail.com>
        <43412efa-ff56-9682-c8f7-a5966b87b10e@lukas-pirl.de>
        <CAK5rZE7rLToV7t+6pZhTbN2+JQj=W67Y5mESNhpaF0ehZzObOA@mail.gmail.com>
        <361d92ee-9aee-35e1-024d-45ec5b79902b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Wed, 15 Nov 2017 07:57:06 -0500 as
excerpted:

> The 'compress' and 'compress-force' mount options only impact newly
> written data.  The compression used is stored with the metadata for the
> extents themselves, so any existing data on the volume will be read just
> fine with whatever compression method it was written with, while new
> data will be written with the specified compression method.
> 
> If you want to convert existing files, you can use the '-c' option to
> the defrag command to do so.

... Being aware of course that using defrag to recompress files like that 
will break 100% of the existing reflinks, effectively (near) doubling 
data usage if the files are snapshotted, since the snapshot will now 
share 0% of its extents with the newly compressed files.

(The actual effect shouldn't be quite that bad, as some files are likely 
to be uncompressed due to not compressing well, and I'm not sure if 
defrag -c rewrites them or not.  Further, if there's multiple snapshots 
data usage should only double with respect to the latest one, the data 
delta between it and previous snapshots won't be doubled as well.)

While this makes sense if you think about it, it may not occur to some 
people until they've actually tried it, and see their data usage go way 
up instead of going down as they intuitively expected.  There have been 
posts to the list...

Of course if the data isn't snapshotted this doesn't apply and defrag -c 
to zstd should be fine. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

