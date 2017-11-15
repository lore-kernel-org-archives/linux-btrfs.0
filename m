Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:51616 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756893AbdKOC4u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 21:56:50 -0500
Received: by mail-oi0-f42.google.com with SMTP id h81so9581081oib.8
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 18:56:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171114174856.12ae346f@natsu>
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
 <20171114174856.12ae346f@natsu>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 14 Nov 2017 19:56:49 -0700
Message-ID: <CAJCQCtQKfoeKnBJ_k1jBns1bxU0w+XvwR8x4kO9canXw033HVg@mail.gmail.com>
Subject: Re: A partially failing disk in raid0 needs replacement
To: Roman Mamedov <rm@romanrm.net>
Cc: Klaus Agnoletti <klaus@agnoletti.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 14, 2017 at 5:48 AM, Roman Mamedov <rm@romanrm.net> wrote:
> On Tue, 14 Nov 2017 10:36:22 +0200
> Klaus Agnoletti <klaus@agnoletti.dk> wrote:
>
>> Obviously, I want /dev/sdd emptied and deleted from the raid.
>
>   * Unmount the RAID0 FS
>
>   * copy the bad drive using `dd_rescue`[1] into a file on the 6TB drive
>     (noting how much of it is actually unreadable -- chances are it's mostly
>     intact)

This almost certainly will not work now, the delete command has copied
metadata to the 6TB drive, so it would have to be removed first to
remove that metadata,and Btrfs's record of that member device to avoid
it being considered missing, and also any chunks successfully copied
over.




-- 
Chris Murphy
