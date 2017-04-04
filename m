Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:35750 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753062AbdDDQz1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Apr 2017 12:55:27 -0400
Received: by mail-yw0-f182.google.com with SMTP id d191so64602718ywe.2
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Apr 2017 09:55:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRHgQrpijWgNigYZJsM-UxSpVfs0DWk2rbwmdPCeB+Qug@mail.gmail.com>
References: <635a5ca8-9fa5-6cd4-21b5-97f9f3db93d3@render-wahnsinn.de>
 <c304c651-88fc-4699-3518-c4e83095d9c0@mendix.com> <98a478cf-20f9-981f-6da5-4186a10be303@render-wahnsinn.de>
 <7f94b6b9-f18d-14dd-4a20-1793ce08df8a@render-wahnsinn.de> <36448783-672c-5e88-cdda-9a8679c4b4ad@render-wahnsinn.de>
 <CAJCQCtRHgQrpijWgNigYZJsM-UxSpVfs0DWk2rbwmdPCeB+Qug@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 4 Apr 2017 10:55:22 -0600
Message-ID: <CAJCQCtQ6ern7jJ92Z3yhzEOYW_s9iNnh6LD+tJz9m-y-nKjL9Q@mail.gmail.com>
Subject: Re: Need some help: "BTRFS critical (device sda): corrupt leaf, slot
 offset bad: block"
To: Chris Murphy <lists@colorremedies.com>
Cc: Robert Krig <robert.krig@render-wahnsinn.de>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 4, 2017 at 10:52 AM, Chris Murphy <lists@colorremedies.com> wrote:


> Mounting -o ro,degraded is probably permitted by the file system, but
> chunks of the file system and certainly your data, will be missing. So
> it's just a matter of time before copying data off will fail.

** Context here is, more than 1 device missing.




-- 
Chris Murphy
