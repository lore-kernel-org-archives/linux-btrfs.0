Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:59295 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab2JOUGY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 16:06:24 -0400
Message-ID: <507C6CC8.9060100@profihost.ag>
Date: Mon, 15 Oct 2012 22:06:32 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: miaox@cn.fujitsu.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: problems with btrfs send / restore
References: <50771F22.3070501@profihost.ag> <20121011194335.GE4405@twin.jikos.cz> <50772408.9040303@profihost.ag> <507BE264.1060500@cn.fujitsu.com> <507C6239.1030208@profihost.ag> <CAOcd+r2sZYxxNRQS2h-LY9Fpd791JRKiVq2gT-xBpkPY8=FsQQ@mail.gmail.com>
In-Reply-To: <CAOcd+r2sZYxxNRQS2h-LY9Fpd791JRKiVq2gT-xBpkPY8=FsQQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 15.10.2012 21:42, schrieb Alex Lyakas:
> Is /btrfs/target/\@snapshot/ a subvolume or a directory?
A simple directory.

> can you pls try the patch that I posted here:
> http://www.spinics.net/lists/linux-btrfs/msg19583.html
>
> I feel that you're hitting a similar issue here. Before you apply the
> patch, please verify that you have /etc/mtab on your system (I will
> make a more formal patch later).

With your patch it works FINE!! Great!

Another problem i'm seeing is:
# btrfs send -i /btrfs/src/\@snapshot/1 /btrfs/src/\@snapshot/2 | btrfs 
receive /btrfs/target/\@snapshot/
At subvol /btrfs/src/@snapshot/2
ERROR: Failed to lookup path for root 0 - No such file or directory
ERROR: unable to resolve path for root 350

Then i have to wait some seconds and the same command works fine. I see 
the same with btrfs subvolume list PATH

and it is unrelated to your patch.

Stefan
