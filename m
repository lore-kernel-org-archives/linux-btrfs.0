Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:33221 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbbHCQOy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 12:14:54 -0400
Received: by ykoo205 with SMTP id o205so24416717yko.0
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 09:14:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP5+4qfmXdMvBaVK1KqUfBRfM447ASJ4U0OqRxhsOw2r4WE1fQ@mail.gmail.com>
References: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
	<pan$73c92$81fb65b9$3c60e540$cb422e6a@cox.net>
	<CAP5+4qfi4UdfMmNdC2XizTG0au-btnKBqSmg1rUaW=EJApZkmA@mail.gmail.com>
	<CAP5+4qdmjkniaoY6+FCL4OTAYQjpU=DOWBRv-3FkEvFN=TAeRw@mail.gmail.com>
	<20150803152835.GF14352@carfax.org.uk>
	<CAP5+4qfmXdMvBaVK1KqUfBRfM447ASJ4U0OqRxhsOw2r4WE1fQ@mail.gmail.com>
Date: Mon, 3 Aug 2015 12:14:54 -0400
Message-ID: <CAP5+4qd2-kKEG5y2gEphQ=5A4+B+=2teMxiZJc-vDHZ1_-t8OQ@mail.gmail.com>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
From: Sonic <sonicsmith@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Sonic <sonicsmith@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also tried:
mount -o recovery,ro /mnt/butter/

And dmesg gives:
[88228.756622] BTRFS info (device sde): enabling auto recovery
[88228.756635] BTRFS info (device sde): disk space caching is enabled
[88228.757244] BTRFS (device sde): bad tree block start
8330001001141004672 20971520
[88228.757248] BTRFS: failed to read chunk root on sde
[88228.769877] BTRFS: open_ctree failed


On Mon, Aug 3, 2015 at 12:03 PM, Sonic <sonicsmith@gmail.com> wrote:
> On Mon, Aug 3, 2015 at 11:28 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>    Very unlikely and definitely not, respectively. There's nothing at
>> all here to indicate that you've got a broken log, so dropping it
>> would be at best pointless. The chunk tree is also most likely
>> undamaged on both copies.
>
> Will it hurt to try a chunk-recover? I'm guessing it wont do anything
> unless I answer Y to some prompt.
>
> Is there anything else you would suggest?
>
> Thanks,
>
> Chris
