Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47599 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2HBNCA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 09:02:00 -0400
Received: by vbbff1 with SMTP id ff1so8059854vbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Aug 2012 06:01:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <501A5A94.7070307@gmail.com>
References: <1343852708-24009-1-git-send-email-jbacik@fusionio.com>
	<501A5A94.7070307@gmail.com>
Date: Thu, 2 Aug 2012 07:01:59 -0600
Message-ID: <CAE5mzvjDYKhcm8NgKEtHhDXSAbRdRkAVGBVV90L=pxM9XeSJjA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: barrier before waitqueue_active
From: cwillu <cwillu@cwillu.com>
To: Liu Bo <liub.liubo@gmail.com>
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 2, 2012 at 4:46 AM, Liu Bo <liub.liubo@gmail.com> wrote:
> On 08/02/2012 04:25 AM, Josef Bacik wrote:
>> We need an smb_mb() before waitqueue_active to avoid missing wakeups.
>> Before Mitch was hitting a deadlock between the ordered flushers and the
>> transaction commit because the ordered flushers were waiting for more refs
>> and were never woken up, so those smp_mb()'s are the most important.
>> Everything else I added for correctness sake and to avoid getting bitten by
>> this again somewhere else.  Thanks,
>>
>
> Hi Josef,
>
> I'll appreciate a lot if you can add some comments for each memory
> barrier, because not everyone knows why it is used here and there. :)

Everyone who wants to know should read the memory-barriers.txt file
that's hiding in the oddly named "Documentation" folder of their
kernel tree.  :)
