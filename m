From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 4/4] add snapshot/subvolume destroy ioctl
Date: Thu, 24 Sep 2009 08:43:22 -0400
Message-ID: <20090924124322.GB2797@think>
References: <4AB37AB9.3060401@oracle.com>
 <4486336c0909240127v2a3320c7s52db89b12d1d7272@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Yan, Zheng" <zheng.yan@oracle.com>, linux-btrfs@vger.kernel.org
To: john <yyalone@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4486336c0909240127v2a3320c7s52db89b12d1d7272@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 24, 2009 at 04:27:57PM +0800, john wrote:
>    After a git bisect, I think this patch may introduce a performance
>    regression(about 15% slower) in postmark benchmark. Sometimes(last a few
>    seconds) in the test, CPU usage is 100% wait but NO IO is performing, it's
>    not IO-wait. This didn't happen for earlier versions.
>    test*environment:
>    hard disk: INTEL X25-E SSD 64G
>    mkfs options: mkfs.btrfs -m single /dev/xxx
>    mount options: -o ssd,nodatasum,nodatacow

Thanks, I'll give this a shot here.

-chris
