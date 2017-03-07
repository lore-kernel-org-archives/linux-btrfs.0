Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755845AbdCGSfH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Mar 2017 13:35:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id ACE8720426
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Mar 2017 18:35:05 +0000 (UTC)
Received: from mail-it0-f49.google.com (mail-it0-f49.google.com [209.85.214.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94C7D2041C
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Mar 2017 18:35:03 +0000 (UTC)
Received: by mail-it0-f49.google.com with SMTP id m27so19756677iti.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Mar 2017 10:35:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170307160517.GW4662@twin.jikos.cz>
References: <1488843167-8511-1-git-send-email-fdmanana@kernel.org> <20170307160517.GW4662@twin.jikos.cz>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 7 Mar 2017 18:35:02 +0000
Message-ID: <CAL3q7H6XkdgUqjSUiz4jd4szxXe6UCM3Pm1oqhDmH9d0F9Bdng@mail.gmail.com>
Subject: Re: [PATCH 1/2] Btrfs: remove unused delalloc_end parameter
To: "dsterba@suse.cz" <dsterba@suse.cz>, Filipe Manana <fdmanana@kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 7, 2017 at 4:05 PM, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Mar 06, 2017 at 11:32:47PM +0000, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> The delalloc_end parameter for extent_clear_unlock_delalloc() is never
>> used, and only making the code for all callers longer and more complex.
>> Just remove it.
>
> It's been added on purpose
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=dda3245eca18c73413a854a834c41fc770feb0dd
>
> "btrfs: expand cow_file_range() to support in-band dedup and
> subpage-blocksize"
>
> so we can merge both mentioned patchsets for testing.

I definitely missed that. To be honest I was finding it strange that
none of the usual cleanup fanatics noticed it before.

Anyway I'm sending a v2 of the 2nd patch so that it works correctly on
top of Qu's patchset that I reviewed recently. I've added Qu's patches
to my 4.11 integration branch just so that I could work on top of
them, feel free to pick stuff from there if convenient or ignore
otherwise.

Thanks.
