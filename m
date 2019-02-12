Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D85C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 22:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFC91222C7
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 22:54:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="rTEgyios"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbfBLWyK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 17:54:10 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39409 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729041AbfBLWyK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 17:54:10 -0500
Received: by mail-lf1-f65.google.com with SMTP id m11so279842lfc.6
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 14:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=46FsSIePR8UCSPY/sQO92qJ8FNC2gf9JLmnLWtqdkk4=;
        b=rTEgyios0zvcz//KL6QmFXzFjCa35NsMC1yUZ+DOePzY3c8yg6nEQ4fpQ5BEugap8q
         W5ABqf7v2aOw58JxF/Kc2/x74c9wJ0xQtEtopxU8cT5URv8IsRDIvfJAlHPRY4SHhRvF
         HVFeIMspwo7h+9NqZfY1KmjyVf5pl2k1zgdVkwo6AgBO8rjJari6/S+qPdRvojqLpHsE
         ESXqvJH4rduTN1fxzyc7prAfHAZJuUAQOLsS4HzhKPbqmFn1hNzPtOnF5TTEN9qZ24i5
         LgJ3n11CTRC+lohrFnn5Kb/UPCf0MmpXEI0/RZhYbEUK7nelRWnG4Eiv2HMRVHcIQz9Q
         ggwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=46FsSIePR8UCSPY/sQO92qJ8FNC2gf9JLmnLWtqdkk4=;
        b=bGE3cCxFRCES+7YNX+QGxkeroTpq+a0vyeAj8WAWXIHq0eC2kI75ve7a68tDj8bFNk
         mQKramgajfPXYV1C1MoyVQFTzGXWpT1GdZP+7Bve/AoY3JJqeELosOZCW+zqopBgkQuz
         FH6OXHgTcxtWrJQZMh1csIZUSmnJ77/KCNmxxoQTe7+BFSnbR5DGOJJn5NMP4aPICoAP
         mm443ZAkmHxlGRdc4XMuTkX8tnH1lr+ukfUZwcice++0CWNAtZjGU2SKhmj7oZjrby/w
         E/GPCGwxSG8k3lzZNPr9NWbEYR7m6jZyqRlyfnoPDEAsVrHgMxQpEFZnOWg9jtdHJmgK
         axkg==
X-Gm-Message-State: AHQUAuawPKn2dgeozbDrqJmrmAaloPHLvU7qAKBWBZ1z1u5n8bvu2wmC
        427J6ln3zKIVSrCpjys9Br6pJ5GRu6E/yO57YnyQ7sNF
X-Google-Smtp-Source: AHgI3IZuM/yVyMZOhXzQD0BF4MPjuiNpXenAt7euJ8KAWhikxzaOG4mZIfZ8I/aF3tg1QPi5ETRtgABoQK9DzwBYIVc=
X-Received: by 2002:a19:cfd5:: with SMTP id f204mr4108539lfg.65.1550012047254;
 Tue, 12 Feb 2019 14:54:07 -0800 (PST)
MIME-Version: 1.0
References: <20180823031125.GE13528@hungrycats.org> <20190212030838.GB9995@hungrycats.org>
 <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
 <20190212165916.GA23918@hungrycats.org> <b7d76392-6414-804f-c383-a43dc2d81c1c@gmail.com>
 <CAJCQCtT1K4RY+_nmcWZdzHVSno-ijHZYLfJz4vu-irN4p+ZYxA@mail.gmail.com> <20190212221107.GC23918@hungrycats.org>
