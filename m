Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f42.google.com ([209.85.128.42]:46476 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaATQvh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jan 2014 11:51:37 -0500
Received: by mail-qe0-f42.google.com with SMTP id i11so3173503qej.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 08:51:37 -0800 (PST)
Message-ID: <1390236695.1869.3.camel@sasami.ottawa.blindsidenetworks.com>
Subject: Re: Confirmation on how btrfs works with RAID and single.
From: Calvin Walton <mailing-lists@kepstin.ca>
To: "G. Michael Carter" <mikey@carterfamily.ca>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 20 Jan 2014 11:51:35 -0500
In-Reply-To: <CANjusZdjBTzreOTc3xvNeiu-LOBzbO2kLCOmjn=m19B-76m67w@mail.gmail.com>
References: <CANjusZdjBTzreOTc3xvNeiu-LOBzbO2kLCOmjn=m19B-76m67w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2014-01-20 at 10:43 -0500, G. Michael Carter wrote:
> I'm pretty sure I know the answers but just wanted confirmation.
> 
> 
> RAID1:  When it reads does it read from only one disk or does it try
> to read from multiple disks?

The current implementation of RAID1 on btrfs will, with a single process
reading, only read from one disk. If there are multiple processes
reading, it can have one process read from one disk and one process read
from another (the algorithm for this still needs tuning, though.)

> Single:  When it writes does it simple fill up one drive then move to
> the next or does it write in a round robin type fashion?

I'm not totally sure, this depends on the vagaries of the chunk
allocator. When writing only new files to an initially blank filesystem,
I would expect this to be a case; but on a used filesystem you will
probably get files fragmented over both disks.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


