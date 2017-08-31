Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:33395 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbdHaSuq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 14:50:46 -0400
Received: by mail-qt0-f172.google.com with SMTP id e2so2385786qta.0
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Aug 2017 11:50:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170831183302.GB30990@carfax.org.uk>
References: <CAJ_hD5By15sSvur7849XWQ8jkBoGj0cO5vQfY8MguVDCneMX8Q@mail.gmail.com>
 <20170831183302.GB30990@carfax.org.uk>
From: Eric Wolf <19wolf@gmail.com>
Date: Thu, 31 Aug 2017 14:50:24 -0400
Message-ID: <CAJ_hD5A8_dxUr781mndBwj7sTf7Aohw4uFCFQGw1k_QNM=psnQ@mail.gmail.com>
Subject: Re: BTRFS critical (device sda2): corrupt leaf, bad key order:
 block=293438636032, root=1, slot=11
To: Hugo Mills <hugo@carfax.org.uk>, Eric Wolf <19wolf@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also, I know it was caused by bad RAM and that ram has since been removed.
---
Eric Wolf
(201) 316-6098
19wolf@gmail.com


On Thu, Aug 31, 2017 at 2:33 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, Aug 31, 2017 at 01:53:58PM -0400, Eric Wolf wrote:
>> I'm having issues with a bad block(?) on my root ssd.
>>
>> dmesg is consistently outputting "BTRFS critical (device sda2):
>> corrupt leaf, bad key order: block=293438636032, root=1, slot=11"
>>
>> "btrfs scrub stat /" outputs "scrub status for b2c9ff7b-[snip]-48a02cc4f508
>> scrub started at Wed Aug 30 11:51:49 2017 and finished after 00:02:55
>> total bytes scrubbed: 53.41GiB with 2 errors
>> error details: verify=2
>> corrected errors: 0, uncorrectable errors: 2, unverified errors: 0"
>>
>> Running "btrfs check --repair /dev/sda2" from a live system stalls
>> after telling me corrupt leaf etc etc then "11 12". CPU usage hits
>> 100% and disk activity remains at 0.
>
>    This error is usually attributable to bad hardware. Typically RAM,
> but might also be marginal power regulation (blown capacitor
> somewhere) or a slightly broken CPU.
>
>    Can you show us the output of "btrfs-debug-tree -b 293438636032 /dev/sda2"?
>
>    Hugo.
>
> --
> Hugo Mills             | "You got very nice eyes, Deedee. Never noticed them
> hugo@... carfax.org.uk | before. They real?"
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |                                 Don Logan, Sexy Beast
