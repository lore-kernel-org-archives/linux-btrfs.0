Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59658 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab2IYLyq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 07:54:46 -0400
Received: by pbbrr4 with SMTP id rr4so8952446pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2012 04:54:45 -0700 (PDT)
Message-ID: <50619B82.6040906@gmail.com>
Date: Tue, 25 Sep 2012 19:54:42 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not async metadata csums if we have hardware
 crc32c
References: <1348510264-5781-1-git-send-email-jbacik@fusionio.com> <20120924210349.GP14582@twin.jikos.cz> <20120925105154.GS14582@twin.jikos.cz>
In-Reply-To: <20120925105154.GS14582@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/25/2012 06:51 PM, David Sterba wrote:
> On Mon, Sep 24, 2012 at 11:03:49PM +0200, David Sterba wrote:
>> Could you please put the check into a separate helper
> Please note that checksum will become a variable per-filesystem
> property, stored within the superblock, so the helper should be passed a
> fs_info pointer.
>
> thanks,
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

How about enhancing the "thread_pool=number" mount option instead?

thread_pool=n                     enable threadpool for compression and checksum, MAY improve bandwidth
thread_pool=0                     disable threadpool for compression and checksum, MIGHT reduce latency
thread_pool=-1 or not provided    automatically managed (current behavior and default choice)


This should allow user to tradeoff between latency and bandwidth, furthermore, you do not need to assume that btrfs may use crc32c algorithm only forever.


