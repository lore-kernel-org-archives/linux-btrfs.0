Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:35451 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab3CKMxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 08:53:24 -0400
Received: by mail-la0-f44.google.com with SMTP id eb20so3865136lab.3
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 05:53:23 -0700 (PDT)
Received: by mail-la0-f44.google.com with SMTP id eb20so3861626lab.31
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 05:53:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <513DB161.4050205@petaramesh.org>
References: <513DB161.4050205@petaramesh.org>
From: Dan van der Ster <dan@vanderster.com>
Date: Mon, 11 Mar 2013 13:52:40 +0100
Message-ID: <CABZ+qqm=9JFSXNgO5CU7zZsOw1Sj7-XYy2xd2xZGMMNqoAuN3A@mail.gmail.com>
Subject: Re: BTRFS and "ionice"
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
Which IO scheduler do you use? I used to have terrible read
performance during a btrfs scrub until I switched the disk scheduler
from deadline to cfq.
Cheers, Dan


On Mon, Mar 11, 2013 at 11:26 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
> Hi,
>
> I use "ionice -c 3 <command>" to run some low-priority background tasks
> (i.e. tar, big file copies, or performing checksums sur very big files)
> using the disk "only when idle", which would be supposed to have very
> little impact on my system performance meanwhile.
>
> I can be pretty sure that those tasks are I/O-bound and use very little
> CPU (and they are niced as well, anyway).
>
> However, when such tasks are running my BTRFS system slows down to a
> crawl, becomes very very unresponsive, and it seems to me that disk I/O
> is completely saturated (LED is fixed lit...)
>
> So I wonder if BTRFS correctly support ionice, or if it's plain useless ?
>
> TIA
>
> Kind regards.
>
> --
> Swāmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
> Ne cherchez pas : Je ne suis pas sur Facebook.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
