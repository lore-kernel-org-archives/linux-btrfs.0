Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36752 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1758100AbdKOUHE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 15:07:04 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eF3xT-0007Am-4g
        for linux-btrfs@vger.kernel.org; Wed, 15 Nov 2017 21:06:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Read before you deploy btrfs + zstd
Date: Wed, 15 Nov 2017 20:06:42 +0000 (UTC)
Message-ID: <pan$ce8bd$92de8589$64a02ff8$89689fba@cox.net>
References: <20171113225046.GD28899@suse.cz>
        <20171114185331.GJ28899@twin.jikos.cz>
        <20171115143906.GM28899@twin.jikos.cz> <1948454.KW55iiPqHI@merkaba>
        <CAK5rZE6gC-7pmAJSrrHEfEXVFdZ51MOwAKugHpmihrm6LwEnFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Imran Geriskovan posted on Wed, 15 Nov 2017 20:16:56 +0200 as excerpted:

> On 11/15/17, Martin Steigerwald <martin@lichtvoll.de> wrote:
>> Somehow I am happy that I still have a plain Ext4 for /boot. :)
> 
> You may use uncompressed btrfs for /boot.
> Both Syslinux (my choice) and Grub supports it.

And I've been running grub2 with compress=lzo on my /boot for years, now, 
without issue.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

