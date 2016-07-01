Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:42024 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbcGAS70 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jul 2016 14:59:26 -0400
Subject: Re: FYI: *buntu - btrfs kernel error
References: <dc10db83-ce23-161e-0307-9011f4ed4ec7@chefmail.de>
 <CAJCQCtTeUUj1W+xG4JmQHBH6JGYEr-V3hJmSA3cJzK1XmP-3Pg@mail.gmail.com>
 <CAJCQCtTOV2LDOSO54KVW3bHqyQO6=V4yMYONmFtqGW9zR3t0zQ@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: g6094199@freenet.de
Message-ID: <76e1602b-f181-d2c3-cf15-c6328e4a44f2@chefmail.de>
Date: Fri, 1 Jul 2016 20:57:00 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTOV2LDOSO54KVW3bHqyQO6=V4yMYONmFtqGW9zR3t0zQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 01.07.2016 um 20:25 schrieb Chris Murphy:
> On Fri, Jul 1, 2016 at 12:24 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> This probably needs two more pieces of information:
>> 1. What's the workload going on at the time? There's stuff being
>> written and cleaned up.
>> 2. Issue sysrq+w
> echo w > /proc/sysrq-trigger
>
>
hi chris,

yes there must be some kind of i(o going on caused by samba. the system
is used as storage and it happen at around 8 a.m. where several users
logged in and loaded their profiles. this was seen 2 times on 2
different days.

the problem is that i´m usually not there that early, so there is no
chance in the near future to get the requested logs :-( but i see what i
can do.


regards

sash

