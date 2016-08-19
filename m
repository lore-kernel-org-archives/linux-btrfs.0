Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35217 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754915AbcHSNRw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 09:17:52 -0400
Received: by mail-wm0-f51.google.com with SMTP id f65so34075657wmi.0
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Aug 2016 06:17:51 -0700 (PDT)
MIME-Version: 1.0
From: Philip Espunkt <p0h0i0l0i0p@gmail.com>
Date: Fri, 19 Aug 2016 15:17:50 +0200
Message-ID: <CAEAFGC-4BfrKJskRZDUrJ3f9VY8KK0FtNPuc1P4eSdc4aagDTA@mail.gmail.com>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: kreijack@inwind.it
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On 07/12/2016 05:50 PM, Goffredo Baroncelli wrote:
>>
>> most of the time, it seems that btrfs-raid5 is not capable to
>> rebuild parity and data. Worse the message returned by scrub is
>> incoherent by the status on the disk. The tests didn't fail every
>> time; this complicate the diagnosis. However my script fails most
>> of the time.

Have you opened a bug ticket at http://bugzilla.kernel.org/?
I think that would be useful for tracking.


Philip
