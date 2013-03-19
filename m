Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:44764 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab3CSQcQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 12:32:16 -0400
Message-ID: <5148930E.90705@jan-o-sch.net>
Date: Tue, 19 Mar 2013 17:32:14 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix backref walking race with tree deletions
References: <CAOcd+r36TOugPs+5P3W6v6m5pzojGnqZ3YUNS-zzFK2pdm1A8A@mail.gmail.com> <1361460927-16355-1-git-send-email-list.btrfs@jan-o-sch.net> <CAOcd+r2HHDyHz0VqaJr5KWLMSMazFJ1kDKQULq7jkrEF6Ag15w@mail.gmail.com>
In-Reply-To: <CAOcd+r2HHDyHz0VqaJr5KWLMSMazFJ1kDKQULq7jkrEF6Ag15w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

On Tue, March 12, 2013 at 12:47 (+0100), Alex Lyakas wrote:
> Hi Jan,
> I have been testing your patch, and definitely the reproducer now passes.
> However, my system tests still hit the issue, but unfortunately I am
> unable to isolate it into a bash script. All bash scripts work
> alright:)

Okay, I think I've got something here: I enhanced xfstest 276 (you just got
cc-ed on that patch mail) and it reproducibly fails here.

Can you please check with new xfstest 276 and your debug printks if that
triggers the same error you're seeing with your local test setup? Unfortunately,
it sometimes needs a second or even third iteration to fail, I just use

# while [ $? -eq 0 ]; do ./check 276; done

for testing and it generally fails on the very first iteration here.

One way or another, I'm going to fix whatever the reason for the failing test
is. It would make me a tiny piece happier if you told me that you're hitting the
same bug - but any answer is appreciated :-)

Thanks!
-Jan
