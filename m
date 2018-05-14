Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:44423 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752013AbeENW3X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 18:29:23 -0400
Received: by mail-ot0-f194.google.com with SMTP id g7-v6so16194652otj.11
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 15:29:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180514165205.GP6649@twin.jikos.cz>
References: <20180514070210.27047-1-wqu@suse.com> <20180514165205.GP6649@twin.jikos.cz>
From: james harvey <jamespharvey20@gmail.com>
Date: Mon, 14 May 2018 18:29:22 -0400
Message-ID: <CA+X5Wn4tv=h5xt2D5wMb7mFm3SuWG0efahuyFwdTGgTkeYhnmA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW set
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2018 at 12:52 PM, David Sterba <dsterba@suse.cz> wrote:
> On Mon, May 14, 2018 at 03:02:10PM +0800, Qu Wenruo wrote:
>> As btrfs(5) specified:
>>
>>       Note
>>       If nodatacow or nodatasum are enabled, compression is disabled.
>>
>> If NODATASUM or NODATACOW set, we should not compress the extent.
>>
>> And in fact, we have bug report about corrupted compressed extent
>> leading to memory corruption in mail list.
>
> Link please.

https://bugzilla.kernel.org/show_bug.cgi?id=199707
&
https://www.spinics.net/lists/linux-btrfs/msg77971.html

>> Although it's mostly buggy lzo implementation causing the problem, btrfs
>> still needs to be fixed to meet the specification.
>
> That's very vague, what's the LZO bug? If the input is garbage and lzo
> decompression cannot decompress it, it's not a lzo bug.

The bug is the kernel doesn't just give an I/O error.  It totally
crashes the system.  Even a regular user cat'ing an invalid
btrfs-lzo-compressed file will take the system down.  Qu's current
theory which I agree with is it causes some kind of random kernel
memory corruption.  The crashes sometimes include "BTRFS: decompress
failed" at the start, but give backtraces for other things than btrfs
lzo code.
