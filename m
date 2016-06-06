Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35101 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbcFFNn7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jun 2016 09:43:59 -0400
Received: by mail-oi0-f67.google.com with SMTP id w184so6588836oiw.2
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jun 2016 06:43:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160606091729.GX29147@twin.jikos.cz>
References: <1464918615-6458-1-git-send-email-andrew@asquaredlabs.com> <20160606091729.GX29147@twin.jikos.cz>
From: Andrew Armenia <andrew@asquaredlabs.com>
Date: Mon, 6 Jun 2016 09:43:19 -0400
Message-ID: <CA+jCKRUtDqwVppYSv3jCODZW+U-AV5v1421x4TRHjp36aftw8A@mail.gmail.com>
Subject: Re: [PATCH] btrfs: chunk_width_limit mount option
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 6, 2016 at 5:17 AM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Jun 02, 2016 at 09:50:15PM -0400, Andrew Armenia wrote:
>> This patch adds mount option 'chunk_width_limit=X', which when set forces
>> the chunk allocator to use only up to X devices when allocating a chunk.
>> This may help reduce the seek penalties seen in filesystems with large
>> numbers of devices.
>
> There is a use for such limit but passing it as a mount is not the right
> way to do it. Changing the value requires remount, different raid levels
> might need different values, it's not persistent etc.

Thanks for the feedback. I agree that it's less than an ideal way to
do it. I guess I was a bit quick to release proof-of-concept code.
I'll try to do some more work on the configuration side of things and
resubmit.
