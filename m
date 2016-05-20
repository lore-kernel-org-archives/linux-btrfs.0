Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35556 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbcETABP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 20:01:15 -0400
Received: by mail-wm0-f65.google.com with SMTP id s63so10528707wme.2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 17:01:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD=QJKh-wUK8RYFhDRjwowHyLhZ422Z33F=zcnRW9c4MuhvwwQ@mail.gmail.com>
References: <1463699581-12416-1-git-send-email-nsteeves@gmail.com>
	<CAD=QJKh-wUK8RYFhDRjwowHyLhZ422Z33F=zcnRW9c4MuhvwwQ@mail.gmail.com>
Date: Thu, 19 May 2016 20:01:13 -0400
Message-ID: <CAD=QJKjWwL+yJGKq=VWtnU5+HSQ4WgcRiim4v6JxTTPbE0eP1w@mail.gmail.com>
Subject: Re: [PATCH 0/1] String and comment review: Fix typos; fix a couple of
 mandatory grammatical issues for clarity.
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19 May 2016 at 19:47, Nicholas D Steeves <nsteeves@gmail.com> wrote:
> On 19 May 2016 at 19:13, Nicholas D Steeves <nsteeves@gmail.com> wrote:
>> Nicholas D Steeves (1):
>>   String and comment review: Fix typos; fix a couple of mandatory
>>     grammatical issues for clarity.
>>
>>  fs/btrfs/backref.c                |  2 +-
>>  fs/btrfs/btrfs_inode.h            |  2 +-
>>  fs/btrfs/check-integrity.c        |  2 +-
>>  fs/btrfs/ctree.c                  | 14 +++++++-------
>>  fs/btrfs/ctree.h                  | 10 +++++-----
>>  fs/btrfs/delayed-ref.h            |  2 +-
>>  fs/btrfs/dev-replace.c            |  2 +-
>>  fs/btrfs/disk-io.c                | 10 +++++-----
>>  fs/btrfs/extent-tree.c            | 34 +++++++++++++++++-----------------
>>  fs/btrfs/extent_io.c              |  4 ++--
>>  fs/btrfs/extent_map.c             |  2 +-
>>  fs/btrfs/file.c                   |  4 ++--
>>  fs/btrfs/free-space-cache.c       |  2 +-
>>  fs/btrfs/free-space-cache.h       |  2 +-
>>  fs/btrfs/inode.c                  | 22 +++++++++++-----------
>>  fs/btrfs/ioctl.c                  | 10 +++++-----
>>  fs/btrfs/ordered-data.h           |  2 +-
>>  fs/btrfs/qgroup.c                 | 16 ++++++++--------
>>  fs/btrfs/raid56.c                 |  6 +++---
>>  fs/btrfs/relocation.c             | 12 ++++++------
>>  fs/btrfs/root-tree.c              |  4 ++--
>>  fs/btrfs/scrub.c                  |  4 ++--
>>  fs/btrfs/send.c                   |  6 +++---
>>  fs/btrfs/struct-funcs.c           |  2 +-
>>  fs/btrfs/super.c                  | 10 +++++-----
>>  fs/btrfs/sysfs.c                  |  2 +-
>>  fs/btrfs/tests/extent-io-tests.c  |  2 +-
>>  fs/btrfs/tests/free-space-tests.c |  7 ++++---
>>  fs/btrfs/tests/inode-tests.c      |  2 +-
>>  fs/btrfs/tests/qgroup-tests.c     |  2 +-
>>  fs/btrfs/transaction.h            |  2 +-
>>  fs/btrfs/tree-log.c               |  8 ++++----
>>  fs/btrfs/ulist.c                  |  2 +-
>>  fs/btrfs/volumes.c                |  8 ++++----
>>  34 files changed, 111 insertions(+), 110 deletions(-)
>>
>> --
>> 2.1.4
>>
>
> Argh.  I'm sorry, I wasn't quite careful enough, and was working off
> of master rather than for-next.  Please disregard this patch.
>
> Sincerely,
> Nicholas

Oh my, rebasing off of for-next includes everyone else's patches too!
Maybe I did it correctly by using master after all?  There were only a
couple of minor rejects affecting the following: ctree.h,
extent-tree.c, and super.c.

Or is it preferred that I delete all patches excepting my cover letter
and 0119-For-linux-next-String-and-comment-review-Fix-typos-f.patch,
and then git send-email?

Best regards,
Nicholas
