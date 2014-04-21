Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:43553 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaDUEMA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 00:12:00 -0400
Received: by mail-oa0-f51.google.com with SMTP id i4so3822809oah.10
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Apr 2014 21:12:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5352D26A.70601@gmx.net>
References: <53113626.3060706@gmx.net>
	<5322E39C.3030802@gmx.net>
	<5352D26A.70601@gmx.net>
Date: Sun, 20 Apr 2014 23:12:00 -0500
Message-ID: <CAKcLGm9Ng4J2rGsC_JUpG+A6Q5bR81kSD8zBAONjkrqsLuUyWQ@mail.gmail.com>
Subject: Re: How to view transaction log chronologically, human-readable?
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Marcel Partap <mpartap@gmx.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 19, 2014 at 2:45 PM, Marcel Partap <mpartap@gmx.net> wrote:
> This is the BTRFS development list, right? Someone here should know how
> to achieve this I hope?
> #Regards
>
>> On 01/03/14 02:21, Marcel Partap wrote:
>>> Dear BTFRS devs,
>>> I have a 1TB btrfs volume mounted read-only since two years because I
>>> deleted a bunch of files and didn't want to give up on them.
>>> Now with latest btrfs-find-root and btrfs restore --dry-run -t in a
>>> loop, I generated the full list of files contained in the last several
>>> hundred root trees. However, diffing these, I find the current one being
>>> the same until 94 root trees back, and the ones before contain earlier
>>> changes. Maybe by my own fault that is..whatever.
>>>
>>> Is there a way to just view the transaction history in a human-readable way?
>>>
>>> #Regards
>>>

I am not a "dev", but since BTRFS utilizes a COW (Copy On Write)
architecture, it doesn't keep a journal or history of transactions
that can be unwound.

With respect to un-deleting files on BTRFS, the btrfs-find-root/'btrfs
restore' combination are the most effective user-space tools I know
of.

It sounds like you've effectively tried this manually, but here's a
link to an btrfs undelete script that also makes use of
btrfs-find-root and 'btrfs restore':

http://comments.gmane.org/gmane.comp.file-systems.btrfs/22560
