Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from forward1j.cmail.yandex.net ([5.255.227.19]:45073 "EHLO
        forward1j.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752840AbcHVXQf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Aug 2016 19:16:35 -0400
From: Tomokhov Alexander <alexoundos@ya.ru>
To: Jeff Mahoney <jeffm@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
In-Reply-To: <57BB5D1B.8040305@suse.com>
References: <126611471805976@web2j.yandex.ru> <57BB5D1B.8040305@suse.com>
Subject: Re: Will Btrfs have an official command to "uncow" existing files?
MIME-Version: 1.0
Message-Id: <31231471906411@web26j.yandex.ru>
Date: Tue, 23 Aug 2016 01:53:31 +0300
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh, didn't know that XFS is going to have many of Btrfs features and continues to evolve. Thank you for the answer.

22.08.2016, 23:14, "Jeff Mahoney" <jeffm@suse.com>:
> On 8/21/16 2:59 PM, Tomokhov Alexander wrote:
>>  Btrfs wiki FAQ gives a link to example Python script: https://github.com/stsquad/scripts/blob/master/uncow.py
>>
>>  But such a crucial and fundamental tool must exist in stock btrfs-progs. Filesystem with CoW technology at it's core must provide user sufficient control over CoW aspects. Running 3rd-party or manually written scripts for filesystem properties/metadata manipulation is not convenient, not safe and definitely not the way it must be done.
>>
>>  Also is it possible (at least in theory) to "uncow" files being currently opened in-place? Without the trickery with creation & renaming of files or directories. So that running "chattr +C" on a file would be sufficient. If possible, is it going to be implemented?
>
> XFS is looking to do this via fallocate using a flag that all file
> systems can choose to honor. Once that lands, it would make sense for
> btrfs to use it as well. The idea is that when you pass the flag in, we
> examine the range and CoW anything that has a refcount != 1.
>
> That code hasn't landed yet though. The last time I saw it posted was
> June. I don't speak with knowledge of the integration plan, but it
> might just be queued up for the next merge window now that the reverse
> mapping patches have landed in 4.8.
>
> -Jeff
>
> --
> Jeff Mahoney
> SUSE Labs
