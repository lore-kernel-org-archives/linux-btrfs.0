Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35979 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbcDTUvZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Apr 2016 16:51:25 -0400
Received: by mail-oi0-f51.google.com with SMTP id x201so54747871oif.3
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Apr 2016 13:51:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAcrkYJObUr_yUw1emfy2v3eBYLOkY_5VsTdYZ3cCJ7KoxWvTA@mail.gmail.com>
References: <CAAcrkYLYu7Gk8_O+vMYp3B2z+yJiktp7AyEc1mONNHtA8kpxUw@mail.gmail.com>
	<CAJCQCtSagDUoA_tf4tTMMYK3K5bCtmHNSRjc=OLgoLYQpXw0cg@mail.gmail.com>
	<CAAcrkYK9C41wrXWkw4pgfrpSGgUbZ3amSD1y49_06dPH8oERgw@mail.gmail.com>
	<CAJCQCtRiTcy3OSA60G=N7LMA3xEpjeqmxv+gNyv7E+HyvG68Mg@mail.gmail.com>
	<CAAcrkYK=Hd5xvEXp-51JMD1_kMYfsHR9Pt3DRNoq+HTi=eTALg@mail.gmail.com>
	<CAJCQCtQ1sJKVb2dKfF7E2+OgFQCO2nKM0gZon62xo8058JrwvA@mail.gmail.com>
	<CAAcrkYJObUr_yUw1emfy2v3eBYLOkY_5VsTdYZ3cCJ7KoxWvTA@mail.gmail.com>
Date: Wed, 20 Apr 2016 14:51:24 -0600
Message-ID: <CAJCQCtRnVu4nJG6EQXNP3dhWxkFH27ELRvF8x5kB-2F8QtFkwA@mail.gmail.com>
Subject: Re: KERNEL PANIC + CORRUPTED BTRFS?
From: Chris Murphy <lists@colorremedies.com>
To: lenovomi <lenovomi@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 20, 2016 at 2:09 PM, lenovomi <lenovomi@gmail.com> wrote:
> Hi Chris,
>
> please find below attached the complete log while executing all the
> brtrfs commands, all of them failed.
>

> https://bpaste.net/show/482e91b25fc5

>warning, device 1 is missing
>warning, device 2 is missing

Restore probably can't work if too many devices are missing. I can't
tell you if this is a bug, or if they're really missing, or why you're
getting this message. But at least as far as the command is concerned,
it's not seeing two devices. So restore is a problem. I forget what
version of btrfs-progs you're using?





> https://bpaste.net/show/5093cc3daa5a
> https://bpaste.net/show/a24935eb5a1b

Try

btrfs-debug-tree -b 17802801315840

btrfs-restore -v -i -D -t 17802801315840

with the proper endings on those...

You might have to really constrain the restore parameters, maybe use
-f or -d or even -path-regex to find specific files you want to
scrape, and hope for the best. The less you're trying to grab, the
fewer errors, so it's a kind of triage at this point I think, short of
someone else with better ideas.

-- 
Chris Murphy
