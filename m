From: Yuehai Xu <yuehaixu@gmail.com>
Subject: Re: BTRFS && SSD
Date: Wed, 29 Sep 2010 14:38:56 -0400
Message-ID: <AANLkTik61cvrvVedcYKtePx89aE1CoACS1NGNBsGXsK8@mail.gmail.com>
References: <AANLkTik9qiqtePxAhaJTyM7Q-g1nTgw9krTZFf_DaYxn@mail.gmail.com>
	<20100929173757.7cf18c0d@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, yhxu@wayne.edu
To: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100929173757.7cf18c0d@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Sep 29, 2010 at 11:37 AM, Dipl.-Ing. Michael Niederle
<mniederle@gmx.at> wrote:
> Hi Yuehai!
>
> I tested nilfs2 and btrfs for the use with flash based pen drives.
>
> nilfs2 performed incredibly well as long as there were enough free blocks. But
> the garbage collector of nilfs used too much IO-bandwidth to be useable (with
> slow-write flash devices).

I also tested the performance of write for INTEL X25-V SSD by
postmark, the results are totally different from the results of INTEL
X25-M(http://www.usenix.org/event/lsf08/tech/shin_SSD.pdf). In his
test, the performance of NILFS2 is the best over all, however, in my
test, ext3 is the best while NILFS2 is the worst, almost 10 times less
than ext3 for the throughput of write.

So, what's the role of file system to handle these tricky storage?
Different throughput might be gotten by different file system.

The question is why nilfs2 and btrfs perform so well compared with
ext3 without considering my results, here I just talk about SSD, since
the FTL internal should always do the same thing as the file system,
that redirects the write to a new place instead of writing to the
original place. The throughput for different file system should be
more or less the same.



>
> btrfs on the other side performed very well - a lot better than conventional
> file systems like ext2/3 or reiserfs. After switching the mount-options to
> "noatime" I was able to run a complete Linux system from a (quite slow) pen
> drive without (much) problems. Performance on a fast pen drive is great. I'm
> using btrfs as the root file system on a daily basis since last Christmas
> without running into any problems.
>

The performance of file system is determined by the internal structure
of SSD? or by the structure of file system? or by the coordination of
both file system and SSD?

Thanks very much for replying.

> Greetings, Michael
>

Thanks,
Yuehai
