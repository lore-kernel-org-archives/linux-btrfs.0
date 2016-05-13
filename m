Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:58600 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752684AbcEMQ2x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 12:28:53 -0400
Reply-To: kreijack@inwind.it
Subject: Re: BTRFS Data at Rest File Corruption
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
 <97b8a0bd-3707-c7d6-4138-c8fe81937b72@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Richard Lochner <lochner@clone1.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <573600C1.5020602@inwind.it>
Date: Fri, 13 May 2016 18:28:49 +0200
MIME-Version: 1.0
In-Reply-To: <97b8a0bd-3707-c7d6-4138-c8fe81937b72@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-11 21:26, Austin S. Hemmelgarn wrote:
> (although it can't tell the difference between a corrupted checksum and a corrupted block of data).

I don't think so. The data checksums are stored in metadata blocks, and as metadata block, these have their checksums. So btrfs know if the checksum is correct or none, despite the fact that the data is correct or none. Of course if the checksum is wrong, btrfs can't tell if the data is correct.

The only exception should be the inline data: in this case the data is stored in the metadata block, and this block is protected by only one checksum.

I know that I am pedantic :_)  but after reading your comment I looked at the btrfs data structure to refresh my memory, so I want to share these information.

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
