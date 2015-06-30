Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37651 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbbF3PUy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 11:20:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0224620626
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2015 15:20:53 +0000 (UTC)
Received: from mail-ie0-f178.google.com (mail-ie0-f178.google.com [209.85.223.178])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 3048620621
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2015 15:20:49 +0000 (UTC)
Received: by ieqy10 with SMTP id y10so14757236ieq.0
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2015 08:20:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150630151450.GH726@suse.cz>
References: <1434541495-14934-1-git-send-email-fdmanana@kernel.org>
	<20150629154221.GD726@twin.jikos.cz>
	<CAL3q7H4zr=v_A7aDSPGvS-cpOWosmwuNx0F+5nVN2R=yisa_9w@mail.gmail.com>
	<20150630151450.GH726@suse.cz>
Date: Tue, 30 Jun 2015 16:20:48 +0100
Message-ID: <CAL3q7H4yP20YKmB5PdqPkHqmn5VXeqMsYA7-707GanBdBkrU8A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: add feature to get mininum size for resizing
 a fs/device
From: Filipe Manana <fdmanana@kernel.org>
To: "dsterba@suse.cz" <dsterba@suse.cz>, Filipe Manana <fdmanana@kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 30, 2015 at 4:14 PM, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Jun 29, 2015 at 05:15:12PM +0100, Filipe Manana wrote:
>> On Mon, Jun 29, 2015 at 4:42 PM, David Sterba <dsterba@suse.cz> wrote:
>> > On Wed, Jun 17, 2015 at 12:44:55PM +0100, fdmanana@kernel.org wrote:
>> > The test fails after I do this before unmount:
>> >
>> > $SUDO_HELPER $TOP/btrfs balance start -mconvert=single -sconvert=single -f $TEST_MNT
>> > shrink_test
>>
>> Where are you doing this exactly?
>>
>> Just tried the following:  https://friendpaste.com/2U7C4gBBLBjo4e2v1ZnJP2
>
> Like in the the first part of the diff.
>
>> > Output:
>> >
>> > ############### root_helper ../btrfs filesystem resize get_min_size ../tests/mnt
>> > 6480199680 bytes (6.04GiB)
>> > min size = 6480199680
>> > ############### root_helper ../btrfs filesystem resize 6480199680 ../tests/mnt
>> > ERROR: unable to resize '../tests/mnt' - No space left on device
>> > Resize '../tests/mnt' of '6480199680'
>> >
>> > Last successful resize before this was:
>> > Resize '../tests/mnt' of '7553941504'
>>
>> And it didn't fail for me on a 4.1 kernel at least. It produced those
>> 2 sizes as well, but it didn't fail for any of them.
>
> The test was run on 4.0.5, I'm building a clean 4.1 + integration to
> verify it there.

Nevermind, I managed to reproduce it but by placing the
balance/convert before the loop that tests the shrinking.
btrfs_can_relocate() returns 0, meaning relocation should succeed if
no other allocations happen in parallel, which is the case here, but
btrfs_relocate_block_group() fails with ENOSPC - one of this functions
isn't working as it should, I'll check what's going on soon.

thanks
