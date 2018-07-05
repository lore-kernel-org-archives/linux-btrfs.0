Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35407 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753981AbeGEMkL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2018 08:40:11 -0400
Received: by mail-lj1-f195.google.com with SMTP id p10-v6so1141274ljg.2
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jul 2018 05:40:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180704152136.GV3126@twin.jikos.cz>
References: <1530576054-12837-1-git-send-email-zzhsuny@gmail.com> <20180704152136.GV3126@twin.jikos.cz>
From: Zhihui Zhang <zzhsuny@gmail.com>
Date: Thu, 5 Jul 2018 08:40:09 -0400
Message-ID: <CADFvMYL9Bb1DZp15n2H2WFKvQKDbsoU82DysP5sXOp9_o3-q-Q@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: make sure there is always room for generation number
To: dsterba@suse.cz, Zhihui Zhang <zzhsuny@gmail.com>, jbacik@fb.com,
        dsterba@suse.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

code inspection. If I understand it correctly, we are off by 4 bytes
because CRC is 32 bits and generation is 64 bits. But this bug might
never hit in practice.

thanks,

-Zhihui

On Wed, Jul 4, 2018 at 11:21 AM, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Jul 02, 2018 at 08:00:54PM -0400, Zhihui Zhang wrote:
>> io_ctl_set_generation() assumes that the generation number shares
>> the same page with inline CRCs. Let's make sure this is always true.
>>
>> Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
>
> Reviewed-by: David Sterba <dsterba@suse.com>
