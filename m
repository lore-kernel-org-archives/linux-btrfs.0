Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48238 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902Ab2INROA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 13:14:00 -0400
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Fri, 14 Sep 2012 13:13:56 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q8EHDG5Q067204
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 13:13:17 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q8EHDGUK020586
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 13:13:16 -0400
Message-ID: <505365A9.2080900@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2012 10:13:13 -0700
From: Wade Cline <clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, cmm@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] Btrfs-progs: Fix compiler warnings on PPC64.
References: <1347492116-16317-1-git-send-email-clinew@linux.vnet.ibm.com> <20120914135919.GN17430@twin.jikos.cz>
In-Reply-To: <20120914135919.GN17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/14/2012 06:59 AM, David Sterba wrote:
> On Wed, Sep 12, 2012 at 04:21:56PM -0700, clinew@linux.vnet.ibm.com wrote:
>> Defining __KERNEL__ before the file<asm/types.h>, or any file that
>> includes this file, will let PPC64 know to use unsigned long long
>> for u64 instead. This patch adds the defines and fixes the print
>> warnings on PPC64.
> Defining __KERNEL__ in random places does not seem clean, I understand
> it in kerncompat.h which should transparently fix any compatibility
> issues, and the files like cmd-receive.c should include this instead of
> the explicit defines.
>
>
> david
>

I agree that defining __KERNEL__ does not seem clean, but the problem is 
that
the various include files sort of "race" to include the type definition. 
For example,
in cmds-scrub.c:

#include <sys/ioctl.h>
#include <sys/wait.h>
#define __KERNEL__
#include <sys/stat.h>

will generate compiler warnings while:

#include <sys/ioctl.h>
#define __KERNEL__
#include <sys/wait.h>
#include <sys/stat.h>

will not. By the time kerncompat.h is included, u64 is almost always 
defined to
the non-compatible value. So either kerncompat.h needs to be defined as 
the -first-
included header file, or __KERNEL__ needs to be defined.

...it would also be possible to do something like:

#define __KERNEL__
#include <sys/wait.h>
#undef __KERNEL__

but that seems a bit too hacky.

I'm open to any other ideas, though.

Thank you,
Wade

