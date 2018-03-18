Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:46005 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752141AbeCRA0X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Mar 2018 20:26:23 -0400
Received: by mail-io0-f174.google.com with SMTP id m22so16695975iob.12
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Mar 2018 17:26:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1a292eab288a4c90bf6dbf804dc92c86@MOXDE7.na.bayer.cnb>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net> <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CANQeFDDEtYYummhR7gZAxidQxTjbCbzEpLsR5L=HtykFkP2BBQ@mail.gmail.com> <1a292eab288a4c90bf6dbf804dc92c86@MOXDE7.na.bayer.cnb>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Sat, 17 Mar 2018 17:26:22 -0700
Message-ID: <CANQeFDCSv9pwrGOqimQnb0kW8ZBJY=smF2MbZ7zcmEev-M7YzQ@mail.gmail.com>
Subject: Re: Crashes running btrfs scrub
To: Mike Stevens <michael.stevens@bayer.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 16, 2018 at 2:46 PM, Mike Stevens <michael.stevens@bayer.com> wrote:
>> Could you please paste the whole dmesg, it looks like it hit
>> btrfs_abort_transaction(),
>> which should give us more information about where goes wrong.
>
> The whole thing is here https://pastebin.com/4ENq2saQ

Given this,

[  299.410998] BTRFS: error (device sdag) in
btrfs_create_pending_block_groups:10192: errno=-27 unknown

it refers to -EFBIG, so I think the warning comes from

btrfs_add_system_chunk()
{
...
        if (array_size + item_size + sizeof(disk_key)

                        > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {

                mutex_unlock(&fs_info->chunk_mutex);

                return -EFBIG;

        }

If that's the case, we need to check this earlier during mount.

thanks,
liubo

>
>
> ________________________________________________________________________
> The information contained in this e-mail is for the exclusive use of the
> intended recipient(s) and may be confidential, proprietary, and/or
> legally privileged.  Inadvertent disclosure of this message does not
> constitute a waiver of any privilege.  If you receive this message in
> error, please do not directly or indirectly use, print, copy, forward,
> or disclose any part of this message.  Please also delete this e-mail
> and all copies and notify the sender.  Thank you.
> ________________________________________________________________________
