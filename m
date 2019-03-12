Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A5C7C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 17:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 594F2206DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 17:35:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G7xSW81K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbfCLRfG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 13:35:06 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42009 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbfCLRet (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 13:34:49 -0400
Received: by mail-ot1-f68.google.com with SMTP id i5so3231444oto.9
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 10:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mkoWpXPxXGZdkfbcNh0s4aNJgcewFEGyX9xsaJOdYrM=;
        b=G7xSW81KYFZ/rz0OkHr8QLLrZjFpBbzjeFOkShu5bbjsOdWwO3CmbnpGEJ0/gII9AQ
         q4YjWCPawlqlEMzR5ZDXwvlXooOnyBr4LXcCemnc1PXuB/hQeCIUDNuTSgsigq6hJLx0
         xYh1Le3Oi5i1n06v6XtopxeZ2zg9R9lcYmnJ+STtRuuhL4VO+nXXGxaczxzgX6wAchkl
         Ardm8gEWghMXDmryQWHcIZXw9lBqHXo0UzhFsfIkU1m3aVLLfUvsxxlp+lmV5G7TCYX6
         QJK5PWxroJJ9+kY6LmdJcNwvX1agc2BoJKELCjh0XAw9NKemPbpmIrK7RpWZTKYbYZdE
         oodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mkoWpXPxXGZdkfbcNh0s4aNJgcewFEGyX9xsaJOdYrM=;
        b=jurQnJtQr/LkhPlAccqQLQAfVUDoVRSDpFPQUS7F0laECY6Sb3WNZ3aM25DE+qZQ0N
         nxb6AAmeJoLsL6EK3/g5XCChGmJBgNfeQWlArYFwbpaW+sFmmYsAi80eB8LXzJoH+TDr
         q9XfCFpTb7/bKJ1cec2aKTCuTL80lUJtS2aHj5JWjqdUY1EF0S1FDlH/dX2IlxLom3NJ
         0GBjelVNpFjeHWaXgWSOzS5sRdSOHtcC5YG4ORS9WrBwHAzsEquDqG6Sj1oo/FFzGCnX
         Nzy1j5SxZeZzVQapUPlbzQWoTaGLc1HyKaCX3IgBiMvyj4sr0Q0l5ovsTLtjeqOvTSm+
         Fm2A==
X-Gm-Message-State: APjAAAUyDLtBV6Z5oAk8NmHvAk0x/zag3Uliop5MWnc2BYJojf8XSJSD
        NTdDU4IgbCoRVEteZqV9AViQh7sKUUg4DS4XrMG1IFqz7mE=
X-Google-Smtp-Source: APXvYqy6vbU2e53tbpqx/+oG+tdTsBRCCYQwdXwfmLb15dTUpDrclGvrFslEozBSHeSAPAIcFv167LhCIiULzjLQYac=
X-Received: by 2002:a05:6830:1241:: with SMTP id s1mr25012128otp.24.1552412087684;
 Tue, 12 Mar 2019 10:34:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190312040024.GI9995@hungrycats.org>
In-Reply-To: <20190312040024.GI9995@hungrycats.org>
From:   Jorge Bastos <jorge.mrbastos@gmail.com>
Date:   Tue, 12 Mar 2019 17:34:36 +0000
Message-ID: <CAHzMYBS039kb-w0aUqyA=M_COyKKQmfE0tidUghgQwGOQDhreg@mail.gmail.com>
Subject: Re: Spurious "ghost" "parent transid verify failed" messages on
 4.14.x, 4.20.14
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I've got similar errors when doing a balance and send/receive at the
same time, in these cases send/receive would abort because of the
errors, but it all worked normally after waiting for the balance to
finish, no more errors, though now I try to remember to disable any
scheduled send/receive jobs before a balance.

Jorge

On Tue, Mar 12, 2019 at 4:03 AM Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
>
> On 4.14.x and 4.20.14 kernels (probably all the ones in between too,
> but I haven't tested those), I get what I call "ghost parent transid
> verify failed" errors.  Here's an unedited recent example from dmesg:
>
>         [16180.649285] BTRFS error (device dm-3): parent transid verify failed on 1218181971968 wanted 9698 found 9744
>         [16864.457119] BTRFS error (device dm-3): parent transid verify failed on 981488238592 wanted 9758 found 9763
>         [16864.459153] BTRFS error (device dm-3): parent transid verify failed on 981488238592 wanted 9758 found 9763
>         [16865.409955] BTRFS error (device dm-3): parent transid verify failed on 981488238592 wanted 9758 found 9763
>         [16865.413091] BTRFS error (device dm-3): parent transid verify failed on 981488238592 wanted 9758 found 9763
>         [16865.583441] BTRFS error (device dm-3): parent transid verify failed on 981488238592 wanted 9758 found 9763
>         [16865.586602] BTRFS error (device dm-3): parent transid verify failed on 981488238592 wanted 9758 found 9763
>         [17364.870504] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17364.879696] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17364.901713] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17376.127722] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17376.129965] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17376.132919] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17376.250605] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17376.253633] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17376.577192] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17376.585174] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17380.720874] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17380.735643] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17383.282250] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17383.286598] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17433.417529] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17433.420685] BTRFS error (device dm-3): parent transid verify failed on 564765081600 wanted 9774 found 9779
>         [17881.816489] BTRFS error (device dm-3): parent transid verify failed on 785410277376 wanted 9786 found 9794
>         [17881.820072] BTRFS error (device dm-3): parent transid verify failed on 785410277376 wanted 9786 found 9794
>         [17881.824307] BTRFS error (device dm-3): parent transid verify failed on 785410277376 wanted 9786 found 9794
>         [19525.602623] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
>         [19525.605395] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
>         [19525.829326] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
>         [19525.834123] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
>         [19525.905553] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
>         [19525.909302] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
>         [19525.914374] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
>         [19525.917829] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
>         [19525.980067] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
>         [19525.983479] BTRFS error (device dm-3): parent transid verify failed on 984570740736 wanted 9841 found 9846
>
> They seem to occur while running these simultaneously:
>
>         * rsync receiving a lot of data
>
>         * snapshot delete to make space for more data
>
>         * bees deduping said data--possibly on the snapshot being
>         deleted.
>
> All three seem to be needed--these messages do not appear if one of the
> above is not running at the time.  I can get the messages on a test VM
> that is running nothing but the above three things on the test filesystem.
>
> Unlike the usual disaster cases when "parent transid verify failed"
> messages appear, these incidents seem to be entirely harmless.  They've
> been appearing for years (since at least the first v4.14 kernels)
> and...nothing else happens.  The filesystem doesn't go read-only.
> It doesn't become irreparably damaged.  Nothing locks up or crashes
> (at the same time).  The system just keeps running normally, often for
> months, emitting a few of these messages during longer snapshot deletes.
>
> This happens on several different host systems.  There is no sign of
> hardware failure.  It looks like a real bug, but I don't have a simpler
> reproducer, and sometimes weeks or months pass between incidents on a
> given machine.
>
> Scrubs are always clean.  There are never errors recorded in btrfs
> dev stat:
>
>         # btrfs dev stat /testfs/
>         [/dev/mapper/vgtest-tvdb].write_io_errs   0
>         [/dev/mapper/vgtest-tvdb].read_io_errs    0
>         [/dev/mapper/vgtest-tvdb].flush_io_errs   0
>         [/dev/mapper/vgtest-tvdb].corruption_errs 0
>         [/dev/mapper/vgtest-tvdb].generation_errs 0
>         [/dev/mapper/vgtest-tvdc].write_io_errs   0
>         [/dev/mapper/vgtest-tvdc].read_io_errs    0
>         [/dev/mapper/vgtest-tvdc].flush_io_errs   0
>         [/dev/mapper/vgtest-tvdc].corruption_errs 0
>         [/dev/mapper/vgtest-tvdc].generation_errs 0
>
> dump-tree on the offending block doesn't find a metadata page in the
> block right after the error occurs.  Sometimes it finds a newer block
> (higher transid) some hours later:
>
>         # btrfs ins dump-tree -b 984570740736 /dev/mapper/vgtest-tvdc
>         btrfs-progs v4.20.1
>         leaf 984570740736 items 151 free space 7525 generation 9882 owner EXTENT_TREE
>         leaf 984570740736 flags 0x1(WRITTEN) backref revision 1
>         [...etc]
>
> Mount options common to all systems exhibiting this behavior:
>
>         rw,noatime,compress,space_cache=v2
>
>         both ssd and nossd
>
>         any of: compress, compress-force, compress-force=zstd, compress=zstd
>
> My guess/theory:  someone is maybe holding a reference to metadata
> they don't hold a lock for, and the page is being updated or replaced
> underneath due to the snapshot delete, triggering the verification
> failure.  The error doesn't get persisted to disk because by the time the
> error is discovered, the page was already deleted by the snapshot delete.
> No errors are getting persisted to disk, so it's probably something
> that happens in a read operation rather than a write operation.  Every
> application reads and writes data, so if it were in plain read or write
> code someone else would have noticed by now.  it's probably not a common
> code path.  bees seems to be required to trigger the bug (or triggers it
> much more often) so it may be a problem somewhere in one of the ioctls
> bees uses.  bees does a lot of FILE_EXTENT_SAME, TREE_SEARCH_V2, and
> LOGICAL_INO ioctls.  It could be any of the three, but FILE_EXTENT_SAME
> does writes, and TREE_SEARCH_V2 isn't used by bees to look at items in
> EXTENT_TREE, which leaves LOGICAL_INO which starts from EXTENT_TREE and
> works outwards to subvol trees.  So my guess is it's a bug in LOGICAL_INO.
