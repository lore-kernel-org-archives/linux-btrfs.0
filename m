From: David Nicol <davidnicol@gmail.com>
Subject: Re: Btrfs, NFS (v3) and ESTALE
Date: Thu, 23 Sep 2010 09:03:53 -0500
Message-ID: <AANLkTintf6aO9dwNYpV7xA0akRsUFQ=DdZH7U+=Ok2yO@mail.gmail.com>
References: <20100923110247.GD11225@rd.bbc.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100923110247.GD11225@rd.bbc.co.uk>
List-ID: <linux-btrfs.vger.kernel.org>

I wonder how difficult it would be to use GFS storage allocation, so
the right way to cluster btrfs would be at the block device level
instead of file system level.

Like the way btrfs can coexist in ext4 partition, but coexisting with GFS.


On Thu, Sep 23, 2010 at 6:02 AM, David Flynn <davidf@rd.bbc.co.uk> wrote:
> Dear all;
>
> On a cluster of ~35 machines used for batch processing, which all mount
> via NFS (v3) a BTRFS export, I am experiencing
