Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35844 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbeH2R3I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 13:29:08 -0400
Received: by mail-oi0-f41.google.com with SMTP id r69-v6so9123410oie.3
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 06:32:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAHzMYBT22xie_4Tjp+Zn6w7DG0sDAdkRRDrgesUvJ60j0TrmnA@mail.gmail.com>
 <7660605b-d456-308a-7040-720ff31f7181@georgianit.com>
In-Reply-To: <7660605b-d456-308a-7040-720ff31f7181@georgianit.com>
From: Jorge Bastos <jorge.mrbastos@gmail.com>
Date: Wed, 29 Aug 2018 14:31:57 +0100
Message-ID: <CAHzMYBSTpG1f=2KoLA1w34H_k7N2CHthXm0bxb0qVq8UrroQZw@mail.gmail.com>
Subject: Re: btrfs fi du unreliable?
To: remi@georgianit.com
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 29, 2018 at 1:42 PM Remi Gauvin <remi@georgianit.com> wrote:
>
>
> Exclusive means... exclusive... to that 1 snapshop/subvolume.  If the
> data also exists on the 23'rd snapshot, it's not exclusive.
>
> If you wanted to report how much data is exclusive to a group of
> snapshots, (say, July 22 *and* 23rd). you would have to make them
> members of a parent qgroup, then, you could see the exclusive value of
> the whole group.
>

Thanks, that makes sense, so it's only possible to see how much space
a snapshot is using with quotas enable, I remember reading that
somewhere before, though there was a new way after reading this latest
post .

Jorge
