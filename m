Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i2.italiaonline.it ([212.48.25.202]:43126 "EHLO
	smtp-32.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752170AbbAHSqW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Jan 2015 13:46:22 -0500
Message-ID: <54AED101.6060701@inwind.it>
Date: Thu, 08 Jan 2015 19:48:33 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Josef Bacik <jbacik@fb.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: price to pay for nocow file bit?
References: <20150107174315.GA21865@gardel-login> <54AD929E.608@fb.com> <20150108133036.GA23096@gardel-login> <54AECB72.9@gmail.com>
In-Reply-To: <54AECB72.9@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-01-08 19:24, Konstantinos Skarlatos wrote:
>> Anyway, given the pros and cons I have now changed journald to set
>> the nocow bit on newly created journal files. When files are
>> rotated (and we hence know we will never ever write again to them)
>> the bit is tried to be unset again, and a defrag ioctl will be
>> invoked right after. btrfs currently silently ignores that we unset
>> the bit, and leaves it set, but I figure i should try to unset it
>> anyway, in case it learns that one day. After all, after rotating
>> the files there's no reason to treat the files special anymore...

> Can this behaviour be optional? I dont mind some fragmentation if i
> can keep having checksums and the ability for raid 1 to repair those
> files.

I agree with Konstantinos's request: please let this behavior optional.

BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
