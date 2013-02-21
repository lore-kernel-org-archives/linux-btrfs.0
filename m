Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64618 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3BURzb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 12:55:31 -0500
Received: by mail-pa0-f44.google.com with SMTP id kp1so4879601pab.31
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 09:55:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130221154602.GE12051@shiny.masoncoding.com>
References: <20130220142612.GA2062@localhost.localdomain>
	<CADU+-uBHcLUQQiv526xTheB_csCq5-fXOHgJbXCAZG9t5z2xdQ@mail.gmail.com>
	<20130221154602.GE12051@shiny.masoncoding.com>
Date: Thu, 21 Feb 2013 09:55:30 -0800
Message-ID: <CADU+-uBdHLroqTL=5804uNkoUNJQJTgkd6QUQBVGyf6WHBVC_A@mail.gmail.com>
Subject: Re: LAST CALL FOR BTRFS-NEXT
From: Filipe Brandenburger <filbranden@google.com>
To: Chris Mason <chris.mason@fusionio.com>,
        Filipe Brandenburger <filbranden@google.com>,
        Josef Bacik <JBacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok,

Nothing terribly broken with it, I can do with incremental commits on
top of it, thanks!

Filipe


On Thu, Feb 21, 2013 at 7:46 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> On Thu, Feb 21, 2013 at 08:20:37AM -0700, Filipe Brandenburger wrote:
>> Hi Josef,
>>
>> Please remove the following patch:
>>
>> Btrfs: move fs/btrfs/ioctl.h to include/uapi/linux/btrfs.h
>> (55e301fd57a6239ec14b91a1cf2e70b3dd135194 in your btrfs-next.git)
>>
>> It's not fully cooked and I'm working on a second version of the patch
>> that will do a little more rearranging of the header files according
>> to the discussion on IRC a while ago.
>>
>
> Please send those as incremental fixes unless something is horribly
> broken in the current patch.
>
> -chris
