Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:34360 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbFDOxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 10:53:52 -0400
Received: by obew15 with SMTP id w15so34382922obe.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2015 07:53:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABgvyo9DJ9Z0EyAcdFLE9w+PTpheH9EOjzNy_0EUX+kYZFedOA@mail.gmail.com>
References: <CABgvyo9DJ9Z0EyAcdFLE9w+PTpheH9EOjzNy_0EUX+kYZFedOA@mail.gmail.com>
From: Richard Michael <rmichael@edgeofthenet.org>
Date: Thu, 4 Jun 2015 10:53:10 -0400
Message-ID: <CABR0jEQrqZuptx+jb7jFnuhYHqWuCg3P4r_Bc3cS_p-pe+m-Kw@mail.gmail.com>
Subject: Re: copy complete subvolume/snapshot structure
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Johan,

No, AFAIK, " send ... | .. receive " will not include subvolumes.

This was discussed in various threads on-list in late April/early May.
I suggest perusing these:

http://thread.gmane.org/gmane.comp.file-systems.btrfs/44459
http://thread.gmane.org/gmane.comp.file-systems.btrfs/44890
http://thread.gmane.org/gmane.comp.file-systems.btrfs/45031

Concerning the backup of subvolumes, Snazzer is frequently mentioned.
(I have not used it myself.)

https://github.com/csirac2/snazzer


Regards,
Richard

On Thu, Jun 4, 2015 at 10:20 AM, Johan Kröckel <johan.kroeckel@gmail.com> wrote:
> Hello,
> I am wondering, what is the fastest und most secure way to copy a
> complete btrfs-volume including the subvolume-structure to another
> volume?
> Just btrfs send/receive like this?
>> btrfs send /vol1|btrfs receive vol2
>
> Thanks in advance
> Johan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
