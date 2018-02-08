Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44124 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeBHJq0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Feb 2018 04:46:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w189k9Oi020814
        for <linux-btrfs@vger.kernel.org>; Thu, 8 Feb 2018 09:46:25 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2g0jvege34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Feb 2018 09:46:25 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w189kO5v022300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 8 Feb 2018 09:46:24 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w189kNGU010274
        for <linux-btrfs@vger.kernel.org>; Thu, 8 Feb 2018 09:46:24 GMT
Subject: Re: [PATCH RFC] Btrfs: expose bad chunks in sysfs
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180205231502.12900-1-bo.li.liu@oracle.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <82e9b0c1-cc4d-4d1f-0ccf-f4b437d61043@oracle.com>
Date: Thu, 8 Feb 2018 17:47:46 +0800
MIME-Version: 1.0
In-Reply-To: <20180205231502.12900-1-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/06/2018 07:15 AM, Liu Bo wrote:
> Btrfs tries its best to tolerate write errors, but kind of silently
> (except some messages in kernel log).
> 
> For raid1 and raid10, this is usually not a problem because there is a
> copy as backup, while for parity based raid setup, i.e. raid5 and
> raid6, the problem is that, if a write error occurs due to some bad
> sectors, one horizonal stripe becomes degraded and the number of write
> errors it can tolerate gets reduced by one, now if two disk fails,
> data may be lost forever.

This is equally true in raid1, raid10, and raid5.  Sorry I didn't get
the point why degraded stripe is critical only to the parity based
stripes (raid5/6)?
And does it really need a bad chunk list to fix in case of parity
based stripes or the balance without bad chunks list can fix as well?

> One way to mitigate the data loss pain is to expose 'bad chunks',
> i.e. degraded chunks, to users, so that they can use 'btrfs balance'
> to relocate the whole chunk and get the full raid6 protection again
> (if the relocation works).

Depending on the type of disk error its recovery action would vary. For
example, it can be a complete disk fail or interim RW failure due to
environmental/transport factors. The disk auto relocation will do the
job of relocating the real bad blocks in the most of the modern disks.
The challenging task will be to know where to draw the line between
complete disk failure (failed) vs interim disk failure (offline) so I
had plans of making it tunable base on number of disk errors.

If it's confirmed that a disk is failed, the auto-replace with the hot
spare disk will be its recovery action. Balance with a failed disk won't
help.

Patches to these are in the ML.

If the failure is momentary due to environmental factors, including the
transport layer, then as we expect the disk with the data will come back
we shouldn't kick in the hot spare, that is disk state offline, or maybe
its a state where read old data is fine, but cannot write new data.
I think you are addressing this interim state. It's better to define the
disk states first so that its recovery action can be defined. I can
revise the patches on that. So that replace VS re-balance using bad 
chunks can be decided.

> This introduces 'bad_chunks' in btrfs's per-fs sysfs directory.  Once
> a chunk of raid5 or raid6 becomes degraded, it will appear in
> 'bad_chunks'.

AFAIK a variable list of output is not allowed on sysfs.

IMHO list of bad chunks won't help the user (it ok if its needed by
kernel). It will help if you provide the list of affected-files
so that the user can use it script to make additional interim external
copy until the disk recovers from the interim error.

Thanks, Anand
