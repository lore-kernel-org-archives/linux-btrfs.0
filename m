Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20365 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117AbaHDN3t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Aug 2014 09:29:49 -0400
Message-ID: <53DF8AC8.3010708@fb.com>
Date: Mon, 4 Aug 2014 09:29:44 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
Subject: Re: Work Queue for btrfs compression writes
References: <CAPDOMVjJHbCwDVyKQ+Vuse7G76FLSLq69Ja4kmopDbjtEb_Zkw@mail.gmail.com>
In-Reply-To: <CAPDOMVjJHbCwDVyKQ+Vuse7G76FLSLq69Ja4kmopDbjtEb_Zkw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/29/2014 11:54 PM, Nick Krause wrote:
> Hey Guys ,
> I am new to   reading  and writing  kernel code.I got interested in
> writing code for btrfs as it seems to
> need more work then other file systems and this seems other then
> drivers, a good use of time on my part.
> I interested in helping improving the compression of btrfs by using  a
> set of threads using work queues like XFS
> or reads and keeping the page cache after reading compressed blocks as
> these seem to be a great way to improve
> on  compression performance mostly with large partitions of compressed
> data. I am not asking you to write the code
> for me but as I am new a little guidance and help would be greatly
> appreciated as this seems like too much work for just a newbie.

[ Back from vacation ]

Reading through the thread, I don't see anyone mentioning that btrfs
already funnels most compression through helper threads in the kernel
workqueues.

There is also an ordering component that submits the compressed bios to
disk (for writes) in the same order they were created.  This lets us
scatter compression across N cpus, but not introduce seeks if they make
progress at different rates.

-chris

