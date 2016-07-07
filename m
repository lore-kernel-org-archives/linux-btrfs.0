Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34701 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbcGGXHR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 19:07:17 -0400
Received: by mail-oi0-f54.google.com with SMTP id s66so44036162oif.1
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 16:07:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <577EDA03.9000308@isoar.ca>
References: <0120508a-b9e7-b9e7-4f27-79f982ee07fe@fastmail.fm>
 <577EC57C.8060607@isoar.ca> <0ad5fc23-9b10-5e95-888d-9717a8fb480d@fastmail.fm>
 <577EDA03.9000308@isoar.ca>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 7 Jul 2016 17:07:09 -0600
Message-ID: <CAJCQCtRLncc+y8n136SzoeBh9x26GdkM6Hq-8g7DOXu1nB3m+A@mail.gmail.com>
Subject: Re: Frequent btrfs corruption on a USB flash drive
To: "Andrew E. Mileski" <andrewm@isoar.ca>
Cc: Francesco Turco <fturco@fastmail.fm>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 7, 2016 at 4:38 PM, Andrew E. Mileski <andrewm@isoar.ca> wrote:
> On 2016-07-07 17:13, Francesco Turco wrote:
>>
>>
>> On 2016-07-07 23:11, Andrew E. Mileski wrote:
>>>
>>> How large is this USB flash device?
>>
>>
>> 64 GB.
>>
>
> I don't know if there is an official recommended minimum size for btrfs, but
> I would expect 64 GB to be okay.

In my similar case, it was a 16GiB stick, but the Btrfs on LUKS
partition was maybe 4GiB. Again I used -M and ran into zero problems
in ~6 months of almost daily usage. But not rsync. I was using it for
encrypted /home.




-- 
Chris Murphy
