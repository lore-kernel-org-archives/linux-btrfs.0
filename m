Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35027 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbcFDRAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jun 2016 13:00:46 -0400
Received: by mail-oi0-f53.google.com with SMTP id w184so170875160oiw.2
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jun 2016 10:00:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57528238.6080809@gmail.com>
References: <1464819934.6742.71.camel@scientia.net>
	<d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
	<1464975482.6679.11.camel@scientia.net>
	<6f18c0d1-8ac5-c325-0ba8-ffb949c54554@gmail.com>
	<1465005092.6648.39.camel@scientia.net>
	<57528238.6080809@gmail.com>
Date: Sat, 4 Jun 2016 11:00:45 -0600
Message-ID: <CAJCQCtS+GK88LZHY-uoWarn0qCuDuva4rg_TB_jEwAZo3nCcDQ@mail.gmail.com>
Subject: Re: btrfs
From: Chris Murphy <lists@colorremedies.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 4, 2016 at 1:24 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 04.06.2016 04:51, Christoph Anton Mitterer пишет:
> ...
>>
>>> The only extant systems that support higher
>>> levels of replication and call it RAID-1 are entirely based on MD
>>> RAID
>>> and it's poor choice of naming.
>>
>> Not true either, show me any single hardware RAID controller that does
>> RAID1 in a dup2 fashion... I manage some >2PiB of storage at the
>> faculty, all controller we have, handle RAID1 in the sense of "all
>> disks mirrored".
>>
>
> Out of curiosity - which model of hardware controllers? Those I am aware
> of simply won't let you create RAID1 if more than 2 disks are selected.

SNIA's DDF 2.0 spec Rev 19
page 18/19 shows 'RAID-1 Simple Mirroring" vs "RAID-1 Multi-Mirroring"



-- 
Chris Murphy
