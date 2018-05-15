Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:43955 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752256AbeEOIOL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 04:14:11 -0400
Received: by mail-yw0-f178.google.com with SMTP id r202-v6so4400083ywg.10
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 01:14:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180514202213.GD13417@vader>
References: <CANBHLUjcAjvcA3BCn=i4VmDvKUcxSBk4_g3qp7Jw-k84sZXx5g@mail.gmail.com>
 <20180514202213.GD13417@vader>
From: Dimitri John Ledkov <xnox@ubuntu.com>
Date: Tue, 15 May 2018 09:14:09 +0100
Message-ID: <CANBHLUiJddD5F9FBxHBVAxnEM2fBerJ6M78bUAcxhjrOEgywmw@mail.gmail.com>
Subject: Re: Clarification needed about libbtrfs & libbtrfsutil
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14 May 2018 at 21:22, Omar Sandoval <osandov@osandov.com> wrote:
> On Mon, May 14, 2018 at 09:40:19AM +0100, Dimitri John Ledkov wrote:
>> Are both of these meant to be public libraries, installed on the user
>> systems, and available in .so variant as well for 3rd party
>> development and public dynamic linking?
>>
>> Or are these private internal libraries, which are installed as public
>> runtime only, simply to share code between the utils, but otherwise
>> provide no abi stability and will forever remain libfoo.so.0?
>
> They're both meant to be public. In fact, libbtrfsutil is already 1.0.0.
>

Ack. Will ship them as such.

>> Or should these even be a noinst_ libraries (~= Libtool Convenience
>> Libraries), and are simply intermediate by-products?
>>
>> I'm asking because despite compiling shared & static variants of these
>> libraries, and "shared linked" and "static linked" variants of the
>> utils, it appears that all utilities are statically linking against
>> libbtrfs/libbtrfsutils. Thus no binaries nor bindings, dynamically
>> link against neither libbtrfs nor libbtrfsutil.
>>
>> Tweaking the makefile to use libs_shared variable instead of libs or
>> libs_static, results in slightly smaller binaries, dynamically linked
>> against libbtrfs/libbtrfsutil.
>>
>> But it is hard to tell if this is a bug/mistake, or an intentional feature.
>
> I'm not sure why we statically link libbtrfs into the the tools, and I
> just copied that for libbtrfsutil.

OK. I guess I can prepare a patch to dynamically link
libbtrfs/libbtrfsutil and see how that will go through review.

-- 
Regards,

Dimitri.
