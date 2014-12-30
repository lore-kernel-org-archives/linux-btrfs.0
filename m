Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:59318 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751425AbaL3XRT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 18:17:19 -0500
Message-ID: <40b56c60ddd4801295a92c4b11d5c08e.squirrel@webmail.wanet.net>
In-Reply-To: <54A31CAE.4020606@ubuntu.com>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
    <CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>
    <CAJCQCtR=Hinq_w6ELXFT-Ema-5THoz5EpuXkCOU_fE1gv--+qQ@mail.gmail.com>
    <7e0d08fddb1e0060f756690f6c82c350.squirrel@webmail.wanet.net>
    <54A31CAE.4020606@ubuntu.com>
Date: Tue, 30 Dec 2014 15:17:17 -0800
Subject: Re: I need to P. are we almost there yet?
From: ashford@whisperpc.com
To: "Phillip Susi" <psusi@ubuntu.com>,
        "Jose Manuel Perez Bethencourt" <jmperezbeth@gmail.com>
Cc: ashford@whisperpc.com, "Chris Murphy" <lists@colorremedies.com>,
        "sys.syphus" <syssyphus@gmail.com>,
        "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Phillip Susi wrote:
>
>> I'm wondering which of the above the BTRFS implementation most
>> closely resembles.
>
> Unfortunately, btrfs just uses the naive raid1+0, so no 2 or 3 disk
> raid10 arrays, and no higher performing offset layout.

> Jose Manuel Perez Bethencourt wrote:
>
> I think you are missing crucial info on the layout on disk that BTRFS
> implements. While a traditional RAID1 has a rigid layout that has
> fixed and easily predictable locations for all data (exactly on two
> specific disks), BTRFS allocs chunks as needed on ANY two disks.
> Please research into this to understand the problem fully, this is the
> key to your question.

There is a HUGE difference here.  In the first case, the data will have a
>50% chance of surviving a 2-drive failure.  In the second case, the data
will have an effectively 0% chance of surviving a 2-drive failure.  I
don't believe I need to mention which of the above is more reliable, or
which I would prefer.

I believe that someone who understands the code in depth (and that may
also be one of the people above) determine exactly how BTRFS implements
RAID-10.

Thank you.

Peter Ashford

