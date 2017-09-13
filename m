Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from phi.wiserhosting.co.uk ([77.245.66.218]:47385 "EHLO
        phi.wiserhosting.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751363AbdIMLvm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 07:51:42 -0400
Received: from cpc129066-ando7-2-0-cust212.know.cable.virginm.net ([80.2.13.213]:57538 helo=[172.16.100.1])
        by phi.wiserhosting.co.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.89)
        (envelope-from <pete@petezilla.co.uk>)
        id 1ds6Ch-002bPM-N6
        for linux-btrfs@vger.kernel.org; Wed, 13 Sep 2017 12:51:40 +0100
Subject: Re: Storage and snapshots as historical yearly
To: linux-btrfs@vger.kernel.org
References: <9208764.SjP1vfhOIA@pcsenen>
 <07ff0aeb-d4a8-ffb9-3a13-695ab9b2e65f@gmail.com>
 <34d8d690-d999-0081-4a80-65a6de439639@petezilla.co.uk>
 <3e3eae9d-f7d0-fafb-6faf-6eecdf724c8b@gmail.com>
From: Pete <pete@petezilla.co.uk>
Message-ID: <d81cfebb-6b8d-94cf-2bfd-091b55fb86b8@petezilla.co.uk>
Date: Wed, 13 Sep 2017 12:51:38 +0100
MIME-Version: 1.0
In-Reply-To: <3e3eae9d-f7d0-fafb-6faf-6eecdf724c8b@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/12/2017 01:16 PM, Austin S. Hemmelgarn wrote:

>> Diverting away from the original topic, what issues with overlayfs and
>> btrfs?
> As mentioned, I thought whiteout support was missing, but if you're
> using it without issue, I might be wrong.

Whiteout works fine.  Upper and lower layers and working directory are
all on btrfs subvolumes.  Snapshotting seems fine.



>> I'm using btrfs to create 'base' operating system containers (btrfs) and
>> then using overlayfs for a few 'upper' containers for specific
>> applications, so the upper parts of the overlays contain only the config
>> and data files and I can apply OS updates only on the lower ones.
>>
>> I do note that changes in the 'base' os can take time to propagate to
>> the upper containers and I'm probably not being sensible in not stopping
>> the upper containers when updating the lower ones.  This is also does
>> not seem to be what overlaysfs is intended for.  However, for my light
>> usage it generally works OK and is useful to me.
> Actually, this is pretty well in-line with one of the intended use cases
> (it was mostly designed for efficient multiple instantiation of Docker
> or LXC containers).  The other big use case is 'live' systems that only
> retain state while powered on, like most install images.

OK, I only spotted the latter use case when reading up, apart from one
website which seemed to mention using it for containers.
