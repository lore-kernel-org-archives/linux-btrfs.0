Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54630 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab2GAPLI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2012 11:11:08 -0400
Received: by vcbf11 with SMTP id f11so3113764vcb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jul 2012 08:11:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CC03PBLeCXB@helmut.hullen.de>
References: <CALi3HZrwGO9=X3RG5FfN_04jW0F7T=405pVy4BXZg_6hE4W6XQ@mail.gmail.com>
 <CC03PBLeCXB@helmut.hullen.de>
From: Markus Rothe <markus@unixforces.net>
Date: Sun, 1 Jul 2012 17:10:37 +0200
Message-ID: <CALi3HZqKmDNtadVEzohLgkEzftYiUE7YHpH7zOs3E3P4-X+UNw@mail.gmail.com>
Subject: Re: Strange directories in /
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1 July 2012 17:06, Helmut Hullen <Hullen@t-online.de> wrote:
> Hallo, Markus,
>
> Du meintest am 01.07.12:
>
>> I am running btrfs for a few months now. I just realized that I have
>> a few strange directories in /
>
>> % ls / -1
>> ?
>> ???J??
>>  Q???
>> PL????
>> PR????
>> bin
>> boot
>> dev
>> etc
>> home
>> lib
>> lib32
>> lib64
>> lost+found
>> media
>> mnt
>> opt
>> proc
>> p?c'??
>> root
>> run
>> sbin
>> sys
>> tmp
>> usr
>> var
>> ??????
>
>> Is this a known problem? I have absolutely no idea where these
>> directories come from.
>
> That are no (real) directories, that is a damaged file system. Look for
> your backup.

Yes, I'll do that. I just wanted to let you guys know before
destroying the filesystem in case it would have been of any use to
debug this.

Regards, Markus
