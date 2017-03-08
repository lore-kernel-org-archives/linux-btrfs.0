Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37167 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753715AbdCHO3V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Mar 2017 09:29:21 -0500
Date: Wed, 8 Mar 2017 15:28:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Benedikt Morbach <benedikt.morbach@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: receive: handle root subvol path in
 clone
Message-ID: <20170308142838.GB4662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170222225637.21858-1-benedikt.morbach@googlemail.com>
 <20170222225637.21858-2-benedikt.morbach@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170222225637.21858-2-benedikt.morbach@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 22, 2017 at 11:56:37PM +0100, Benedikt Morbach wrote:
> testcase:
>     # ro subvol /src/parent
>     # rw subvol /src/foo
>     clone /src/parent/file /src/foo/file
>     subvol snapshot -r /src/foo /src/foo.snap
> 
>     # generates a "clone parent/file -> foo.snap/file" send command
>     send -p /src/parent /src/foo.snap
> 
>     # target fs:
>     #    dest/
>     #        |--- parent/...
>     # mounted with -o subvol=dest, such that "parent" is at <target>/parent
>     receive <target>
> 
> result:
>     ERROR: cannot open dest/parent/file: No such file or directory
> 
> expected:
>     "dest/" get's stripped from the clone source path to get the actual
>     path in the target fs, if reachable from the mount point/chroot.
> 
>     This is exactly what process_snapshot does, which gets called on
>     _every_ incremental receive and I'm quite certain is correct in
>     doing so
> 
> Signed-off-by: Benedikt Morbach <benedikt.morbach@googlemail.com>

1-2 applied, thanks.

> ---
> 
> Hi,
> 
> I first tried fixing this ages ago with [1], which was met with some scepticism.
> While that patch wasn't 100% correct I believe this is, and as mentioned it does
> exacly the same thing as process_snapshot because that has the exact same problem.
> 
> An fstest to reproduce this will be following shortly

I'll add an adapted version of the test script to progs as I'd like to
be able to test any changes to receive from there.
