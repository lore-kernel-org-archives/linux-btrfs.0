Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:36804 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765343AbdEWVvt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 17:51:49 -0400
Received: by mail-yw0-f178.google.com with SMTP id b68so81117820ywe.3
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2017 14:51:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170523214943.GN29894@merlins.org>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <CAJCQCtRXCWuCbchRxOBZA7Dfzt4vhED77d1boErTdOGAzAi4vw@mail.gmail.com>
 <pan$d0afb$8cb8ad66$8322610b$459f2144@cox.net> <20170523170025.sweg3oyzs5f2jxca@merlins.org>
 <CAJCQCtT1QKpPWmoKhM-LTN3bweW-Yq=fGMjJU+b4wW+h98ydJg@mail.gmail.com> <20170523214943.GN29894@merlins.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 23 May 2017 15:51:43 -0600
Message-ID: <CAJCQCtTkszst4EqWRJrdpgyHm6=2j9WntecUiLzNY8=CZ_5Jww@mail.gmail.com>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
To: Marc MERLIN <marc@merlins.org>
Cc: Chris Murphy <lists@colorremedies.com>, Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 23, 2017 at 3:49 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Tue, May 23, 2017 at 03:38:01PM -0600, Chris Murphy wrote:
>> > I've tried an ext4 to btrfs conversion 3 times in the last 3 years, it
>> > never worked properly any of those times, sadly.
>>
>> Since the 4.6 total rewrite? There are also recent bug fixes related
>> to convert in the changelog, it should be working now and if there are
>> problems Qu is probably interested in getting them fixed.
>
> It was a 4.9 kernel from debian.

Convert is done by user space code, so btrfs-progs version is relevant.



-- 
Chris Murphy
