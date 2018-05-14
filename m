Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57147 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752209AbeENKgY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 06:36:24 -0400
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW
 set
To: james harvey <jamespharvey20@gmail.com>, Roman Mamedov <rm@romanrm.net>
Cc: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20180514070210.27047-1-wqu@suse.com>
 <90871596-c030-930b-57ad-7db63b4f579d@suse.com>
 <20180514132004.3afec300@natsu>
 <CA+X5Wn6HNAz2xXSU3Rj9BqnfFCLd2EqOnWGhmjC-a4qMHzO1bQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f6da1d59-c68a-9adb-464f-629b94067538@gmx.com>
Date: Mon, 14 May 2018 18:35:58 +0800
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn6HNAz2xXSU3Rj9BqnfFCLd2EqOnWGhmjC-a4qMHzO1bQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年05月14日 17:30, james harvey wrote:
> On Mon, May 14, 2018 at 4:20 AM, Roman Mamedov <rm@romanrm.net> wrote:
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
> "the patch would fix it to behave" might be missing one part.  Qu, am
> I right (best guess, not familiar with btrfs internals enough) this
> patch will prevent new files and files of size 0 from getting
> compression with NODATASUM or NODATACOW,

Yep.

> but would leave existing
> compressed files (that shouldn't have been compressed) as they are?

Yep again, unfortunately.

> After getting an error from btrfs check,

BTW for this particular case, --mode=lowmem would provide more detailed
info.

> presumably, user would need
> to copy the file(s) to a temporary and copy it back over itself, to
> get rid of the unwanted compression?

Unfortunately, reading (copying) data from the original fs is no longer
that safe (just like your case).

But if reading works fine, then copying things back will trigger normal
write routine, thus it would be plain text extent.

And if possible, please don't just remove those offending files (yet).
Your binary dump would help a lot locating the root case.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
