Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:58919 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3IMLxX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 07:53:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWgzQvKkASycHSzpTwi2c3qG+wn52YSr-=c8cDtro7NyQ@mail.gmail.com>
References: <20130912153629.16487.88969@localhost.localdomain>
	<CA+5PVA5GogJnewWvdmVo03oZRZDerE=H7BR49Xi1DZQyE_CG4Q@mail.gmail.com>
	<CAMuHMdWgzQvKkASycHSzpTwi2c3qG+wn52YSr-=c8cDtro7NyQ@mail.gmail.com>
Date: Fri, 13 Sep 2013 07:53:21 -0400
Message-ID: <CA+5PVA6Hm6XLdJa=x9TmZnjSH160337i-CM2HGHBpQMf06Bv9w@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Mason <chris.mason@fusionio.com>, Mark Fasheh <mfasheh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 13, 2013 at 2:44 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Thu, Sep 12, 2013 at 10:38 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>> On Thu, Sep 12, 2013 at 11:36 AM, Chris Mason <chris.mason@fusionio.com> wrote:
>>> Mark Fasheh (4):
>>>       btrfs: offline dedupe
>>
>> This commit adds calls to __put_user_unaligned, which causes build
>> failures on ARM if btrfs is configured:
>>
>> + make -s ARCH=arm V=1 -j4 modules
>> fs/btrfs/ioctl.c: In function 'btrfs_ioctl_file_extent_same':
>> fs/btrfs/ioctl.c:2802:3: error: implicit declaration of function
>> '__put_user_unaligned' [-Werror=implicit-function-declaration]
>>    if (__put_user_unaligned(info.status, &args->info[i].status) ||
>>    ^
>> cc1: some warnings being treated as errors
>> make[2]: *** [fs/btrfs/ioctl.o] Error 1
>> make[1]: *** [fs/btrfs] Error 2
>> make[1]: *** Waiting for unfinished jobs....
>> make: *** [fs] Error 2
>> make: *** Waiting for unfinished jobs....
>
> Cfr. my early warning 10 days ago:
>
> "Btrfs is the first user of __put_user_unaligned() outside the compat code,
> hence now all 32-bit architectures should make sure to implement this, too."
>
> http://marc.info/?l=linux-arch&m=137820065929216&w=2

Indeed.  I missed that as it was an m68k patch.

I'm not an ARM expert, so I don't know if ARM should use the
asm-generic implementations, or just use __get_user/__put_user in all
cases.  I've CC'd rmk.

josh