In-Reply-To: <20190212221107.GC23918@hungrycats.org>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 12 Feb 2019 15:53:53 -0700
Message-ID: <CAJCQCtQcU0CvVf-NGt3ZHZo773meYeW3UVyPS6iP+2C_Kd-jZQ@mail.gmail.com>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 12, 2019 at 3:11 PM Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
>
> On Tue, Feb 12, 2019 at 02:48:38PM -0700, Chris Murphy wrote:
> > Is it possibly related to the zlib library being used on
> > Debian/Ubuntu? That you've got even one reproducer with the exact same
> > hash for the transient error case means it's not hardware or random
> > error; let alone two independent reproducers.
>
> The errors are not consistent between runs.  The above pattern is quite
> common, but it is not the only possible output.  Add in other processes
> reading the 'am' file at the same time and it gets very random.
>
> The bad data tends to have entire extents missing, replaced with zeros.
> That leads to a small number of possible outputs (the choices seem to be
> only to have the data or have the zeros).  It does seem to be a lot more
> consistent in recent (post 4.14.80) kernels, which may be interesting.
>
> Here is an example of a diff between two copies of the 'am' file copied
> while the repro script was running, filtered through hd:
>
>         # diff -u /tmp/f1 /tmp/f2
>         --- /tmp/f1     2019-02-12 17:05:14.861844871 -0500
>         +++ /tmp/f2     2019-02-12 17:05:16.883868402 -0500
>         @@ -56,10 +56,6 @@
>          *
>          00020000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>          *
>         -00021000  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |................|
>         -*
>         -00022000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>         -*
>          00023000  12 12 12 12 12 12 12 12  12 12 12 12 12 12 12 12  |................|
>          *
>          00024000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>         @@ -268,10 +264,6 @@
>          *
>          000a0000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>          *
>         -000a1000  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |................|
>         -*
>         -000a2000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>         -*
>          000a3000  12 12 12 12 12 12 12 12  12 12 12 12 12 12 12 12  |................|
>          *
>          000a4000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>         @@ -688,10 +680,6 @@
>          *
>          001a0000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>          *
>         -001a1000  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |................|
>         -*
>         -001a2000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>         -*
>          001a3000  12 12 12 12 12 12 12 12  12 12 12 12 12 12 12 12  |................|
>          *
>          001a4000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>         @@ -1524,10 +1512,6 @@
>          *
>          003a0000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>          *
>         -003a1000  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |................|
>         -*
>         -003a2000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>         -*
>          003a3000  12 12 12 12 12 12 12 12  12 12 12 12 12 12 12 12  |................|
>          *
>          003a4000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>         @@ -3192,10 +3176,6 @@
>          *
>          007a0000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>          *
>         -007a1000  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |................|
>         -*
>         -007a2000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>         -*
>          007a3000  12 12 12 12 12 12 12 12  12 12 12 12 12 12 12 12  |................|
>          *
>          007a4000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>         @@ -5016,10 +4996,6 @@
>          *
>          00c00000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>          *
>         -00c01000  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  |................|
>         -*
>         -00c02000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>         -*
>         [etc...you get the idea]

And yet the file is delivered to user space, despite the changes, as
if it's immune to checksum computation or matching. The data is
clearly difference so how is it bypassing checksumming? Data csums are
based on original uncompressed data, correct? So any holes are zeros,
there are still csums for those holes?

>
> I'm not sure how the zlib library is involved--sha1sum doesn't use one.
>
> > And then what happens if you do the exact same test but change to zstd
> > or lzo? No error? Strictly zlib?
>
> Same errors on all three btrfs compression algorithms (as mentioned in
> the original post from August 2018).

Obviously there is a pattern. It's not random. I just don't know what
it looks like. I use compression, for years now, mostly zstd lately
and a mix of lzo and zlib before that, but never any errors or
corruptions. But I also never use holes, no punched holes, and rarely
use fallocated files which I guess isn't quite the same thing as hole
punching.

So the bug you're reproducing is for sure 100% not on the media
itself, it's somehow transiently being interpreted differently roughly
1 in 10 reads, but with a pattern. What about scrub? Do you get errors
every 1 in 10 scrubs? Or how does it manifest? No scrub errors?

I know very little about what parts of the kernel a file system
depends on outside of its own code (e.g. page cache) but I wonder if
there's something outside of Btrfs that's the source but it never gets
triggered because no other file systems use compression. Huh - what
file system uses compression *and* hole punching? squashfs? Is sparse
file support different than hole punching?


-- 
Chris Murphy
