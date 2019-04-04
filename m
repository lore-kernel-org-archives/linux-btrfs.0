Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AD6C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 17:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CAF02075E
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 17:31:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="zyk69UwT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbfDDRbg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 13:31:36 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:46932 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727562AbfDDRbg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Apr 2019 13:31:36 -0400
Received: by mail-lj1-f175.google.com with SMTP id h21so2796854ljk.13
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Apr 2019 10:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SO1POOFymPhH6dVF4CtUPhHXRC+72x/FdWX62mNdNDI=;
        b=zyk69UwTcKQjAZ3I/LyQK00KAjZuoubZWz+0pMBuoY1OyvoWDIM5QZ4z5ACYxpLYA5
         bqM1hjbOs/fTWDCZlvJ4y4ZpFWY4K2w/rGWOh6ijnkIJd3Oo5+KNGGEx6NeGzBprWJKK
         j0vO7N5mSzs1IEM8ww/g9S647KL1jy1ocsQGU5zOdJl5IyTNDSxgIj2/EYtPiU/B1DPr
         DuHHLUf4Zkk5bGD5AeZm2cDlcQmanmTV7IbjI+Poysfj4g5UO5TBfH9pHoKHWqrZnJGL
         4k/NXoymBISh3Q/O+FxFbisbmn9zlyg5ZqTjVFOPRuUHjTGw8lOjnmpX0hdhSw1U8YgD
         zzBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SO1POOFymPhH6dVF4CtUPhHXRC+72x/FdWX62mNdNDI=;
        b=GSihNh7SNKWPQpN1YhnHkXNpGZWxMV/YZkvCZ33J3u1wtFPM+Q05GIdgdx8K3YeUa2
         9c5nARZcdsmq6NXUcGpyeTTu07J5CvyULPzBbGf0p9mtu/pHQhbNJetapAP7bWwA+LsT
         QDHeylIUHLgtd/cYx8mXR/y7O9/NcIC7ma6DUNN3Spsad9t/WOIjP1fDn8gA8KaCLnsj
         ImQwRPRXyRD1v/oJL1EopjPlokYH7e4UTAZcHUxIH0XcG7cIlpD5LcvbAMURgh5Zs3ah
         278A+kJNvo8wnDp616O5EgtoT+J8xCtrTfzZDNaa8BzMlCBpKB+haLF2ElGb8G16tXar
         Xl4Q==
X-Gm-Message-State: APjAAAWkHkxBOkan8TbP2zUbvHbCcr3n9BhgFgnPBNG2RAiGL8Ul1rWD
        r2sHOTWKcS/Uq106cPZVsnJXoXsqTcf/HgVKJG3KZ4cAi4o=
X-Google-Smtp-Source: APXvYqym0/JldN5Ss9kQnp3sO6lNBcV7R62s6yHEw6clR3xzV9g7+rsIKIXbUdsWf/4acqNNcohErE9105thhcvyYt4=
X-Received: by 2002:a2e:8507:: with SMTP id j7mr4353533lji.85.1554399094049;
 Thu, 04 Apr 2019 10:31:34 -0700 (PDT)
MIME-Version: 1.0
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu> <95d0844a-27e3-b1c6-3ef5-ed2df3f0e367@suse.com>
 <3a3537f5-b84c-ee01-b5da-d6bab5bdf221@avgustinov.eu>
In-Reply-To: <3a3537f5-b84c-ee01-b5da-d6bab5bdf221@avgustinov.eu>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 4 Apr 2019 11:31:22 -0600
Message-ID: <CAJCQCtRp+53U_RG+n6oTpBrRRhSSR36OLBc++Q9dQDbHFovurw@mail.gmail.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     "Nik." <btrfs@avgustinov.eu>
Cc:     Jeff Mahoney <jeffm@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 4, 2019 at 9:58 AM Nik. <btrfs@avgustinov.eu> wrote:
>
>
> 2019-04-04 04:48, Jeff Mahoney:
> > On 3/31/19 2:44 PM, btrfs@avgustinov.eu wrote:
> >> Dear all,
> >>
> >>
> >> I am a big fan of btrfs, and I am using it since 2013 - in the meantime
> >> on at least four different computers. During this time, I suffered at
> >> least four bad btrfs-failures leading to unmountable, unreadable and
> >> unrecoverable file system. Since in three of the cases I did not manage
> >> to recover even a single file, I am beginning to lose my confidence in
> >> btrfs: for 35-years working with different computers no other file
> >> system was so bad at recovering files!
> >>
> >> Considering the importance of btrfs and keeping in mind the number of
> >> similar failures, described in countless forums on the net, I have got
> >> an idea: to donate my last two damaged filesystems for investigation
> >> purposes and thus hopefully contribute to the improvement of btrfs. One
> >> condition: any recovered personal data (mostly pictures and audio files)
> >> should remain undisclosed and be deleted.
> >>
> >> Should anybody be interested in this - feel free to contact me
> >> personally (I am not reading the list regularly!), otherwise I am going
> >> to reformat and reuse both systems in two weeks from today.
> >>
> >> Some more info:
> >>
> >>    - The smaller system is 83.6GB, I could either send you an image of
> >> this system on an unneeded hard drive or put it into a dedicated
> >> computer and give you root rights and ssh-access to it (the network lin
> >> is 100Mb down, 50Mb up, so it should be acceptable).
> >>
> >>    - The used space on the other file system is about 3 TB (4 TB
> >> capacity) and it is distributed among 5 drives, so I can only offer
> >> remote access to this, but I will need time to organize it.
> >>
> >> If you need additional information - please ask, but keep in mind that I
> >> have almost no "free time" and the answer could need a day or two.
> >
> > My team is always interested in images of broken file systems.  This is
> > how --repair evolves.  Images with failed --repair operations are still
> > valuable.  That's the first step most users take and why wouldn't they?
> >   If --repair is misbehaving, the end result shouldn't be "I hope you
> > have backups."
>
> I absolutely agree!
>
> > It's not the size of the file system that matters so much.  The data on
> > it doesn't matter from a debugging perspective and, in any event, it's
> > not written to the image file anyway.  I do want a btrfs-image file from
> > the file system, and if btrfs-image fails to create a usable image,
> > that's also valuable to know and fix.
>
> The larger filesystem gives me the following output (kernel
> 5.0.6-050006-generic, btrfs-progs v4.20.2):
>
> # btrfs-image -c 9 /dev/md0 /mnt/b/md.img
> incorrect offsets 15003 146075
> ERROR: open ctree failed
> ERROR: create failed: Success
>
> Last line is funny.

I've complained about that nonsense for a while and yet it remains. A
successful failure is an ERROR. I still don't know what it means but I
suspect it's an incomplete image.


> The smaller system let me create an image, but the size of the file,
> resulting from "btrfs-image -c 9 /dev/sdXY ...", is surprisingly small -
> only 536576B. I guess this is conform with the man-page: "All data will
> be zeroed, but metadata and the like is preserved. Mainly used for
> debugging purposes."
>
> I shall send you a link to the image (in a private mail) as soon as
> possible. Please, respect any private data in case you manage to recover
> something.

You should use -ss option for this reason.


-- 
Chris Murphy
