Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FEAC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 15:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A1DC206B7
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 15:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k2JR3B3n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbfAJPuY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 10:50:24 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34700 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728196AbfAJPuY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 10:50:24 -0500
Received: by mail-pg1-f193.google.com with SMTP id j10so5003375pga.1
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2019 07:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OQEhwD9zLAZ6qPsDRI1RXf4RGqXmJqh8OV1crAS2NFQ=;
        b=k2JR3B3nUFqHg3yQ/hkCtKl1jJEW/QYtIHn0dk3dH+2wcvOxNHp87Y7qJ5+TOJHlXz
         NE60YbG6EbO1+3I8VWVo9K5hF8+lXFG3wt4lYTy1LlZhJ1pRS5pmRHkPWJOq5TiiIEgm
         5c6UVQvezI+rsTZe2gopvQ/Xfq+N0Hg/xQfwga9oNVD4mIGvYMUgZ64Jn4jXV/hYVlWs
         Axvacqj4Jdbp4KNwnfaeTHkp5NYXwFzwkCWLkkbbui8VwRPKy8hN2GCu4THffWYLCbyn
         qqNHy9vR3YAARw0KFjScATBgCMaGTyj2joLAsct69Au/pNVmiPROBRkCl/En/Sz8BKtt
         Z+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OQEhwD9zLAZ6qPsDRI1RXf4RGqXmJqh8OV1crAS2NFQ=;
        b=Mu4DErhl9QIwRmEntmljsGOlOO1PBxaSs7q2v6UmGtVDayrHQ22x9ZCPJ3PKkhTh5a
         loyvlNU9+9GwHDNioZHrUzeWWGQwCrwzp3tctN1X/SuDMqvLHeqK5NyBRG5ZI6quG5Xk
         dw/jvHYD7lklcaDBmoVyPZarGyDQSau99eVhptQP9yDviZN+D9wRWB9vT9/0krTaKQMZ
         vlU1OHW/FQc8VWMC2CjcbrJBzlFJtKLqOn/p+gexHfvvUeA/q13mw9s7MqUCmJ+iTxUh
         /RrXjknKj6nmX5s8uthrZSe2h/IhVNtOuVA34sc+vLe8XdNwIQ66hAhQNV6KXWTffRfF
         gWIg==
X-Gm-Message-State: AJcUukdIqJXi5ZExxWXONOatY2fnGC0hKWLGVOZdeh9ln+R/UAArFdph
        puPf4z72F6I+uGdimg2ySES6c/PylAFal8prtBq3Sw==
X-Google-Smtp-Source: ALg8bN6cYnEYobX0WZE+cfdlRdzqG6/2cb0btyqI8LfsgFW4RsPLAhCGs6X+LoH8tEJyV+zWt7OmjqPYxkAfLzzAEQE=
X-Received: by 2002:aa7:868f:: with SMTP id d15mr10544722pfo.225.1547135422475;
 Thu, 10 Jan 2019 07:50:22 -0800 (PST)
MIME-Version: 1.0
References: <CAO1Y9wrAzSxGx+LYMPswzN4BbMNs__v7+y=BTZRBAW2bRN5Q1w@mail.gmail.com>
 <a6270ef1-c914-e142-448c-7e7a388f221f@gmx.com>
