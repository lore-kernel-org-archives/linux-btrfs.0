Return-Path: <SRS0=K5Ec=PE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C76C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 20:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40F38208E4
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 20:07:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="ZrhR+TVZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbeL0UHk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Dec 2018 15:07:40 -0500
Received: from mail-lf1-f48.google.com ([209.85.167.48]:46680 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729504AbeL0UHk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Dec 2018 15:07:40 -0500
Received: by mail-lf1-f48.google.com with SMTP id f23so13310118lfc.13
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2018 12:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=scUezKtcmxXJ8vbDN5+d9NFEs9qJNKbwbY+Pz5XEz5o=;
        b=ZrhR+TVZBXLkbQDLV9fagZgcuR4r/K8oThmcRLoTCWy1Mr8elvm7eIZwEEoTBlLsoM
         AgpVyV2in5OuMjL4RrHKQgTqkmQ9Y+JbGapD3QgGn0WSJAtrurqvXlTEUWv6nhNsA7LD
         ldhsPTSLONItw69KRZXrEyQlPbWWiTk+/94FMDXzc8MNnGY6mThrfF+Y8e5O2XdPjuLd
         OI9ahD+QjMljI3oLVwU5RS14iEFeFB+kcAIMQcqwljemIahzcgQG3+W6WMeZYyhE7psR
         rKpi8Mf+Fb1NpGSjaAZB4SDI3itl236FSwaglN9lMoC1zUrpM6VLDltt0O4ttbL9C8ls
         N0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=scUezKtcmxXJ8vbDN5+d9NFEs9qJNKbwbY+Pz5XEz5o=;
        b=k2ZhzDPdAJ4k9+A6zuIL9Bp8uxSw3mb30TOU6zWnafHxib5sPf5eef8a9fqRZsRcr6
         Z/CB23H/00cAILpdI7GdQHebw3RFl3W49UBrP/h7Zt0Lf3wxVQ5AqIE/nOGyquKEBCru
         BodbNEbSptH9wkXz7yE1jCcW368eOANJ10uzFpS2qYqjnuF4JSiUXoQIxL004HN8LpLh
         xmyR5w3lc+R1OsNxo6GqyS1xG40xNaSHlLHlQoG9lmIbEOc6+PTIgiBuNkGfc1bF1DE9
         IEkgzUUyvRrqo17ibjTAuGYGzO0xGTUe4LzE0RITMlvksGCYIPxumtwLetBrceJ1CS3F
         Rhdw==
X-Gm-Message-State: AA+aEWa56lECsxmqBbKE7kf5OV4TLeHYDPQiDJueagJxJDEz2UdkcVjn
        JWPyIutBF21t7Ip6V+POFI7V6e7lZpm2BXFOKiAMH127
X-Google-Smtp-Source: AFSGD/WQfpE7ArArdPTuGACTdT9HXg//S1Lu0md8MA1ylmXjIRL7e21Cbdz41TdNMy1/bdrNhmXvE0hM3NL090oRhSo=
X-Received: by 2002:a19:2755:: with SMTP id n82mr11924354lfn.94.1545941257574;
 Thu, 27 Dec 2018 12:07:37 -0800 (PST)
MIME-Version: 1.0
References: <96d61222666591a99b9b9f0c42bf4d5f@mailmag.net> <CAJCQCtS7XJaD4Mhrg152K4zfj-w2P0JkpUvZ0R-M6x8QmCc1tg@mail.gmail.com>
 <pan$ac19$67da17d$80a83557$ce46be42@cox.net> <CAJCQCtQrbGfSLi4N5C5fWdy5iEN+s12YkDRFeqVN4O_+E3zjpw@mail.gmail.com>
In-Reply-To: <CAJCQCtQrbGfSLi4N5C5fWdy5iEN+s12YkDRFeqVN4O_+E3zjpw@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 27 Dec 2018 13:07:26 -0700
Message-ID: <CAJCQCtQYgeVDc76uLhpqM2X8VctnpcjVZ7MeckTtraEVgX5cqw@mail.gmail.com>
Subject: Re: btrfs fi usage -T shows unallocated column as total in drive, not
 total available to btrfs
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 27, 2018 at 1:06 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> On Thu, Dec 27, 2018 at 12:14 AM Duncan <1i5t5.duncan@cox.net> wrote:
> >
> > Chris Murphy posted on Wed, 26 Dec 2018 17:36:19 -0700 as excerpted:
> >
> >
> > > I'm not really following this. An fs resize is implied by any device
> > > add, remove or replace command. In the case of replace, it will
> > > efficiently copy the device being replaced to the designated drive, and
> > > then once that succeeds resize the file system to reflect the size of
> > > the replacement device. I'm also confused why devid 4 seems to be
> > > present before and after your device replace, so I have to wonder if
> > > your copy paste really worked out as intended? And also, what version of
> > > kernel and btrfs-progs are you using?
> >
> > I thought... yes...
> >
> > Just checked the btrfs-replace manpage (v4.19.1) and it says:
> >
> > Note
> > the filesystem has to be resized to fully take advantage of a larger
> > target device; this can be achieved with btrfs filesystem
> > resize <devid>:max /path
> >
> > So it does *not* auto-resize after the replace.
>
> Oops. That's unexpected.
>
>
> >
> >
> > Also, I'm not positive on this, and I don't see it mentioned in the
> > manpage, but I /think/ replace (unlike add/remove) keeps the same devid
> > for the new device.
>
> Also unexpected.
>
>
> > It'd be interesting to see what device usage (as opposed to filesystem
> > usage) did with the unreachable space in terms of reporting -- maybe it
> > has that separate line tho I doubt it, but if not does it count it or
> > not?.  But that wasn't posted and presumably the query wasn't run while
> > in the still-unresized state, and I guess it's a bit late now to get it...
>
> I'm not sure, it's one of the commands I almost never use. What is device slack?
>
> From my single device that's handy at this moment, the only item I see
> in 'device usage' that I don't see in 'filesystem usage' is "device
> slack".
>
> Both 'device usage' and 'filesystem usage' show allocated and
> unallocated per device. While 'filesystem usage' shows the used
> portion of allocated, it's per profile, not per chunk.
                                         ^^^^

s/chunk/device


-- 
Chris Murphy
