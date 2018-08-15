Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbeHOLhb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 07:37:31 -0400
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A308021653
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 08:46:14 +0000 (UTC)
Received: by mail-ua1-f46.google.com with SMTP id k8-v6so483112uaq.12
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 01:46:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180814225337.GG24025@twin.jikos.cz>
References: <20180611182428.18102-1-fdmanana@kernel.org> <20180615155428.GG24375@twin.jikos.cz>
 <CAL3q7H641LmbUYgg_0n+1rS6KRScgZh9UjMSauCVCMNLJPnVdw@mail.gmail.com>
 <20180618110616.GI24375@twin.jikos.cz> <20180814190405.GA10954@vader> <20180814225337.GG24025@twin.jikos.cz>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 15 Aug 2018 09:46:13 +0100
Message-ID: <CAL3q7H5kUs_SzL0iGoBpihWe5-x4cwzCk0MwtNknJ9vr4dn_og@mail.gmail.com>
Subject: Re: [PATCH 2/2] Btrfs: sync log after logging new name
To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 14, 2018 at 11:53 PM, David Sterba <dsterba@suse.cz> wrote:
> On Tue, Aug 14, 2018 at 12:04:05PM -0700, Omar Sandoval wrote:
>> On Mon, Jun 18, 2018 at 01:06:16PM +0200, David Sterba wrote:
>> > On Fri, Jun 15, 2018 at 05:19:07PM +0100, Filipe Manana wrote:
>> > > On Fri, Jun 15, 2018 at 4:54 PM, David Sterba <dsterba@suse.cz> wrote:
>> > > > On Mon, Jun 11, 2018 at 07:24:28PM +0100, fdmanana@kernel.org wrote:
>> > > >> From: Filipe Manana <fdmanana@suse.com>
>> > > >> Fixes: 12fcfd22fe5b ("Btrfs: tree logging unlink/rename fixes")
>> > > >> Reported-by: Vijay Chidambaram <vvijay03@gmail.com>
>> > > >> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> > > >
>> > > > There are some warnings and possible lock up caused by this patch, the
>> > > > 1/2 alone is ok but 1/2 + 2/2 leads to the following warnings. I checked
>> > > > twice, the patch base was the pull request ie. without any other 4.18
>> > > > stuff.
>> > >
>> > > Are you sure it's this patch?
>> > > On top of for-4.18 it didn't cause any problems here, plus the trace
>> > > below has nothing to do with renames, hard links or fsync at all -
>> > > everything seems stuck on waiting for IO from dev replace.
>> >
>> > It was a false alert, sorry. Strange that the warnings appeared only in
>> > the VM running both patches and not otherwise.
>> >
>> > Though the test did not directly use rename, the possible error scenario
>> > I had in mind was some leftover from locking, error handling or state
>> > that blocked umount of 011.
>>
>> Dave, are you sending this in for 4.19? I don't see it in your first
>> pull request.

In another thread, related to the first patch in the series iirc, I
specifically asked to not merge it.
That's because I run twice (in the long period of nearly 2 months now)
into a hang which could be caused
by this patch. The traces were weird and only contained inexact lines
that showed only the transaction kthread
waiting forever on transaction commit.

I recently found that I have hardware problems that were causing
issues with qemu (stalls, ocassional crashes)
so I'm hoping that's the cause but I still need to test it with long
stress tests on good hardware.

I don't mind getting it to linux-next in the meanwhile, but for 4.19 I
would prefer to not include yet.

>
> Will send it in 2nd pull for 4.19. The patch is 2 months old and I don't
> remember where it was lost on the way. I had some suspicions but turned
> out to be false. Thanks for the reminder.
