Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:36028 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbbFDOrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 10:47:08 -0400
Received: by lbbqq2 with SMTP id qq2so28669145lbb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2015 07:47:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABR0jER2tmpFS4bf5jACJL3ukknjLMrRf5mP_OQjNbcrz+-VtA@mail.gmail.com>
References: <CABgvyo9DJ9Z0EyAcdFLE9w+PTpheH9EOjzNy_0EUX+kYZFedOA@mail.gmail.com>
 <CABR0jER2tmpFS4bf5jACJL3ukknjLMrRf5mP_OQjNbcrz+-VtA@mail.gmail.com>
From: =?UTF-8?Q?Johan_Kr=C3=B6ckel?= <johan.kroeckel@gmail.com>
Date: Thu, 4 Jun 2015 16:46:26 +0200
Message-ID: <CABgvyo9dnX9t_cQG3t1YPLJB7G_TEp2RiOi45n0ce58hJBxdGA@mail.gmail.com>
Subject: Re: copy complete subvolume/snapshot structure
To: Richard Michael <rmichael@edgeofthenet.org>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you! My fault.

2015-06-04 16:42 GMT+02:00 Richard Michael <rmichael@edgeofthenet.org>:
> Hi Johan,
>
> This was discussed in various threads on-list in late April/early May.  I
> suggest perusing these:
>
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/44459
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/44890
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/45031
>
> Concerning the backup of subvolumes, Snazzer is frequently mentioned.  (I
> have not used it myself.)
>
> https://github.com/csirac2/snazzer
>
>
> Regards,
> Richard
>
> On Thu, Jun 4, 2015 at 10:20 AM, Johan Kröckel <johan.kroeckel@gmail.com>
> wrote:
>>
>> Hello,
>> I am wondering, what is the fastest und most secure way to copy a
>> complete btrfs-volume including the subvolume-structure to another
>> volume?
>> Just btrfs send/receive like this?
>> > btrfs send /vol1|btrfs receive vol2
>>
>> Thanks in advance
>> Johan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
