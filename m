Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40944 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3HVJvv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 05:51:51 -0400
Message-ID: <5215DF29.3030100@oracle.com>
Date: Thu, 22 Aug 2013 17:51:37 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: introduce BTRFS_IOC_CHECK_DEV_EXCL_OPS ioctl to
 check dev excl op
References: <1377090643-23658-1-git-send-email-anand.jain@oracle.com> <5214C78C.3030001@giantdisaster.de>
In-Reply-To: <5214C78C.3030001@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for reviewing. Comments below.

> IMHO this is just a workaround for a design flaw.

  Its a simple fix on the lines of current design.

> Now it is like this (in the replace CLI without the "do not background"
> option):
> 1. in user mode, check that the ioctl will succeed, exit with failure if
> the checks fail
> 2. fork
> 3. exit(0) the parent
> 4. the backgrounded child executes the ioctl, the result is _ignored_
> 5. the user _has to_ check the status (progress, completion, errors) by
> calling 'btrfs replace status' which can optionally block until the
> replace procedure is finished, or optionally periodically print the
> status. The exit value of 'btrfs replace status' is set depending on
> whether there had been errors.

  Yes thats the current design.

> Step #1 is incomplete and can never be complete due to race conditions

> and because the checks in the kernel could be enhanced without updating
> the progs. Your patch is trying to improve step #1, to keep up with the
> checks in the kernel code.

  its an overhead, something like design drawback


> With the "do not background" option for btrfs replace it looks like this:
> 1. check that the ioctl will succeed (just because the code is shared
> with the case that the "do not background" option is not set)
> 2. execute the ioctl, the result is used to generate error messages and
> to build the exit code, the process does not terminate before the
> procedure is finished
> 3. the user _can_ check the status (progress, completion, errors) by
> calling 'btrfs replace status'

  Ok. Code can be bit optimized.

> I'd prefer it like this in both cases:
> 1. execute the ioctl (don't check anything in user mode before), set a
> flag whether the "do not background" option is set
> 2. in the kernel code inside the ioctl, perform all checks until there
> is no more regular reason to fail
> 3. in case of errors, return from the ioctl with an error code
> 4. if backgrounding was requested, return from the ioctl indicating that
> all checks had succeeded
> 5. if the ioctl failed, print an error message and set the exit value
> accordingly

> 6. if the ioctl succeeded and backgrounding was requested, background in
> user mode and call the ioctl again, this time with the "do not
> background" option

> This way we would still have the issue with the possible race, but at
> least the checks would be done only in one place. And the additional
> ioctl(CHECK_DEV_EXCL_OPS) would be avoided.

  yeah this can be done for the long term it helps to reduce the
  overhead of maintaining two similar codes. But CHECK_DEV_EXCL_OPS
  helps to solve an easily seen bug[1] with minimal impact.
  Further CHECK_DEV_EXCL_OPS will be useful to fix issues with
  other cross vol operations.

  [1]
  test case:
   terminal1: Run balance;
   terminal2: Run replace (without -B)
   problem: though replace fails, its unreported

Thanks, Anand
