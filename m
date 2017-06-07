Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from oc.oops.co.at ([85.90.244.114]:40584 "EHLO oc.oops.co.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751601AbdFGOzz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Jun 2017 10:55:55 -0400
Subject: Re: getting rid of "csum failed" on a hw raid
To: Adam Borowski <kilobyte@angband.pl>, Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5693147c-befc-da58-cb20-6af31e9aa9cb@xunil.at>
 <CAGqmi76XY0+sYZb3XaDs3rHKzZa=t2kzaGCE+uq_K4vz7PK5_A@mail.gmail.com>
 <b8195f2f-adf8-4eb6-2d48-ac6bb5f182fd@xunil.at>
 <CAGqmi77URH-XTW7fCB+NqzcSb-Y+LvwuvQep+CRJ6_ENgRtWRQ@mail.gmail.com>
 <20170607130902.q3stj6wj52duvmr2@angband.pl> <20170607184848.6218c92f@natsu>
 <20170607135219.blgoomc4mwt5ebvj@angband.pl>
From: "Stefan G. Weichinger" <lists@xunil.at>
Message-ID: <ad923a84-bd2c-a8fd-8532-c7dc73d1870f@xunil.at>
Date: Wed, 7 Jun 2017 16:55:53 +0200
MIME-Version: 1.0
In-Reply-To: <20170607135219.blgoomc4mwt5ebvj@angband.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 2017-06-07 um 15:52 schrieb Adam Borowski:
> On Wed, Jun 07, 2017 at 06:48:48PM +0500, Roman Mamedov wrote:
>> On Wed, 7 Jun 2017 15:09:02 +0200
>> Adam Borowski <kilobyte@angband.pl> wrote:
>>>> Yes, because btrfs will return -EIO
>>>> So try dd_rescue
>>>
>>> Or even plain dd conv=noerror.  Both will do a faithful analogue of a
>>> physical disk with a silent data corruption on the affected sectors.
>>
>> Yeah, except "plain dd conv=noerror" will produce a useless corrupted image,
>> because it will be shifted forward by the number of unreadable bytes after the
>> first error.
>>
>> You also need the "sync" flag in there.
> 
> Doh, yeah.
> 
>> Or just stick with dd_rescue and not try to correct people's perfectly good
>> suggestions with completely wrong and harmful ones.
> 
> On the other hand, you have dd everywhere, while dd_rescue is not available
> on most bootable media not specifically made for rescue purposes.  And
> installing extra software when your disk is already unsound but mostly
> working might be risky.

I had ddrescue (without "_") on the given server (gentoo linux) and was
able to copy the 2 files via

ddrescue -n -e1 $filename /other_fs/$filename

I then cp-ied the file back via plain "cp" and the VM started again.
Looks good, now also btrfs scr is happy!

Now it's interesting if there is an underlying corruption happening in
the hardware (on disks).

thanks so far, Stefan


