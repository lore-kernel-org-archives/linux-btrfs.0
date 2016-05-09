Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:32910 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbcEIVva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 17:51:30 -0400
Received: by mail-oi0-f65.google.com with SMTP id f63so28414025oig.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 May 2016 14:51:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1757853.p9qfQBkHmV@anv.localdomain>
References: <2879842.8EgedBzSUf@anv.localdomain>
	<2288281.DWWvr4SJAK@anv.localdomain>
	<CAJCQCtTdL-AxGRpW3ZmGr4weYz3BUks0FR0NLmV-hsR88tNwvw@mail.gmail.com>
	<1757853.p9qfQBkHmV@anv.localdomain>
Date: Mon, 9 May 2016 15:51:29 -0600
Message-ID: <CAJCQCtQpjqrUf-4HqDZhCFyt5Y6EeNPS7czkV4KF3K-et9CyZw@mail.gmail.com>
Subject: Re: empty disk reports full
From: Chris Murphy <lists@colorremedies.com>
To: Alejandro Vargas <anv@zener.es>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 9, 2016 at 4:56 AM, Alejandro Vargas <anv@zener.es> wrote:
> El Martes, 26 de abril de 2016 00:08:49 Chris Murphy escribió:
>> On Mon, Apr 25, 2016 at 8:03 AM, Alejandro Vargas <anv@zener.es> wrote:
>
>> I suggest unmounting and running 'btrfs check' (without repair) and
>> see if that gives any new information.
>
> I tried btrfs check but... see the result:
>
> # btrfs check /dev/sdb1
> Checking filesystem on /dev/sdb1
> UUID: cbfe8735-9f53-46f5-be7e-40f6a61a5506
> checking extents
> Killed
>
>
> I tried it several times with the same result.

If this is btrfs-progs 4.5.2 it's worth filing a bug. You can
trivially use 'strace btrfs check /dev/sdb1' and attach the entire
output to the bug report as a file (pasting it in the bug will be
messy).

More advanced would be to use something like valgrind on it, but only
a dev would be able to tell you if it's helpful, I can't:

valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes
-v btrfs check /dev/sdb1

If it's not progs v.4.5.2 then I suggest upgrading and see if the
problem still happens.


-- 
Chris Murphy
