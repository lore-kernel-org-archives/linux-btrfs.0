Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45088 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388241AbeGXMHu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jul 2018 08:07:50 -0400
Date: Tue, 24 Jul 2018 13:01:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH v2 2/2] btrfs: fix missing superblock update in the
 device delete commit transaction
Message-ID: <20180724110143.GU26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180703090724.22023-1-anand.jain@oracle.com>
 <20180703090724.22023-2-anand.jain@oracle.com>
 <20180721060113.GC575@fnst.localdomain>
 <4eba0d60-ef13-314e-0725-634a6113331a@oracle.com>
 <20180724092803.GG575@fnst.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180724092803.GG575@fnst.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 24, 2018 at 05:28:03PM +0800, Lu Fengqi wrote:
> >I can't reproduce the issue. Do you reproduce consistently? and I
> 
> Sorry I've taken so long to reply.
> 
> There are four virtual machines with the different storage backend here.
> And I can reproduce this issue consistently on the virtual machines (with
> HDD or qcow2 file in HDD), however, I can't reproduce on the virtual machine
> (with SSD or qcow2 file in SSD). So this may depend on the disk IO speed.
> 
> >wonder if your workspace contains the latest changes from
> >kdave/misc-next? Because last weeks kdave/misc had some issues.
> >Can you please give a try?
> 
> I used the latest kdave/misc-next branch on July 21, 2018, when I send
> the previous mail. Just as David replied to Nikolay's thread, the current
> latest kdave/misc-next still has the same problem.

I hit that on a physical machine with a mix of HDD and SSD drives under
fstests. The VM tests did not hit the problem.
