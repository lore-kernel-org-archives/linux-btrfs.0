Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:35735 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbbHCPFq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 11:05:46 -0400
Received: by ykdu72 with SMTP id u72so112566875ykd.2
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 08:05:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP5+4qfi4UdfMmNdC2XizTG0au-btnKBqSmg1rUaW=EJApZkmA@mail.gmail.com>
References: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
	<pan$73c92$81fb65b9$3c60e540$cb422e6a@cox.net>
	<CAP5+4qfi4UdfMmNdC2XizTG0au-btnKBqSmg1rUaW=EJApZkmA@mail.gmail.com>
Date: Mon, 3 Aug 2015 11:05:46 -0400
Message-ID: <CAP5+4qdmjkniaoY6+FCL4OTAYQjpU=DOWBRv-3FkEvFN=TAeRw@mail.gmail.com>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
From: Sonic <sonicsmith@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 3, 2015 at 10:43 AM, Sonic <sonicsmith@gmail.com> wrote:
> Is "btrfs rescue super-recover" safe to run? IOW, will it ask before
> doing anything possibly destructive (assuming I don't give it a -y)?

Seemed a bit safe so I went for it and:

sartre ~ # btrfs rescue super-recover /dev/sdc
All supers are valid, no need to recover
sartre ~ # btrfs rescue super-recover /dev/sde
All supers are valid, no need to recover

So it may not be a superblock issue.

>From the dmesg earlier:
[ 3421.193734] BTRFS (device sde): bad tree block start
8330001001141004672 20971520
[ 3421.193738] BTRFS: failed to read chunk root on sde
[ 3421.203221] BTRFS: open_ctree failed

I may need a chunk-recover and also wonder if zero-log is advisable.
Any ideas in those directions?

Thanks,

Chris
