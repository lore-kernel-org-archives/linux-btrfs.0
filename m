Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr1-f53.google.com ([209.85.221.53]:46734 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbeIKPLj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 11:11:39 -0400
Received: by mail-wr1-f53.google.com with SMTP id a108-v6so25269067wrc.13
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 03:13:01 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 11 Sep 2018 12:12:58 +0200
From: =?UTF-8?Q?J=C3=BCrgen_Herrmann?= <t-5@t-5.eu>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: compiling btrfs-progs 4.17.1 gives error "reiserfs/misc.h: No
 such file or directory"
In-Reply-To: <CAJCQCtSSAhjWXOS1X8A-q0qtOZ2MBHoUWyHvhWino0K5TqBanw@mail.gmail.com>
References: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>
 <CAJCQCtSSAhjWXOS1X8A-q0qtOZ2MBHoUWyHvhWino0K5TqBanw@mail.gmail.com>
Message-ID: <427d123ee042ce4f3c5d7a1b4bf434e7@t-5.eu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 7.9.2018 17:46, schrieb Chris Murphy:
> On Fri, Sep 7, 2018 at 3:56 AM, Jürgen Herrmann <t-5@t-5.eu> wrote:
>> Hello!
>> 
>> I'm having a problem with btrfs send which stops after several 
>> seconds.
>> The process hangs with 100% cpu time on one cpu. The system is still
>> responsive to input but no io is happening anymore so the system
>> basically becomes unuseable.
> 
> What kernel? Latest stable is 4.18.6. but I want to make sure that's
> what you're using, someone else has reported btrfs send problems in
> another thread with 4.18.5 that sound similar.

Hello again!

I was away from home for the last few days and I could not reproduce
the problem with any kernel and aný version of the btrfs tools while
on the road and the btrfs receive end was only connected via relatively
slow wan connection.

Now I'm back home and I can reproduce the hang of btrfs send with the
following versions:

kernels:
- ubuntu kernel 4.15.0-33-generic
- latest stable from kernel.org 4.18.6

btrfs-progs:
- ubuntu shipped 4.15.1
- latest stable compiled from source 4.17.1

btrfs send does indeed send some data over the ssh connection to the
receiving machine as the snapshot is newly created there and contains
some data:

t-5@t-5:/mnt/backup_laptop/2018-08-16_20-00-01/@$ du -h --max-depth=0
140M    .

The sending of data very quickly stops (<1s) and the process takes
up 100% cpu time on the sending laptop. about two or three seconds
later all io is blocked and the system is practically unuseable.

A "btrfs send /path/to/subvol > /dev/null" also shows the same
behaviour. As this is the first snapshot to be trasferred there
are no -c or -p arguments on the command line.

What can i do to help debug this?

Best regards,
Jürgen
-- 
Jürgen Herrmann
https://t-5.eu
ALbertstraße 2
94327 Bogen
