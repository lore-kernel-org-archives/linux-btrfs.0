Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34796 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbcGXF5W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jul 2016 01:57:22 -0400
Received: by mail-oi0-f48.google.com with SMTP id l65so213902118oib.1
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 22:57:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6699a315-17f4-9298-fb6b-64358c497be0@exroot.org>
References: <72704872-fb0b-a951-2b7e-55236071094f@exroot.org>
 <CAJCQCtRHi=xJ-mP2yTg5c9sfGk+WKnjzRikT7Y-5he8s+3sSVw@mail.gmail.com> <6699a315-17f4-9298-fb6b-64358c497be0@exroot.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 23 Jul 2016 23:57:19 -0600
Message-ID: <CAJCQCtQMgEfVi2z-5LRbMDOYU=uxf2VqTRBOv8FTXqFpziRa4g@mail.gmail.com>
Subject: Re: Force recalculation of a data block checksum
To: Tomasz Melcer <liori@exroot.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 23, 2016 at 10:32 PM, Tomasz Melcer <liori@exroot.org> wrote:
> On 24.07.2016 04:16, Chris Murphy wrote:
>>
>> On Sat, Jul 23, 2016 at 8:03 PM, Tomasz Melcer <liori@exroot.org> wrote:
>>>
>>> How can I ask btrfs to recompute the checksum of a data block as it is
>>> stored on the drive?
>>
>>
>> Since btrfs-progs 3.17 'btrfs check --init-csum-tree' will create a
>> whole new csum tree.
>
>
> I can't make this command recalculate only checksum of that single file?

The likelihood of the data block being wrong is very high. If the csum
itself were wrong, the csum of the leaf it's stored in would catch it,
except in the narrow edge case where the csum was computed wrong in
memory, and then put into the leaf which is then checksummed
correctly, i.e. the leaf csum says the leaf is good but it contains a
bad csum for just one block. Possible but, pretty rare if there isn't
a problem causing in-memory corruption. You'd see a lot more errors. A
few bad sectors are exactly what this most likely is. The drive ECC is
probably failing to correct the problem, but thinks it's right which
why there's no read error from the drive.


-- 
Chris Murphy
