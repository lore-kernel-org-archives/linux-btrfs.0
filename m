Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:58044 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756502Ab2IKGTZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 02:19:25 -0400
Message-ID: <504ED7EA.903@gmx.net>
Date: Tue, 11 Sep 2012 08:19:22 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Marios Titas <redneb8888@gmail.com>
CC: Andreas Philipp <philipp.andreas@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: Cannot create subvolume with quota enabled
References: <504A4CBF.7000605@gmail.com>	<504A6F67.3060506@gmx.net> <CAAdM646auV2U43HnoYG=32RipWU8hzaKa5RBNia+krCYWY6muA@mail.gmail.com>
In-Reply-To: <CAAdM646auV2U43HnoYG=32RipWU8hzaKa5RBNia+krCYWY6muA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11.09.2012 07:24, Marios Titas wrote:
> On Fri, Sep 7, 2012 at 6:04 PM, Arne Jansen <sensille@gmx.net> wrote:
>> Hi Andreas,
>>
>>
>> Thanks for giving quota a try. I sent a fix separately with
>> the subject
>>
>> [PATCH] Btrfs: btrfs_qgroup_inherit wrongly returns an error
>>
>> Could you please see if it fixes the problem?
> 
> Even with this patch I still have a similar problem: When I try to
> create a snapshot of an old subvolume that was created before I
> enabled quotas, it fails. For new subvolumes it works just fine.
> Here's an example ouput:
> 
> virtual ~ # btrfs sub snap /mnt/butter/old /mnt/butter/old-snap
> Create a snapshot of '/mnt/butter/old' in '/mnt/butter/old-snap'
> ERROR: cannot snapshot '/mnt/butter/old' - Invalid argument

instead of applying my patch, could you please just revert

commit 5986802c2fcc754040bb7ed95f30bb16c4a843b7
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Mon Jul 30 02:16:10 2012 -0600

    Btrfs: fix some error codes in btrfs_qgroup_inherit()

It introduces both faulty return codes.

Thanks,
Arne
