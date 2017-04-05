Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.render-wahnsinn.de ([188.40.36.198]:40398 "EHLO
        mail.render-wahnsinn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751891AbdDEGHZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Apr 2017 02:07:25 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.render-wahnsinn.de (Postfix) with ESMTP id 0F7D8226E4E
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Apr 2017 08:06:23 +0200 (CEST)
Received: from mail.render-wahnsinn.de ([127.0.0.1])
        by localhost (mail.render-wahnsinn.de [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id Pgt9UhuJBMS5 for <linux-btrfs@vger.kernel.org>;
        Wed,  5 Apr 2017 08:06:10 +0200 (CEST)
Received: from [192.168.2.61] (x590d0cc4.dyn.telefonica.de [89.13.12.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.render-wahnsinn.de (Postfix) with ESMTPSA id 8EDC5226D6E
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Apr 2017 08:06:09 +0200 (CEST)
Subject: Re: Need some help: "BTRFS critical (device sda): corrupt leaf, slot
 offset bad: block"
References: <635a5ca8-9fa5-6cd4-21b5-97f9f3db93d3@render-wahnsinn.de>
 <c304c651-88fc-4699-3518-c4e83095d9c0@mendix.com>
 <98a478cf-20f9-981f-6da5-4186a10be303@render-wahnsinn.de>
 <7f94b6b9-f18d-14dd-4a20-1793ce08df8a@render-wahnsinn.de>
 <36448783-672c-5e88-cdda-9a8679c4b4ad@render-wahnsinn.de>
 <CAJCQCtRHgQrpijWgNigYZJsM-UxSpVfs0DWk2rbwmdPCeB+Qug@mail.gmail.com>
 <CAJCQCtQ6ern7jJ92Z3yhzEOYW_s9iNnh6LD+tJz9m-y-nKjL9Q@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Robert Krig <robert.krig@render-wahnsinn.de>
Message-ID: <79afeed3-d743-6951-aab1-6846b2accccb@render-wahnsinn.de>
Date: Wed, 5 Apr 2017 08:07:08 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ6ern7jJ92Z3yhzEOYW_s9iNnh6LD+tJz9m-y-nKjL9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04.04.2017 18:55, Chris Murphy wrote:
> On Tue, Apr 4, 2017 at 10:52 AM, Chris Murphy <lists@colorremedies.com> wrote:
>
>
>> Mounting -o ro,degraded is probably permitted by the file system, but
>> chunks of the file system and certainly your data, will be missing. So
>> it's just a matter of time before copying data off will fail.
> ** Context here is, more than 1 device missing.
>

Thanks you guys for all your help and input.

I've ordered two new drives to backup all my data. I have a cloud backup
in place, but 13TB takes a while to upload :-)
I think I'm gonna abandon btrfs as the main fs for my home server. I'm
just gonna set up a separate LVM volume for storing snapshots and
backups, since I use btrfs on all my single disk machines.
Thanks again everyone.
