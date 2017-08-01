Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34-i6.italiaonline.it ([212.48.14.168]:35255 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751162AbdHAWYj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Aug 2017 18:24:39 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
 <1501621244.5007.2.camel@scientia.net>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <c6938d0a-6c63-6dd7-ced4-7ed3b7a3a1e4@libero.it>
Date: Wed, 2 Aug 2017 00:24:37 +0200
MIME-Version: 1.0
In-Reply-To: <1501621244.5007.2.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-01 23:00, Christoph Anton Mitterer wrote:
> Hi.
> 
> Stupid question:
> Would the write hole be closed already, if parity was checksummed?

No. 
The write hole problem is due to a combination of two things:
a) misalignment between parity and data (i.e. unclean shutdown)
b) loosing of a disk (i.e. disk rupture)

Note1: the write hole problem happens even if these two event are not consecutive.

After the disk rupture, when you need to read a data from the broken disk, you need the parity to compute the data. But if the parity is misaligned, wrong data is returned. 

The data checksum are sufficient to detect if wrong data is returned. The checksum parity is not needed. In any case both can't avoid the problem.


> Cheers,
> Chris.
> 

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
