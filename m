Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:37031 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752039AbeENJbd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 05:31:33 -0400
Received: by mail-oi0-f68.google.com with SMTP id w123-v6so10051446oia.4
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 02:31:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ea90a7da-a055-6879-e64f-f0f3bca81a23@suse.com>
References: <20180514070210.27047-1-wqu@suse.com> <90871596-c030-930b-57ad-7db63b4f579d@suse.com>
 <20180514132004.3afec300@natsu> <ea90a7da-a055-6879-e64f-f0f3bca81a23@suse.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Mon, 14 May 2018 05:31:32 -0400
Message-ID: <CA+X5Wn6r+jGAEhZFeunRf4cqhuL6qjtkwPUnxTf_DWOdru-JRA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW set
To: Nikolay Borisov <nborisov@suse.com>
Cc: Roman Mamedov <rm@romanrm.net>, Qu Wenruo <wqu@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2018 at 4:36 AM, Nikolay Borisov <nborisov@suse.com> wrote:
> On 14.05.2018 11:20, Roman Mamedov wrote:
>> On Mon, 14 May 2018 11:10:34 +0300
>> Nikolay Borisov <nborisov@suse.com> wrote:
>>
>>> But if we have mounted the fs with FORCE_COMPRESS shouldn't we disregard
>>> the inode flags, presumably the admin knows what he is doing?
>>
>> Please don't. Personally I always assumed chattr +C would prevent both CoW and
>> compression, and used that as a way to override volume-wide compress-force for
>> a particular folder. Now that it turns out this wasn't working, the patch
>> would fix it to behave in line with prior expectations.
>
>
> So what made you have these expectation, is it codified somewhere
> (docs/man pages etc)? I'm fine with that semantics IF this is what
> people expect.

https://btrfs.wiki.kernel.org/index.php/Compression

"Compression... does not work for NOCOW files."

IMO, without a checksum, allowing compression is too much of a data
risk.  Uncompressed, user may be able to salvage most of the data with
partial corruption.  Compressed, they can't get anything to even look
at, unless they have a mirrored copy that is fine, figure out which
disk is corrupted, and mount degraded without it.

> Now the question is why people grew up to have this expectation and not
> the other way round? IMO force_compress should really disregard
> everything else, if not then it should be documented. The man pages [0]
> say:
>
> "
> If compress-force is specified, the compression will allways be
> attempted, but the data may end up uncompressed if the compression would
> make them larger.
>
> As this is too simple, the compress-force is a workaround that will
> compress most of the files at the cost of some wasted CPU cycles on
> failed attempts. The heuristics of compress will improve in the future
> so this will not be necessary.
> "
>
> In this case I think the man page for this option should be documented
> to say that inode-specific flags preclude mount flags.
>
> https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs(5)#MOUNT_OPTIONS

Agreed the man page should be clarified.
