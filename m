Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:35039 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaF0Sdn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 14:33:43 -0400
Received: by mail-ve0-f176.google.com with SMTP id db12so5596114veb.7
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 11:33:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4623589E-3298-4980-A257-665CFA9FB61B@colorremedies.com>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
	<pan$81d96$8a4effae$94572f09$472a11ff@cox.net>
	<CAGfcS_khFRS3nMOtAD7srzHg6Q73LF1iogEzTy4YH1KW=qEu0g@mail.gmail.com>
	<4623589E-3298-4980-A257-665CFA9FB61B@colorremedies.com>
Date: Fri, 27 Jun 2014 14:33:42 -0400
Message-ID: <CAGfcS_=YkgSe28RVioY=e40Pqsq7J+1D1SgXAVaKL3aLArxVnw@mail.gmail.com>
Subject: Re: Blocked tasks on 3.15.1
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 27, 2014 at 11:52 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Jun 27, 2014, at 9:14 AM, Rich Freeman <r-btrfs@thefreemanclan.net> wrote:
>
>>
>> I got another block this morning and failed to capture a log before my
>> terminals gave out.  I switched back to 3.15.0 for the moment, and
>> we'll see if that fares any better.
>
> Yeah I'd start going backwards. The idea of going forwards is to
> hopefully get you unstuck or extract data where otherwise you can't,
> it's not really a recommendation for production usage. It's also often
> useful if you can reproduce the block with a current rc kernel and
> issue sysrq+w and post that. Then do your regression with an older
> kernel.

So, obviously I'm getting my money's worth from the btrfs team, but
neither is always a great option as neither involves me running a
stable kernel.  3.15.0 contains CVE-2014-4014, although I'm running a
version patched for that vulnerability.  If I go back any further I'd
probably have to backport it myself, and I only know about it because
my distro patched that CVE on 3.15.0 before moving to 3.15.1.

Running 3.16 doesn't bother me much from a btrfs standpoint, but it
means I'm getting unstable updates on all the other modules as well.
It is just more to deal with.

I might give 3.15.2 a shot and see what happens, and I can always fall
back to 3.15.0 again.

Rich
