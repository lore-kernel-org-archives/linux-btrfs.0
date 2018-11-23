Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FEE6C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 09:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E33FC20820
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 09:34:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=theleadbetters.com header.i=@theleadbetters.com header.b="JfhBUilI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E33FC20820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=theleadbetters.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394243AbeKWURp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 15:17:45 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39585 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387987AbeKWURp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 15:17:45 -0500
Received: by mail-oi1-f194.google.com with SMTP id 192-v6so9487370oii.6
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Nov 2018 01:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theleadbetters.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sms7DW3LBGN21nekXBtW5mQxNUmOiPORFpmqiuHD10k=;
        b=JfhBUilIZeu8qsHVayuNjFDHDS7qzige224f9tpPvVDs0/6i6oJzWOvdhMGe3tWEcH
         OdahCCZdg66McMAnQTwB8H4voLUz34cq6LgxTWFo2HIqr+FXnmOCQ09VKXPDysWUkats
         uLbAKLUrABwRjduqIlQ3mpsVr/OZxxy+9I6Tg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sms7DW3LBGN21nekXBtW5mQxNUmOiPORFpmqiuHD10k=;
        b=nRIhoposGkbdFoTiRWb3ijjGnNa+FgCq+orNLbS/sqgMOlYnB3URJOzbKqHVsBK0H9
         +NtrO0uDW9DFqUyDBntRhvzZ4KU1P/ExGeZyNZLXTnIKj2Tfv/zMXecTPH/WPmaRQwfY
         3zz4nJ2a47ThIOPU+KWNuZZxK/5Mj0njT4lXuq52hCQ8qP2TyI9GI+JlFdNuvoEBNt2w
         +q7Ca1aXBpgedMiipZh+VUgdk7pz79qls6mvTnXpEDnKZsJDwZ2bLXdjrH3JDnkZN7y2
         xfc+JbQrQPZ2FHArpPcdF0MoSKkQI6bL0F12vPeeHAdnxsaB9oUaB58ryPP6w3UCbwTO
         GLyw==
X-Gm-Message-State: AGRZ1gJO96KJlNByO67Qj73Wedd7CedO+5DV0GlOtuJaLL7tGOSXRCfE
        3H2JDJWj//+o0xOyMgotuwOoMgs1aTjuWJSMOznxWQDKYt0=
X-Google-Smtp-Source: AJdET5c/MuuT4NXdudkBenIVbcMmxpU1i5Oioc+NryERXScmfx22tK2lGOlsIHUIV8ky9/Wkt3l+C0z7QdH/2HsZLJE=
X-Received: by 2002:aca:ab16:: with SMTP id u22mr8322115oie.249.1542965656058;
 Fri, 23 Nov 2018 01:34:16 -0800 (PST)
MIME-Version: 1.0
References: <CAJUWh6qyHerKg=-oaFN+USa10_Aag5+SYjBOeLCX1qM+WcDUwA@mail.gmail.com>
 <CAJCQCtSRgX+nffcycRgPhYLZN7_HNL-OM2wgyw7MpLLWqzY5dw@mail.gmail.com>
