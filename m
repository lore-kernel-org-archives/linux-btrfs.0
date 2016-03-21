Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53480 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756851AbcCURwr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 13:52:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3DDC520253
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 17:52:46 +0000 (UTC)
Received: from mail-ig0-f173.google.com (mail-ig0-f173.google.com [209.85.213.173])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 20DB420279
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 17:52:45 +0000 (UTC)
Received: by mail-ig0-f173.google.com with SMTP id nk17so76807136igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 10:52:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160321175107.rseoedz5yw6ckb3q@floor.thefacebook.com>
References: <1458581924-18589-1-git-send-email-fdmanana@kernel.org>
	<20160321175107.rseoedz5yw6ckb3q@floor.thefacebook.com>
Date: Mon, 21 Mar 2016 17:52:44 +0000
Message-ID: <CAL3q7H4xujc7X4pPySHd_YCM50xfMZuwBH24E-0t0rdi-h9enA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix crash/invalid memory access on fsync when
 using overlayfs
From: Filipe Manana <fdmanana@kernel.org>
To: Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        miklos@szeredi.hu
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 5:51 PM, Chris Mason <clm@fb.com> wrote:
> On Mon, Mar 21, 2016 at 05:38:44PM +0000, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> If the lower or upper directory of an overlayfs mount belong to a btrfs
>> file system and we fsync the file through the overlayfs' merged directory
>> we ended up accessing an inode that didn't belong to btrfs as if it were
>> a btrfs inode at btrfs_sync_file() resulting in a crash like the following:
>
> Thanks Filipe, I'll put this in a second pull this week, even if its the
> only patch in it ;)

Well we need to wait for Miklos patch to be merged first.

>
> -chris
