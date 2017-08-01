Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:36942 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbdHAMcd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 08:32:33 -0400
Received: by mail-ua0-f181.google.com with SMTP id f9so6186163uaf.4
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Aug 2017 05:32:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170801064305.b6pgarooqu73gg3o@tiamat>
References: <20170731183047.x2p4vyqd2pvf7t4g@tiamat> <pan$1eb89$fa81c30b$fe750acd$9555f678@cox.net>
 <20170801064305.b6pgarooqu73gg3o@tiamat>
From: E V <eliventer@gmail.com>
Date: Tue, 1 Aug 2017 08:32:32 -0400
Message-ID: <CAJtFHURKa-9oUty5Q4=oMGVVFR62AEH-qxo38VG0O5WCVziXqg@mail.gmail.com>
Subject: Re: Slow mounting raid1
To: Leonidas Spyropoulos <artafinde@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 1, 2017 at 2:43 AM, Leonidas Spyropoulos
<artafinde@gmail.com> wrote:
> Hi Duncan,
>
> Thanks for your answer

In general I think btrfs takes time proportional to the size of your
metadata to mount. Bigger and/or fragmented metadata leads to longer
mount times. My big backup fs with >300GB of metadata takes over
20minutes to mount, and that's with the space tree which is
significantly faster then space cache v1.

>>
>> If a device takes too long and times out you'll see resets and the like
>> in dmesg, but that normally starts at ~30 seconds, not the 5 seconds you
>> mention.  Still, doesn't hurt to check.
