Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59771 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbcCYTqD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 15:46:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D4D9F20373
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 19:46:01 +0000 (UTC)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com [209.85.223.174])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id E2E38201ED
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 19:46:00 +0000 (UTC)
Received: by mail-io0-f174.google.com with SMTP id 124so121777612iov.3
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 12:46:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160325184958.pk23fotivrbhteeg@floor.thefacebook.com>
References: <1458581924-18589-1-git-send-email-fdmanana@kernel.org>
	<20160321175107.rseoedz5yw6ckb3q@floor.thefacebook.com>
	<CAL3q7H4xujc7X4pPySHd_YCM50xfMZuwBH24E-0t0rdi-h9enA@mail.gmail.com>
	<20160325184958.pk23fotivrbhteeg@floor.thefacebook.com>
Date: Fri, 25 Mar 2016 19:46:00 +0000
Message-ID: <CAL3q7H69tECvgsFwqLznEXXU+DxTJE=UZq9FF5KdN0-a1M_C4g@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix crash/invalid memory access on fsync when
 using overlayfs
From: Filipe Manana <fdmanana@kernel.org>
To: Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        miklos@szeredi.hu
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 25, 2016 at 6:49 PM, Chris Mason <clm@fb.com> wrote:
> On Mon, Mar 21, 2016 at 05:52:44PM +0000, Filipe Manana wrote:
>> On Mon, Mar 21, 2016 at 5:51 PM, Chris Mason <clm@fb.com> wrote:
>> > On Mon, Mar 21, 2016 at 05:38:44PM +0000, fdmanana@kernel.org wrote:
>> >> From: Filipe Manana <fdmanana@suse.com>
>> >>
>> >> If the lower or upper directory of an overlayfs mount belong to a btrfs
>> >> file system and we fsync the file through the overlayfs' merged directory
>> >> we ended up accessing an inode that didn't belong to btrfs as if it were
>> >> a btrfs inode at btrfs_sync_file() resulting in a crash like the following:
>> >
>> > Thanks Filipe, I'll put this in a second pull this week, even if its the
>> > only patch in it ;)
>>
>> Well we need to wait for Miklos patch to be merged first.
>
> I'll cut this one on top of rc1 in a dedicated branch instead.  That way
> people can still use the rest of our btrfs pull against v4.5

At the moment, the patch it depends on it's not yet on Linus' tree.
But it's in Miklos vfs tree:
https://git.kernel.org/cgit/linux/kernel/git/mszeredi/vfs.git/log/?h=overlayfs-next

>
> -chris
