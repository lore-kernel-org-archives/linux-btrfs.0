Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:35646 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbcAOM3I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 07:29:08 -0500
Received: by mail-lf0-f46.google.com with SMTP id c192so281788719lfe.2
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 04:29:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7pQ576qKqknWEA2Trgu4hn_6SV00vm2fLwz=_MJ8Nw2Q@mail.gmail.com>
References: <5698B534.4040202@xoxy.net> <CAGqmi76EQ1NYFhp7hdwdrP0VTNXdSYgePje036UGRWDnUV=EWw@mail.gmail.com>
 <CAL3q7H7pQ576qKqknWEA2Trgu4hn_6SV00vm2fLwz=_MJ8Nw2Q@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 15 Jan 2016 15:28:26 +0300
Message-ID: <CAGqmi74Fxu_RBXpfDEZ727uKtP-Eg-5K4GSPnP2sRxeC5S0SEQ@mail.gmail.com>
Subject: Re: Copying between lzo compressed BtrFS's: de/re-compressing.
To: Filipe Manana <fdmanana@gmail.com>
Cc: Diagon <kernel.boxy@xoxy.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, Filipe ^_^

2016-01-15 15:25 GMT+03:00 Filipe Manana <fdmanana@gmail.com>:
> On Fri, Jan 15, 2016 at 9:56 AM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
>> 2016-01-15 12:00 GMT+03:00 Diagon <kernel.boxy@xoxy.net>:
>>> I'm copying a large number of files between two lzo compressed BtrFS
>>> filesystems on different drives mounted on the same machine. It appears
>>> that the files are being de/re-compressed. Is there a way avoid this?
>>
>> If you just copy files, files will be decompressed while reading and
>> recompressed while writing
>> For avoiding this, you must use send receive feature
>
> No, send/receive does not avoid decompression on the send side nor
> re-compression at the receiving side. The receiving side writes the
> data from a send stream, which is uncompressed, to the destination
> filesystem using standard system calls like write/pwrite.
>
>>
>>
>> --
>> Have a nice day,
>> Timofey.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."



-- 
Have a nice day,
Timofey.
