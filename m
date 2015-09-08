Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34476 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbbIHTzd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 15:55:33 -0400
Received: by wicfx3 with SMTP id fx3so132726056wic.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2015 12:55:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA85sZu9xJOHMr0rs7hvzvBZwBWN7RvCb3bt4dYM7_6D2qyh7Q@mail.gmail.com>
References: <CAA85sZv5V_YGnHaYfDKJ8L9=Nmg0XNRoxK9NLZER_jKZ7TUdnA@mail.gmail.com>
 <20150908193405.GN23944@carfax.org.uk> <CAA85sZu9xJOHMr0rs7hvzvBZwBWN7RvCb3bt4dYM7_6D2qyh7Q@mail.gmail.com>
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Tue, 8 Sep 2015 21:55:12 +0200
Message-ID: <CAA85sZvJdOyUhZqFy4bWEPbKfM7k9gKU4vui9k+rRDmnWvPSxQ@mail.gmail.com>
Subject: Re: [btrfs tools] ability to fail a device...
To: Hugo Mills <hugo@carfax.org.uk>, Ian Kumlien <ian.kumlien@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8 September 2015 at 21:43, Ian Kumlien <ian.kumlien@gmail.com> wrote:
> On 8 September 2015 at 21:34, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Tue, Sep 08, 2015 at 09:18:05PM +0200, Ian Kumlien wrote:
[--8<--]

>>    Physically removing it is the way to go (or disabling it using echo
>> offline >/sys/block/sda/device/state). Once you've done that, you can
>> mount the degraded FS with -odegraded, then either add a new device
>> and balance to restore the RAID-1, or balance with
>> -{d,m}convert=single to drop the redundancy to single.
>
> This did not work...

And removing the pyscial device is not the answer either... until i
did a read only mount ;)

Didn't expect it to fail with unable to open ctree like that...

[--8<--]
