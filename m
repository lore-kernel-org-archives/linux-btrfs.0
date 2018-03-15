Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750950AbeCOHaB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 03:30:01 -0400
Subject: Re: High CPU usage of RT threads...
To: Shyam Prasad N <nspmangalore@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CANT5p=o57C_dxnrfF6C7h=cdVz2iVeWeOcri1xOnHhbxt+Gd=A@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <0e0d6b97-1dd6-23a7-c4ca-f79fefef23ff@suse.com>
Date: Thu, 15 Mar 2018 09:29:58 +0200
MIME-Version: 1.0
In-Reply-To: <CANT5p=o57C_dxnrfF6C7h=cdVz2iVeWeOcri1xOnHhbxt+Gd=A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.03.2018 09:23, Shyam Prasad N wrote:
> Hi,
> 
> Our servers run some daemons that are scheduled to run many real time
> threads. These threads serve the client nodes by performing I/O on top
> of some set of disks, configured as DRBD pairs with disks on other
> peer servers for high availability of data. Btrfs is the filesystem
> that is configured on top of DRBD.
> 
> While testing high availability with fairly high load, we have noticed
> the following behaviour a couple of times: When the server which was
> killed comes back up and gets ready and DRBD disks start syncing the
> data between the disks, a performance hit is generally expected at the
> peer node which has taken over the service now. However, the real time
> threads (mentioned above) on the active node are hogging the CPUs. As
> a part of debugging the issue, we tried to force a core dump on these
> threads by using a SIGABRT. However, these threads were not responding
> to any signals. Only after using real-time throttling (to reduce real
> time CPU usage to 50%), and waiting around for a few minutes, we were
> able to force a core dump. However, the corefile generated didn't have
> much useful info (I think it was a partial/corrupted core dump).
> 
> Based on the above behaviour, (signals not being picked up), it looks
> to me like all these threads were likely stuck inside some system
> call. And since majority of the system calls by these threads are VFS
> calls on btrfs, I feel that these threads may have been stuck in some
> I/O. Specifically, based on the CPU usage, in some spinlock (I'm open
> to suggestions of other possibilities). And this is the reason I'm
> posting on this mailing list.

When you have a bunch of those threads get a dump of the stacks of all
sleeping tasks by "echo w > /proc/sysrq-trigger" .

> 
> Is there a known bug which might have caused this? Kernel version
> we're using is 4.4.0.

This is rather old kernel, you should at least be using latest 4.4.y
stable kernel. BTRFS is a moving target and there are a lot of
improvements made every release. So I'd suggest to try 4.14 at least on
one offending machine.

> If we go for a kernel upgrade, what are the chances of not seeing this
> behaviour again?
> 
> Or is my analysis of the problem entirely wrong? My feeling is that
> this maybe some issue with using Btrfs when it doesn't get a response
> from DRBD quickly enough.

Feelings don't count for anything. Next time this happens extract
stacktrace from the offending threads i.e. smapling /proc/[pid of
hogging thread]/stack. Furthermore, if we assume that btrfs is indeed
not getting responses fast enough this means most clients should really
be stuck in io sleep and not doing any processing.


> Because we have been using ext4 on top of DRBD for a long time, and
> have never seen such issues during HA tests there.
> 
