Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35731 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbdEXEDa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 00:03:30 -0400
Received: by mail-lf0-f67.google.com with SMTP id 99so9758658lfu.2
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2017 21:03:30 -0700 (PDT)
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
To: Marc MERLIN <marc@merlins.org>, Chris Murphy <lists@colorremedies.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <CAJCQCtRXCWuCbchRxOBZA7Dfzt4vhED77d1boErTdOGAzAi4vw@mail.gmail.com>
 <pan$d0afb$8cb8ad66$8322610b$459f2144@cox.net>
 <20170523170025.sweg3oyzs5f2jxca@merlins.org>
 <CAJCQCtT1QKpPWmoKhM-LTN3bweW-Yq=fGMjJU+b4wW+h98ydJg@mail.gmail.com>
 <20170523214943.GN29894@merlins.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <ae37bde3-dd31-e19e-1252-e0976abd1b52@gmail.com>
Date: Wed, 24 May 2017 07:03:27 +0300
MIME-Version: 1.0
In-Reply-To: <20170523214943.GN29894@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

24.05.2017 00:49, Marc MERLIN пишет:
> On Tue, May 23, 2017 at 03:38:01PM -0600, Chris Murphy wrote:
>>> I've tried an ext4 to btrfs conversion 3 times in the last 3 years, it
>>> never worked properly any of those times, sadly.
>>
>> Since the 4.6 total rewrite? There are also recent bug fixes related
>> to convert in the changelog, it should be working now and if there are
>> problems Qu is probably interested in getting them fixed.
> 
> It was a 4.9 kernel from debian.

btrfs-convert is actually user space, so the question is what btrfsprogs
version you used.

