Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34890 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbbLSPbg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Dec 2015 10:31:36 -0500
Received: by mail-lf0-f54.google.com with SMTP id l133so88778978lfd.2
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Dec 2015 07:31:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450469988@msgid.manchmal.in-ulm.de>
References: <1450423394@msgid.manchmal.in-ulm.de>
	<CAPmG0jZYidy-ra-R-C5GQNQhUZeVSB6anCg7N9sFSY5NrrO61w@mail.gmail.com>
	<1450469988@msgid.manchmal.in-ulm.de>
Date: Sat, 19 Dec 2015 16:31:34 +0100
Message-ID: <CAPmG0jYet6-hGRZQyoh6TrvBPDOZhhPjPjZZiiCEkmtEtR4bLg@mail.gmail.com>
Subject: Re: ERROR: scrubbing <dev> failed for device id 1: ret=-1, errno=28
 (No space left on device)
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 18, 2015 at 9:38 PM, Christoph Biedl
<linux-kernel.bfrz@manchmal.in-ulm.de> wrote:
> Henk Slager wrote...
>
>> you need to do some balancing, as I think that the free space is too
>> fragmented and the system fails to allocate extra metadata space
>> needed for scrub doing writes into metadata.
>>
>> # btrfs balance start -dusage=<number>
>> with number somewhere between 5 and 50; first start with lower number
>> and repeat and increase until the 5.17GiB gets closer down to the
>> 3.75GiB
>
> Thanks, that one worked with number 100. Still some ENOSPC errors but
> appeareantly good enough to make scrubbing work.
>
>> The issue is that for for a filesystem of this size (6.5GiB), it would
>> have been better to have mixed data/metadata allocation. See help of
>> mkfs.btrfs. So maybe you want to recreate the fs like that, otherwise
>> you might easily hit this problem again if you don't monitor free
>> space / balance regularly.
>
> Will keep that in mind. Just out of curiousity: Initially, the file
> system size was just 4 Gibyte. Is it possible this made things worse?
That should not matter.

> Oh, and by the way:
>
> --- a/Documentation/mkfs.btrfs.asciidoc
> +++ b/Documentation/mkfs.btrfs.asciidoc
> @@ -77,7 +77,7 @@ where the space is reserved for the other block group type, is not available for
>  allocation and can lead to ENOSPC state.
>  +
>  The recommended size for the mixed mode is for filesystems less than 1GiB. The
> -soft recommendation is to use it for filesystems smaller than 5GiB. Thie mixed
> +soft recommendation is to use it for filesystems smaller than 5GiB. The mixed
>  mode may lead to degraded performance on larger filesystems, but is otherwise
>  usable, even on multiple devices.
>  +
>
>
>     Christoph
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
