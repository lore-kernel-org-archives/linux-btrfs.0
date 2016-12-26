Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i4.italiaonline.it ([212.48.25.218]:36834 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751290AbcLZLZF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Dec 2016 06:25:05 -0500
From: Giuseppe Della Bianca <bepi@adria.it>
To: xin.zhou@gmx.com, linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
Date: Mon, 26 Dec 2016 12:24:43 +0100
Message-ID: <1601097.j5XE6pKq09@exnet.gdb.it>
In-Reply-To: <trinity-f5b0b96e-286c-4485-a02e-1f96bca7a906-1482255789582@3capp-mailcom-bs06>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I have executed the test that you have requested.

At this point I'm confused and demoralized

While 40 btrfs receive, btrfs check has reported many filesystem problems.
But at the end of all the btrfs receive, btrfs check did not find filesystem problem.
My tests have confirmed that the filesystem had no problems.

I think btrfs check detect false positives (this can change a repair in a destruction).


Regards.

Gdb

Xin Zhou Tue, 20 Dec 2016 09:47:01 -0800

>>Hi,

>>The system seems running some customized scripts continuously backup data from 
>>a NVME drive to HDDs.
>>If the 3 HDDs backup storage are same in btrfs config, and the there is a bug 
>>in btrfs code,
>>they all suppose to fail after the same operation sequence.


>>Otherwise, probably one of the HDDs might have issue, or there is a bug in 
>>layer below btrfs.

>>For the customize script, it might be helpful to check the file system 
>>consistency after each transfer.
>>That might be useful to figure out which step generates a corruption, and if 
>>there is error propagations.

>>Regards,
>>Xin
