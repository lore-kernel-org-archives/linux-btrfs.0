Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:38923 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3CRWs5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 18:48:57 -0400
Received: by mail-qa0-f43.google.com with SMTP id dx4so2047180qab.9
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 15:48:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130318191815.15073.49770@localhost.localdomain>
References: <514759B5.5000507@lolwut.org>
	<20130318191815.15073.49770@localhost.localdomain>
Date: Tue, 19 Mar 2013 09:48:56 +1100
Message-ID: <CA+WRLO_09TLuoJ4QEzudrNxksJUYsktTRqgYX3=GR2O3989oCw@mail.gmail.com>
Subject: Re: Impossible or Possible to Securely Erase File on Btrfs?
From: Gareth Pye <gareth@cerberos.id.au>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Kyle <lists@lolwut.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Would it make sense for btrfs to support a write zeros to empty space
erase? I know it would be slow as it would have to write to all the
free space in the file system but it would be useful.

It's probably pretty far down the priority list for development though I expect.

On Tue, Mar 19, 2013 at 6:18 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> Quoting Kyle (2013-03-18 14:15:17)
>> Hi,
>>
>> After reading through the btrfs documentation I'm curious to know if
>> it's possible to ever securely erase a file from a btrfs filesystem (or
>> ZFS for that matter). On non-COW filesystems atop regular HDDs one can
>> simply overwrite the file with zeros or random data using dd or some
>> other tool and rest assured that the blocks which contained the
>> sensitive information have been wiped. However on btrfs it would seem
>> any such attempt would write the zeros/random data to a new location,
>> leaving the old blocks with the sensitive data intact. Further, since
>> specifying NOCOW is only possible for newly created files, there seems
>> to be no way to overwrite the appropriate blocks short of deleting the
>> associated file and then filling the entire free filesystem space with
>> zeros/random data such that the old blocks are eventually overwritten.
>> What's the verdict on this?
>
> We don't do this now for other reasons mentioned in the thread.  The
> best path to get here is to use trim, and to find a device that supports
> a secure erase trim (I don't know if this even exists, sorry).
>
> Outside of that, the only way to do this securely is to delete the
> files, rotate in new drives, rotate out the old drives, and run a full
> drive secure delete (not very practical).
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Gareth Pye
Level 2 Judge, Melbourne, Australia
Australian MTG Forum: mtgau.com
gareth@cerberos.id.au - www.rockpaperdynamite.wordpress.com
"Dear God, I would like to file a bug report"
