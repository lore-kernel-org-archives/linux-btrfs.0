Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39873 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbdAKTBn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 14:01:43 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cRO90-0001V0-Fx
        for linux-btrfs@vger.kernel.org; Wed, 11 Jan 2017 20:01:10 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mkfs.btrfs/balance small-btrfs chunk size RFC
Date: Wed, 11 Jan 2017 19:00:45 +0000 (UTC)
Message-ID: <pan$48f22$a985e7db$d84237a3$58044790@cox.net>
References: <pan$cb31b$a126bd1f$577e9db8$38b890f5@cox.net>
        <db8aff8c-44a5-f488-56de-4a9ec87e44e0@gmail.com>
        <20170110152905.GJ19585@carfax.org.uk>
        <c934f74c-6dac-b66f-13cf-eb9bf0a79aac@gmail.com>
        <20170110154753.GK19585@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Tue, 10 Jan 2017 15:47:53 +0000 as excerpted:

> On Tue, Jan 10, 2017 at 10:42:51AM -0500, Austin S. Hemmelgarn wrote:
>> Most of the issue in this case is with the size of the initial chunk.
>> That said, I've got quite a few reasonably sized filesystems (I think
>> the largest is 200GB) with moderate usage (max 90GB of data), and none
>> of them are using more than the first 16kB block in the System chunk.
>> While I'm not necessarily a typical user, I'd be willing to bet based
>> on this that in general, most people who aren't storing very large
>> amounts of data or taking huge numbers of snapshots aren't going to
>> need a system chunk much bigger than 1MB.
> 
>    Again, the system chunk has *nothing* to do with snapshots.

Given your explanation of the system chunk containing the chunk tree but 
not being (directly) related to snapshots, I took that as...

Many snapshots, some being old snapshots of now changed data, thus 
potentially multiplying the working copy data several times and of course 
requiring more chunks in ordered to contain all that archived data.

So while snapshots aren't directly related to the system chunk, the fact 
that they're snapshotting /something/ that's presumably changing or 
there'd be no need for snapshots, and the snapshot-archived versions of 
that /something/ presumably takes additional chunks, makes snapshots 
indirectly related to the required size of the system chunk(s), in 
ordered to contain the chunk tree supporting all the other chunks, 
necessary due not to live data, but due to the snapshots.

Is that a correct read, or is (somehow) that indirect dependency not 
there either, despite the system chunk(s) containing the chunk tree?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

