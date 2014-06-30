Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:41755 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbaF3Cdc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 22:33:32 -0400
Received: by mail-vc0-f176.google.com with SMTP id ik5so6901302vcb.35
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jun 2014 19:33:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3081460.dX0cLeJPhK@quad>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
	<4623589E-3298-4980-A257-665CFA9FB61B@colorremedies.com>
	<pan$26aa0$13a0ca68$c41d00a9$e8c14640@cox.net>
	<3081460.dX0cLeJPhK@quad>
Date: Sun, 29 Jun 2014 22:33:31 -0400
Message-ID: <CAGfcS_nO-Cu986JRvUR_Ny9oq=VmMNLfeUOs0AtfCSMw=Q9WQw@mail.gmail.com>
Subject: Re: Blocked tasks on 3.15.1
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Chris Samuel <chris@csamuel.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 27, 2014 at 8:22 PM, Chris Samuel <chris@csamuel.org> wrote:
> On Fri, 27 Jun 2014 05:20:41 PM Duncan wrote:
>
>> If I'm not mistaken the fix for the 3.16 series bug was:
>>
>> ea4ebde02e08558b020c4b61bb9a4c0fcf63028e
>>
>> Btrfs: fix deadlocks with trylock on tree nodes.
>
> That patch applies cleanly to 3.15.2 so if it is indeed the fix it should
> probably go to -stable for the next 3.15 release..

I can confirm that 3.15.2 definitely has the deadlock problem.  I
tried upgrading just to convince myself of this before patching it and
it only took a few hours before it stopped syncing with the usual
errors.

I applied the patch on Jun 28 around 20:00UTC.  I haven't had a
deadlock since, despite having the file system fairly active with a
few reboots, some deleted snapshots, being assimilated by the new
sysvinit replacement, etc.  That doesn't really prove anything though
- for all I know it will hang a week from now.

However, the patch seems stable so far on 3.15.2.

Rich
