Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35667 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752431AbeENJaL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 05:30:11 -0400
Received: by mail-oi0-f66.google.com with SMTP id a6-v6so10057684oia.2
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 02:30:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180514132004.3afec300@natsu>
References: <20180514070210.27047-1-wqu@suse.com> <90871596-c030-930b-57ad-7db63b4f579d@suse.com>
 <20180514132004.3afec300@natsu>
From: james harvey <jamespharvey20@gmail.com>
Date: Mon, 14 May 2018 05:30:09 -0400
Message-ID: <CA+X5Wn6HNAz2xXSU3Rj9BqnfFCLd2EqOnWGhmjC-a4qMHzO1bQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW set
To: Roman Mamedov <rm@romanrm.net>
Cc: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2018 at 4:20 AM, Roman Mamedov <rm@romanrm.net> wrote:
> On Mon, 14 May 2018 11:10:34 +0300
> Nikolay Borisov <nborisov@suse.com> wrote:
>
>> But if we have mounted the fs with FORCE_COMPRESS shouldn't we disregard
>> the inode flags, presumably the admin knows what he is doing?
>
> Please don't. Personally I always assumed chattr +C would prevent both CoW and
> compression, and used that as a way to override volume-wide compress-force for
> a particular folder. Now that it turns out this wasn't working, the patch
> would fix it to behave in line with prior expectations.

"the patch would fix it to behave" might be missing one part.  Qu, am
I right (best guess, not familiar with btrfs internals enough) this
patch will prevent new files and files of size 0 from getting
compression with NODATASUM or NODATACOW, but would leave existing
compressed files (that shouldn't have been compressed) as they are?
After getting an error from btrfs check, presumably, user would need
to copy the file(s) to a temporary and copy it back over itself, to
get rid of the unwanted compression?
