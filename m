Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:65507 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbbCaFfJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 01:35:09 -0400
Received: from mail-ie0-f169.google.com (mail-ie0-f169.google.com [209.85.223.169])
	(Authenticated sender: robbieko@synology.com)
	by mail.synology.com (Postfix) with ESMTPSA id 20C75688440
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 13:34:56 +0800 (CST)
Received: by iedm5 with SMTP id m5so7430712ied.3
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 22:35:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150331031917.GA31032@mew.dhcp4.washington.edu>
References: <CAJiZgcqMPRk-Zr1V0rOz00HX4q6Lzs=iaT8iwSvKw5n4+f=4WQ@mail.gmail.com>
	<20150331031917.GA31032@mew.dhcp4.washington.edu>
Date: Tue, 31 Mar 2015 13:35:02 +0800
Message-ID: <CAJiZgcqy1FzKCwsoO2+-=7c_3OTE-59=10-opkYqKhtTgxnvqQ@mail.gmail.com>
Subject: Re: Btrfs Send/Receive "utime" error And "WARN_ON Cannot allocate memory"
From: Robbie Ko <robbieko@synology.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-03-31 11:19 GMT+08:00 Omar Sandoval <osandov@osandov.com>:
> On Tue, Mar 31, 2015 at 11:06:10AM +0800, Robbie Ko wrote:
>> Hi,
>>
>> I have  testing btrfs send/receive recently.
>>
>> I got an error "send ioctl failed with -12: Cannot allocate memory" on
>> send side.
>> WARN_ON happened on "len > PATH_MAX" in fs_path_ensure_buf.
>>
>> I got an error "utime failed: No such file or directory" on receive side.
>> The followings are simple reproduced steps and related information.
>>
>> I have applied the following patch in the url :
>> https://patchwork.kernel.org/patch/6113581/.
>> However, it did not fix the problem.
>>
>> Is there any  idea about what this might be or how to fix it?
>
> [Bah, gave Gmail a chance to do plaintext and it blew it. Back to Mutt.]
>
> Have you applied https://patchwork.kernel.org/patch/5996271/ as well?

Yes, I have applied.

>
> --
> Omar
