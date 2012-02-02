From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: [3.2.1] BUG at fs/btrfs/inode.c:1588
Date: Thu, 02 Feb 2012 04:54:45 +0100
Message-ID: <51epv8-2qu.ln1@hurikhan.ath.cx>
References: <vqfmv8-9ch.ln1@hurikhan.ath.cx> <fgdov8-ord.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow <hurikhan77+btrfs@gmail.com> schrieb:

> Interestingly, the filesystem was not unmountable - system hung. After
> reisub and checking again with "btrfs scrub" no errors where reported and
> it just rsync'ed fine this time. This does not make sense to me.

btrfsck still shows a lot of errors, while scrubbing says everything is 
okay... *sigh

Now, how should one fix it if there is still no repair utility? I'm pretty 
sure sooner or later I will run into a BUG_ON again...

Thanks,
Kai

