Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36307 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbbHTOHb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 10:07:31 -0400
Received: by iodv127 with SMTP id v127so46937662iod.3
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2015 07:07:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55D546C5.7000202@oracle.com>
References: <CAJtFHUQukRC9m+Bq85CN7v_tCk6ybGvParax5ixcMJwKHRUFCQ@mail.gmail.com>
	<55D546C5.7000202@oracle.com>
Date: Thu, 20 Aug 2015 10:07:30 -0400
Message-ID: <CAJtFHURyckNtbeq0ifwSL6-53+x2M+3_2FcxJ6iCAVsHx-H8hQ@mail.gmail.com>
Subject: Re: Kernel 4.1.4 btrfs forced read-only during rsync
From: E V <eliventer@gmail.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for looking, let me know if you need any other info. I haven't
touched the system yet, but it appears I'll need to unmount to btrfs
check or mount rw,recovery to try and get it working again. Who knows
what will happen then? I can leave it as if for a few days if it will
help any diagnosis. Thanks again.

On Wed, Aug 19, 2015 at 11:17 PM, Anand Jain <anand.jain@oracle.com> wrote:
>
> two to dig more..
>
>> Aug 16 04:41:31 [1082957.226817] BTRFS: error (device sdb) in
>> __btrfs_free_extent:6235: errno=-28 No space left
>> Aug 16 04:41:31 [1082957.226819] BTRFS info (device sdb): forced readonly
>
>
> ::
>
>> Aug 16 04:41:31 [1082957.289289] BTRFS: error (device sdb) in
>> cleanup_transaction:1692: errno=-5 IO failure
>
>
> 1.
>  We probably need to understand what kicked in readonly. is it
>  -28 (No space left) OR -5 (EIO).
>
> 2.
>  There are no media errors from the block layer, hope we are not
>  fabricating the EIO in the FS layer... thats wrong.
>
> digging more.
>
> Thanks,  Anand