In-Reply-To: <a6270ef1-c914-e142-448c-7e7a388f221f@gmx.com>
From:   Thiago Ramon <thiagoramon@gmail.com>
Date:   Thu, 10 Jan 2019 13:50:26 -0200
Message-ID: <CAO1Y9wpZ2B-Uik3+zyQQdu4HvjM5RzNoPcv+Hcz1io7e5+D9MQ@mail.gmail.com>
Subject: Re: Nasty corruption on large array, ideas welcome
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 8, 2019 at 10:05 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/1/9 =E4=B8=8A=E5=8D=883:33, Thiago Ramon wrote:
> > I have a pretty complicated setup here, so first a general description:
> > 8 HDs: 4x5TB, 2x4TB, 2x8TB
> >
> > Each disk is a LVM PV containing a BCACHE backing device, which then
> > contains the BTRFS disks. All the drives then were in writeback mode
> > on a SSD BCACHE cache partition (terrible setup, I know, but without
> > the caching the system was getting too slow to use).
> >
> > I had all my data, metadata and system blocks on RAID1, but as I'm
> > running out of space, and the new kernels are getting better RAID5/6
> > support recently, I've finally decided to migrate to RAID6 and was
> > starting it off with the metadata.
> >
> >
> > It was running well (I was already expecting it to be slow, so no
> > problem there), but I had to spend some days away from the machine.
> > Due to an air conditioning failure, the room temperature went pretty
> > high and one of the disks decided to die (apparently only
> > temporarily). BCACHE couldn't write to the backing device anymore, so
> > it ejected all drives and let them cope with it by themselves. I've
> > caught the trouble some 12h later, still away, and shut down anything
> > accessing the disks until I could be physically there to handle the
> > issue.
> >
> > After I got back and got the temperature down to acceptable levels,
> > I've checked the failed drive, which seems to be working well after
> > getting re-inserted, but it's of course out of date with the rest of
> > the drives. But apparently the rest got some corruption as well when
> > they got ejected from the cache, and I'm getting some errors I haven't
> > been able to handle.
> >
> > I've gone through the steps here that helped me before when having
> > complicated crashes on this system, but this time it wasn't enough,
> > and I'll need some advice from people who know the BTRFS internals
> > better than me to get this back running. I have around 20TB of data in
> > the drives, so copying the data out is the last resort, as I'd prefer
> > to let most of it die than to buy a few disks to fit all of that.
> >
> >
> > Now on to the errors:
> >
> > I've tried both with the "failed" drive in (which gives me additional
> > transid errors) and without it.
> >
> > Trying to mount with it gives me:
> > [Jan 7 20:18] BTRFS info (device bcache0): enabling auto defrag
> > [ +0.000010] BTRFS info (device bcache0): disk space caching is enabled
> > [ +0.671411] BTRFS error (device bcache0): parent transid verify
> > failed on 77292724051968 wanted > 1499510 found 1499467
> > [ +0.005950] BTRFS critical (device bcache0): corrupt leaf: root=3D2
> > block=3D77292724051968 slot=3D2, bad key order, prev (39029522223104 16=
8
> > 212992) current (39029521915904 168 16384)
>
> Heavily corrupted extent tree.
>
> And there is a very good experimental patch for you:
> https://patchwork.kernel.org/patch/10738583/
>
> Then go mount with "skip_bg,ro" mount option.
>
> Please note this can only help you to salvage data (kernel version of
> btrfs-store).
>
> AFAIK, the corruption may affect fs trees too, so be aware of corrupted
> data.
>
> Thanks,
> Qu
>
>

Thanks for pointing me to that patch, I've tried it and the FS mounted
without issues.
I've managed to get a snapshot of the folder structure and haven't
noticed anything important missing, is there some way to get a list of
anything that might have been corrupted, or I'll just find out as I
try to access the file contents?
Also, is there any hope of recovering the trees in place or should I
just abandon this one and start with a new volume?
It occurred to me that I might be able to run a scrub in the disk now
that it's mounted, is that even possible in a situation like this, and
more importantly, is it sane?

and finally, thanks again for the patch,
Thiago Ramon

> > [ +0.000378] BTRFS error (device bcache0): failed to read block groups:=
 -5
> > [ +0.022884] BTRFS error (device bcache0): open_ctree failed
> >
> > Trying without the disk (and -o degraded) gives me:
> > [Jan 8 12:51] BTRFS info (device bcache1): enabling auto defrag
> > [ +0.000002] BTRFS info (device bcache1): allowing degraded mounts
> > [ +0.000002] BTRFS warning (device bcache1): 'recovery' is deprecated,
> > use 'usebackuproot' instead
> > [ +0.000000] BTRFS info (device bcache1): trying to use backup root at
> > mount time[ +0.000002] BTRFS info (device bcache1): disabling disk
> > space caching
> > [ +0.000001] BTRFS info (device bcache1): force clearing of disk cache
> > [ +0.001334] BTRFS warning (device bcache1): devid 2 uuid
> > 27f87964-1b9a-466c-ac18-b47c0d2faa1c is missing
> > [ +1.049591] BTRFS critical (device bcache1): corrupt leaf: root=3D2
> > block=3D77291982323712 slot=3D0, unexpected item end, have 685883288
> > expect 3995
> > [ +0.000739] BTRFS error (device bcache1): failed to read block groups:=
 -5
> > [ +0.017842] BTRFS error (device bcache1): open_ctree failed
> >
> > btrfs check output (without drive):
> > warning, device 2 is missing
> > checksum verify failed on 77088164081664 found 715B4470 wanted 580444F6
> > checksum verify failed on 77088164081664 found 98775719 wanted FA63AD42
> > checksum verify failed on 77088164081664 found 98775719 wanted FA63AD42
> > bytenr mismatch, want=3D77088164081664, have=3D274663271295232
> > Couldn't read chunk tree
> > ERROR: cannot open file system
> >
> > I've already tried super-recover, zero-log and chunk-recover without
> > any results, and check with --repair fails the same way as without.
> >
> > So, any ideas? I'll be happy to run experiments and grab more logs if
> > anyone wants more details.
> >
> >
> > And thanks for any suggestions.
> >
>
