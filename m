Return-Path: <SRS0=K5Ec=PE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C79C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 20:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C483208E4
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 20:06:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="Mcd2Ib3B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbeL0UGf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Dec 2018 15:06:35 -0500
Received: from mail-lj1-f170.google.com ([209.85.208.170]:43654 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbeL0UGf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Dec 2018 15:06:35 -0500
Received: by mail-lj1-f170.google.com with SMTP id q2-v6so17085057lji.10
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2018 12:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xMW96CqNiJwDpLpdvKWnyFWaKJH1XdBE21yBX8REC3Q=;
        b=Mcd2Ib3Btmby641o7JnSdTZxLUFtNVPPhU60koA+FP0LkeEfiS7GvsIRetAsSOnpvX
         AWPzDllEXCaJ985bQqoYC4jKGtOA815n+Dx8CbkmQxMXQ0aGQM2b3StdDVRl4EKuQR8B
         VBUDQuy6bLSd2ILhE4hHXEAkGBPe3/rrzS5PWnDpKBdQkebDsp+B5emNvSIPv6amvD6t
         BuTBmCG64uG/q63k8vM7vJOTYUML/Q/OnnJSkWYuyIZKGiGTGaUEsKsbxuHRy5o50guP
         EwY7o4d1XVWcVFjJSw6/W+PZkkLO/qBYgS9RAFysOK0uzcjnd8kNs11Jt4ik/oxwigbA
         P5aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xMW96CqNiJwDpLpdvKWnyFWaKJH1XdBE21yBX8REC3Q=;
        b=um7MA9eesZwESkaSHcQxXsnOVA5vBYPXKiHn/gSQJMsWk0Ldr9Jp8MPobewEVU6MhO
         rMw2jCcjLRQ/Stf5fgbWbkF7Zonq9rMaPvSSKqKgXeLRLRGwQzUGXfMXdeYe42vWacvJ
         qY/n2euIEiNcqPYBejTYXt+egM9ncaiWaoC9McPReN1KOoKTOS0lLCd2ReKf8vSzFKM8
         8dBgbNMUgUgSStDskUp7dXZrIGpMnHGmBCGx2i8Pg/ZLNCwazD+WFBhnjloyujdybBAP
         6LSnfTzaF0aJRAR44Q3cDnfS1jTmHXJB5K3t5enqlDRi6kA/4vtBMBS8oYq53m4fhlhF
         L+Cw==
X-Gm-Message-State: AJcUukfdcYH4SlLx+1yu/jIHmn/Y/Z8iZj3I9GGlA94paPZ6zKiyVafO
        2+KHIUHDztv8R5FsBYdQoeva5p7pUCW2RqDf6gxacA==
X-Google-Smtp-Source: ALg8bN5cVQ5kNYAoqsQlThTTTjD9eT+0bv31v8sjTWM56QX8ices0haki6K7/+MnatcxASGxFkVZ5SKAk60UfchdEDo=
X-Received: by 2002:a2e:2e1a:: with SMTP id u26-v6mr16153600lju.8.1545941192697;
 Thu, 27 Dec 2018 12:06:32 -0800 (PST)
MIME-Version: 1.0
References: <96d61222666591a99b9b9f0c42bf4d5f@mailmag.net> <CAJCQCtS7XJaD4Mhrg152K4zfj-w2P0JkpUvZ0R-M6x8QmCc1tg@mail.gmail.com>
 <pan$ac19$67da17d$80a83557$ce46be42@cox.net>
In-Reply-To: <pan$ac19$67da17d$80a83557$ce46be42@cox.net>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 27 Dec 2018 13:06:21 -0700
Message-ID: <CAJCQCtQrbGfSLi4N5C5fWdy5iEN+s12YkDRFeqVN4O_+E3zjpw@mail.gmail.com>
Subject: Re: btrfs fi usage -T shows unallocated column as total in drive, not
 total available to btrfs
To:     Duncan <1i5t5.duncan@cox.net>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 27, 2018 at 12:14 AM Duncan <1i5t5.duncan@cox.net> wrote:
>
> Chris Murphy posted on Wed, 26 Dec 2018 17:36:19 -0700 as excerpted:
>
>
> > I'm not really following this. An fs resize is implied by any device
> > add, remove or replace command. In the case of replace, it will
> > efficiently copy the device being replaced to the designated drive, and
> > then once that succeeds resize the file system to reflect the size of
> > the replacement device. I'm also confused why devid 4 seems to be
> > present before and after your device replace, so I have to wonder if
> > your copy paste really worked out as intended? And also, what version of
> > kernel and btrfs-progs are you using?
>
> I thought... yes...
>
> Just checked the btrfs-replace manpage (v4.19.1) and it says:
>
> Note
> the filesystem has to be resized to fully take advantage of a larger
> target device; this can be achieved with btrfs filesystem
> resize <devid>:max /path
>
> So it does *not* auto-resize after the replace.

Oops. That's unexpected.


>
>
> Also, I'm not positive on this, and I don't see it mentioned in the
> manpage, but I /think/ replace (unlike add/remove) keeps the same devid
> for the new device.

Also unexpected.


> It'd be interesting to see what device usage (as opposed to filesystem
> usage) did with the unreachable space in terms of reporting -- maybe it
> has that separate line tho I doubt it, but if not does it count it or
> not?.  But that wasn't posted and presumably the query wasn't run while
> in the still-unresized state, and I guess it's a bit late now to get it...

I'm not sure, it's one of the commands I almost never use. What is device slack?

From my single device that's handy at this moment, the only item I see
in 'device usage' that I don't see in 'filesystem usage' is "device
slack".

Both 'device usage' and 'filesystem usage' show allocated and
unallocated per device. While 'filesystem usage' shows the used
portion of allocated, it's per profile, not per chunk.


-- 
Chris Murphy
