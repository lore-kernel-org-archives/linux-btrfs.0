Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw12a-lucinda.wadns.net ([196.220.39.179]:44667 "EHLO
	fw12a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753566AbaEDHIR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 03:08:17 -0400
Message-ID: <5365E74B.6020805@swiftspirit.co.za>
Date: Sun, 04 May 2014 09:07:55 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Subject: Re: Using mount -o bind vs mount -o subvol=vol
References: <20140504004732.GE9061@merlins.org>
In-Reply-To: <20140504004732.GE9061@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/04 02:47 AM, Marc MERLIN wrote:
> Is there any functional difference between
>
> mount -o subvol=usr /dev/sda1 /usr
> and
> mount /dev/sda1 /mnt/btrfs_pool
> mount -o bind /mnt/btrfs_pool/usr /usr
>
> ?
>
> Thanks,
> Marc
There are two "issues" with this.
1) There will be a *very* small performance penalty (negligible, really)

2) Old snapshots and other supposedly-hidden subvolumes will be 
accessible under /mnt/btrfs_pool. This is a minor security concern 
(which of course may not concern you, depending on your use-case).

There are a few similar minor security concerns - the 
recently-highlighted issue with old snapshots is the potential that old 
vulnerable binaries within a snapshot are still accessible and/or 
executable.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

