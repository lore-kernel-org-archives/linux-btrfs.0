Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:52449 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752791AbdKNMiF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 07:38:05 -0500
Received: by mail-io0-f173.google.com with SMTP id u42so6187456ioi.9
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 04:38:05 -0800 (PST)
Subject: Re: Read before you deploy btrfs + zstd
To: Martin Steigerwald <martin@lichtvoll.de>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
References: <20171113225046.GD28899@suse.cz> <3013353.6rxLtS64S0@merkaba>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d0442de1-b53a-3b16-8932-54c783dd8afe@gmail.com>
Date: Tue, 14 Nov 2017 07:38:03 -0500
MIME-Version: 1.0
In-Reply-To: <3013353.6rxLtS64S0@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-14 02:34, Martin Steigerwald wrote:
> Hello David.
> 
> David Sterba - 13.11.17, 23:50:
>> while 4.14 is still fresh, let me address some concerns I've seen on linux
>> forums already.
>>
>> The newly added ZSTD support is a feature that has broader impact than
>> just the runtime compression. The btrfs-progs understand filesystem with
>> ZSTD since 4.13. The remaining key part is the bootloader.
>>
>> Up to now, there are no bootloaders supporting ZSTD. This could lead to an
>> unmountable filesystem if the critical files under /boot get accidentally
>> or intentionally compressed by ZSTD.
> 
> But otherwise ZSTD is safe to use? Are you aware of any other issues?
Aside from the obvious issue that recovery media like SystemRescueCD and 
the GParted LIveCD haven't caught up yet, and thus won't be able to do 
anything with the filesystem, my testing has not uncovered any issues, 
though it is by no means rigorous.
