Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([125.16.236.2]:60352 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbcDZPTH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 11:19:07 -0400
Received: from localhost
	by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 26 Apr 2016 20:49:04 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay09.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3QFJ24a8912940
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 20:49:02 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3QFItsM022915
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 20:49:01 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fdmanana@gmail.com
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, chandan@mykolab.com
Subject: Re: [PATCH V18 00/18] Allow I/O on blocks whose size is less than page size
Date: Tue, 26 Apr 2016 20:48:49 +0530
Message-ID: <1812092.vCqY3YhCNW@localhost.localdomain>
In-Reply-To: <CAL3q7H4+SOxG88RAGAdt+npPJ6nhehwmVySGdGD-dVv9u-h_zQ@mail.gmail.com>
References: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com> <CAL3q7H4+SOxG88RAGAdt+npPJ6nhehwmVySGdGD-dVv9u-h_zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 26 Apr 2016 14:54:46 Filipe Manana wrote:

> Hi Chandan,
> 
> What does it mean the tests don't pass? Is there absolutely no code
> changes for scrub and compression, or there is but still needs more
> working, or what?
>

Hi Filipe,

The patches that have been sent have no changes made with respect to either
scrub or compression.

> What happens if, when one is using block size < page size, and enables
> compression on a single file (i.e. fs not mounted with -o compress or
> force-compress), we start writing and read to the file? Does it result
> in the syscalls failing with -EIO or some other error, does it result
> in crashes (BUG_ON(), etc), dues it result in transparently falling
> back to non compression mode, or what happens exactly?

With the current patchset, reading/writing to a compressed file in
(block size == page size) scenario works fine. However reading/writing to a
compressed file in (block size < page size) results in crashes.

> 
> Same kind of question regarding scrub.
>

Scrub works fine for (block size == page size) scenario. However, Scrub ioctl
returns -EINVAL for the case where block size != page size. Without the block
size check, scrub might result in crashes.

-- 
chandan

