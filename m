Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933364AbeFUQg7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 12:36:59 -0400
Received: from mail-ua0-f173.google.com (mail-ua0-f173.google.com [209.85.217.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD425215F1
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jun 2018 16:36:58 +0000 (UTC)
Received: by mail-ua0-f173.google.com with SMTP id n4-v6so2451205uad.6
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jun 2018 09:36:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180619133804.GP24375@twin.jikos.cz>
References: <20180611182416.18051-1-fdmanana@kernel.org> <20180619133804.GP24375@twin.jikos.cz>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 21 Jun 2018 17:36:57 +0100
Message-ID: <CAL3q7H538TswnaJqN_NGhT-w1yJ+aGeDwn7mxtvVDy5Rn6qNcA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Btrfs: fix return value on rename exchange failure
To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 19, 2018 at 2:38 PM, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Jun 11, 2018 at 07:24:16PM +0100, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> If we failed during a rename exchange operation after starting/joining a
>> transaction, we would end up replacing the return value, stored in the
>> local 'ret' variable, with the return value from btrfs_end_transaction().
>> So this could end up returning 0 (success) to user space despite the
>> operation having failed and aborted the transaction, because if there are
>> multiple tasks having a reference on the transaction at the time
>> btrfs_end_transaction() is called by the rename exchange, that function
>> returns 0 (otherwise it returns -EIO and not the original error value).
>> So fix this by not overwriting the return value on error after getting
>> a transaction handle.
>>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>
> 1 and 2 queued for 4.18, thanks.

Please removed the 2nd patch, because I just ran into a deadlock
between syncing the log and transaction kthread commiting the
transaction while a rename was in progress.
I'll send a v2 once I understand better the problem and have a fix. Thanks.
