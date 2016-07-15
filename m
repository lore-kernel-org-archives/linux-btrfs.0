Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35706 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbcGOXvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 19:51:23 -0400
Received: by mail-wm0-f51.google.com with SMTP id f65so42370342wmi.0
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 16:51:22 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: How can I get blockdev offsets of btrfs chunks for a file?
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
In-Reply-To: <alpine.LRH.2.11.1607151621220.20548@mail.ewheeler.net>
Date: Sat, 16 Jul 2016 00:51:19 +0100
Cc: linux-btrfs@vger.kernel.org
Message-Id: <8F688501-8310-46B0-A1E4-3D67EA1030FD@gmail.com>
References: <alpine.LRH.2.11.1607151621220.20548@mail.ewheeler.net>
To: Eric Wheeler <btrfs@lists.ewheeler.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No answer here, but mate if you are involved in anything that will provide some more automated backup tool for btrfs you got a lot of silent people rooting for you.

> On 16 Jul 2016, at 00:21, Eric Wheeler <btrfs@lists.ewheeler.net> wrote:
> 
> Hello all,
> 
> We do btrfs subvolume snapshots over time for backups.  I would like to 
> traverse the files in the subvolumes and find the total unique chunk count 
> to calculate total space for a set of subvolumes.
> 
> This sounds kind of like the beginning of what a deduplicator would do, 
> but I just want to count the blocks, so no submission for deduplication.  
> I started looking at bedup and other deduplicator code, but the answer to 
> this question wasn't obvious (to me, anyway).
> 
> Questions:
> 
> Is there an ioctl (or some other way) to get the block device offset for a 
> file (or file offset) so I can count the unique occurances?
> 
> What API documentation should I review?
> 
> Can you point me at the ioctl(s) that would handle this?
> 
> 
> Thank you for your help!
> 
> 
> --
> Eric Wheeler
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