In-Reply-To: <CAJCQCtSRgX+nffcycRgPhYLZN7_HNL-OM2wgyw7MpLLWqzY5dw@mail.gmail.com>
From:   Andy Leadbetter <andy.leadbetter@theleadbetters.com>
Date:   Fri, 23 Nov 2018 09:34:03 +0000
Message-ID: <CAJUWh6pFz=-K_Tg=uAD4KGF=kGjTN0Qc3omFKBzYOhJiUCqbyw@mail.gmail.com>
Subject: Re:
To:     lists@colorremedies.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Will capture all of that this evening, and try it with the latest
kernel and tools.  Thanks for the input on what info is relevant, with
gather it asap.
On Fri, 23 Nov 2018 at 07:53, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Thu, Nov 22, 2018 at 11:41 PM Andy Leadbetter
> <andy.leadbetter@theleadbetters.com> wrote:
> >
> > I have a failing 2TB disk that is part of a 4 disk RAID 6 system.  I
> > have added a new 2TB disk to the computer, and started a BTRFS replace
> > for the old and new disk.  The process starts correctly however some
> > hours into the job, there is an error and kernel oops. relevant log
> > below.
>
> The relevant log is the entire dmesg, not a snippet. It's decently
> likely there's more than one thing going on here. We also need full
> output of 'smartctl -x' for all four drives, and also 'smartctl -l
> scterc' for all four drives, and also 'cat
> /sys/block/sda/device/timeout' for all four drives. And which bcache
> mode you're using.
>
> The call trace provided is from kernel 4.15 which is sufficiently long
> ago I think any dev working on raid56 might want to see where it's
> getting tripped up on something a lot newer, and this is why:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/diff/fs/btrfs/raid56.c?id=v4.19.3&id2=v4.15.1
>
> That's a lot of changes in just the raid56 code between 4.15 and 4.19.
> And then in you call trace, btrfs_dev_replace_start is found in
> dev-replace.c which likewise has a lot of changes. But then also, I
> think 4.15 might still be in the era where it was not recommended to
> use 'btrfs dev replace' for raid56, only non-raid56. I'm not sure if
> the problems with device replace were fixed, and if they were fixed
> kernel or progs side. Anyway, the latest I recall, it was recommended
> on raid56 to 'btrfs dev add' then 'btrfs dev remove'.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/diff/fs/btrfs/dev-replace.c?id=v4.19.3&id2=v4.15.1
>
> And that's only a few hundred changes for each. Check out inode.c -
> there are over 2000 changes.
>
>
> > The disks are configured on top of bcache, in 5 arrays with a small
> > 128GB SSD cache shared.  The system in this configuration has worked
> > perfectly for 3 years, until 2 weeks ago csum errors started
> > appearing.  I have a crashplan backup of all files on the disk, so I
> > am not concerned about data loss, but I would like to avoid rebuild
> > the system.
>
> btrfs-progs 4.17 still considers raid56 experimental, not for
> production use. And three years ago, the current upstream kernel
> released was 4.3 so I'm gonna guess the kernel history of this file
> system goes back older than that, very close to raid56 code birth. And
> then adding bcache to this mix just makes it all the more complicated.
>
>
>
> >
> > btrfs dev stats shows
> > [/dev/bcache0].write_io_errs    0
> > [/dev/bcache0].read_io_errs     0
> > [/dev/bcache0].flush_io_errs    0
> > [/dev/bcache0].corruption_errs  0
> > [/dev/bcache0].generation_errs  0
> > [/dev/bcache1].write_io_errs    0
> > [/dev/bcache1].read_io_errs     20
> > [/dev/bcache1].flush_io_errs    0
> > [/dev/bcache1].corruption_errs  0
> > [/dev/bcache1].generation_errs  14
> > [/dev/bcache3].write_io_errs    0
> > [/dev/bcache3].read_io_errs     0
> > [/dev/bcache3].flush_io_errs    0
> > [/dev/bcache3].corruption_errs  0
> > [/dev/bcache3].generation_errs  19
> > [/dev/bcache2].write_io_errs    0
> > [/dev/bcache2].read_io_errs     0
> > [/dev/bcache2].flush_io_errs    0
> > [/dev/bcache2].corruption_errs  0
> > [/dev/bcache2].generation_errs  2
>
>
> 3 of 4 drives have at least one generation error. While there are no
> corruptions reported, generation errors can be really tricky to
> recover from at all. If only one device had only read errors, this
> would be a lot less difficult.
>
>
> > I've tried the latest kernel, and the latest tools, but nothing will
> > allow me to replace, or delete the failed disk.
>
> If the file system is mounted, I would try to make a local backup ASAP
> before you lose the whole volume. Whether it's LVM pool of two drives
> (linear/concat) with XFS, or if you go with Btrfs -dsingle -mraid1
> (also basically a concat) doesn't really matter, but I'd get whatever
> you can off the drive. I expect avoiding a rebuild in some form or
> another is very wishful thinking and not very likely.
>
> The more changes are made to the file system, repair attempts or
> otherwise writing to it, decreases the chance of recovery.
>
> --
> Chris Murphy
