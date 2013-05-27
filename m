Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:43765 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3E0MbO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 May 2013 08:31:14 -0400
Received: by mail-bk0-f50.google.com with SMTP id ik8so2684580bkc.37
        for <linux-btrfs@vger.kernel.org>; Mon, 27 May 2013 05:31:13 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130527121247.GC28422@twin.jikos.cz>
References: <1369491399-6769-1-git-send-email-fdmanana@gmail.com>
	<1369491399-6769-2-git-send-email-fdmanana@gmail.com>
	<20130527121247.GC28422@twin.jikos.cz>
Date: Mon, 27 May 2013 13:31:13 +0100
Message-ID: <CAL3q7H7qC6iFZ4TSX5Cr2YuCC+sCKTBqcWt+fNnHWgnHjayBjA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: Add missing free() against fs_info->super_copy
From: Filipe David Manana <fdmanana@gmail.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 27, 2013 at 1:12 PM, David Sterba <dsterba@suse.cz> wrote:
> Hi,
>
> please don't forget to mention what changed in a revised version

Yeah, sorry, it was my first usage of git send-email (as described in the wiki).

>
> On Sat, May 25, 2013 at 03:16:39PM +0100, Filipe David Borba Manana wrote:
>> @@ -228,6 +227,8 @@ out:
>>       free(chunk_root);
>>       free(dev_root);
>>       free(csum_root);
>> +     if (fs_info)
>> +             free(fs_info->super_copy);
>
> free accepts NULL pointers and does nothing, so it's fine to do it as in
> the first version.

Right. Just thought it was better to check if the calloc() for fs_info
succeeded before derreferencing it for free'ing its super_copy member
(the function's code doesn't check if any of the malloc() / calloc()
calls returned non-NULL, so it wouldn't be inconsistent with the
existing code)

>
>>       free(fs_info);
>>       return NULL;
>
> otherwise ok. Thanks.

Thanks for review and advise.
Do you need more action from my side?

>
> david



--
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
