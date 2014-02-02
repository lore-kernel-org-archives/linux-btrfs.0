Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:48504 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaBBWII (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Feb 2014 17:08:08 -0500
Received: by mail-bk0-f41.google.com with SMTP id na10so2746928bkb.14
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Feb 2014 14:08:07 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140202215720.GT2212@dastard>
References: <1391220332-22118-1-git-send-email-fdmanana@gmail.com>
	<20140202215720.GT2212@dastard>
Date: Sun, 2 Feb 2014 22:08:06 +0000
Message-ID: <CAL3q7H7wgDvUWUJdZJSswm+hx==GvyeVMd=sh_yNkCVOTyyypw@mail.gmail.com>
Subject: Re: [PATCH] xfstests: more tests for test case btrfs/030
From: Filipe David Manana <fdmanana@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 2, 2014 at 9:57 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Feb 01, 2014 at 02:05:32AM +0000, Filipe David Borba Manana wrote:
>> This change adds some new tests for btrfs' incremental send feature.
>> These are all related with inverting the parent-child relationship
>> of directories, and cover the cases:
>>
>> * when the new parent didn't get renamed (just moved)
>> * when a child file of the former parent gets renamed too
>>
>> These new cases are fixed by the following btrfs linux kernel patches:
>>
>> * "Btrfs: more send support for parent/child dir relationship inversion"
>> * "Btrfs: fix send dealing with file renames and directory moves"
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>
> Rather than modifying 030 which will cause it to fail on kernels
> where it previously passed, can you factor out the common code and
> create a new test with the additional coverage?
>
> i.e. the rule of thumb is that once a test is "done" we don't go
> back and modify it in significant ways - we write a new unit test
> that covers the new/extended functionality. Redundancy in unit tests
> is not a bad thing...

Right. The only reason I did this, instead of a new test file, is that
because the former fix which btrfs/030 relates to is not yet in any
kernel release. Given this fact, what do you think?

thanks

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
