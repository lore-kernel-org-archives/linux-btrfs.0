Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:45557 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab3AUKdk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 05:33:40 -0500
Received: by mail-wi0-f182.google.com with SMTP id hn14so4778151wib.9
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2013 02:33:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130114184529.GD1876@localhost.localdomain>
References: <CAOcd+r1ZioBQEykibvDdfx-1gmLfUPFfodNK5Dhnv8OB0EFApw@mail.gmail.com>
	<20130114184529.GD1876@localhost.localdomain>
Date: Mon, 21 Jan 2013 12:33:39 +0200
Message-ID: <CAOcd+r14SSEBLkPoTapjSwxQhcGCmym3eeTDbUD_nso8RrhMJw@mail.gmail.com>
Subject: Re: [PATCH 2/2] On a diff-send, avoid sending PREALLOC extent
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
I have resent the patches. There are still some "please, no space
before tabs" warnings, which I am not sure how to correct, because I
don't see space before tab in that place. If there is still a problem,
can you please advise what is wrong.

Thanks,
Alex.


On Mon, Jan 14, 2013 at 8:45 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Wed, Jan 09, 2013 at 10:41:10AM -0700, Alex Lyakas wrote:
>> Subject: [PATCH 2/2] On a diff-send, avoid sending PREALLOC extents, if the
>>  parent root has only PREALLOC extents on an appropriate
>>  file range.
>>
>> This does not fully avoids sending PREALLOC extents, because on full-send or
>> new inode we need a new send command to do that. But this patch improves
>> the situation by handling diff-sends.
>>
>> Signed-off-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
>> ---
>
> Malformed patch and it confused patchwork, please resend.  Thanks,
>
> Josef
