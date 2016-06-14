Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35515 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbcFNTp1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 15:45:27 -0400
Received: by mail-oi0-f65.google.com with SMTP id u201so108128oie.2
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 12:45:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9d614f8f-f4c6-ac68-bfaa-abc29dd6b1d5@oracle.com>
References: <1464918615-6458-1-git-send-email-andrew@asquaredlabs.com> <9d614f8f-f4c6-ac68-bfaa-abc29dd6b1d5@oracle.com>
From: Andrew Armenia <andrew@asquaredlabs.com>
Date: Tue, 14 Jun 2016 15:44:47 -0400
Message-ID: <CA+jCKRWL-AmcP9ksZU502BYUGsHpeGbiCFK6L2c2T2HTD80ebA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: chunk_width_limit mount option
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 12, 2016 at 10:06 PM, Anand Jain <anand.jain@oracle.com> wrote:
>
>
> On 06/03/2016 09:50 AM, Andrew Armenia wrote:
>>
>> This patch adds mount option 'chunk_width_limit=X', which when set forces
>> the chunk allocator to use only up to X devices when allocating a chunk.
>> This may help reduce the seek penalties seen in filesystems with large
>> numbers of devices.
>
>
> Have you reviewed implementations like device allocation grouping?
> Some info is in the btrfs project ideas..
>
> https://btrfs.wiki.kernel.org/index.php/Project_ideas
>  Chunk allocation groups
>  Limits on number of stripes (stripe width)
>  Linear chunk allocation mode
>
> (Device allocation grouping is important for enterprise storage solutions).
>
> Thanks, Anand

I have looked at those ideas; allocation groups are what I'm ideally
after but I decided to start out small. I just spotted the dev_group
field in the device tree that appears to be currently unused, so
perhaps I will look at developing a group-aware allocator instead of
just limiting the chunk width.

-Andrew
