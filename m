Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E001C169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 19:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5543420844
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 19:03:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="i55p6QK/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfA2TDK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 14:03:10 -0500
Received: from mail-lj1-f173.google.com ([209.85.208.173]:35442 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729394AbfA2TDK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 14:03:10 -0500
Received: by mail-lj1-f173.google.com with SMTP id x85-v6so18504844ljb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2019 11:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YCKLb0EsQZBB2sTckeseOCKxwZIIY5hS/Aq+IlLYQpk=;
        b=i55p6QK/lx9LpLUiWfiuqaT6l3tEethaqilxBD6/ki1PE2fOcSqInvLU2wqBNkZ/KJ
         h/gzCFq6iwawH9QeXzoez9b4Sk9pNZzqcLW+KcJH65SZ8OSgR1ZkOBM9ucCESdQNtv+n
         BtW6V3hS4nm9T4/EHHR3SrJHTt9T8EUNiKSiC01GA6/aGs/7x6Htm/8ybP0E+QBFP4KN
         BdMFJoSTUoAB2oE2z2UsAbkI4uKvvrz0zEkIAMYn0gFXsJrE1eNs7y2gM0hVm/o8Esd4
         CqYSCEWijmNtCNAnmyLOthBSnqFedQ54gnUICZfA+m20ujOuDTIIky1SES2Gz4OAw10d
         xucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YCKLb0EsQZBB2sTckeseOCKxwZIIY5hS/Aq+IlLYQpk=;
        b=aiVGjtSCvqlDntylGDMb77RLZAK1uWbt22Pn+UHfiRSgX73dIyA80uSpe/ocVg9gmZ
         p6hZL/JJTBXxsiCOkjguqEjnHMdmCtpWWErfEjrc7ZShKWe00cfq1O4e44f8gAPSIWqo
         zuqaKHCchbidBXpKX9WJ5Y93DWKEkWBYUe0HcBfMS8UvkCS19uyoJuPDyMIkyRWZRJUP
         wsTEJQUmegLUuDX+JltfpSPkR5IxgAVcdmxvBHusuFSwa5STi134vzhi4UD7ZTzwxKo0
         aCt0FKCsdFA6WusCkiBAORsgAdzn5bFnbYZYfgBXwJfGVjf5ydYZPr0afUg0pC9cpy0C
         rhWA==
X-Gm-Message-State: AJcUukc2t5OLNCX0LuDFdjtNeZiqZInDZ0irkcxW0Gvf/xBrRn3+pVKi
        iMoIsPxH/0jQEV9tNLjl3rj0nfV80YekRFGRu9qdUCJO
X-Google-Smtp-Source: ALg8bN50JGeNFn/lm/IRCV30x66Ca85dFdKTVd9nSLc2KNWRIBBofmLEoFXwDaZoLmzQtpza+7cp9XNMBsmPp8MlHGU=
X-Received: by 2002:a2e:a289:: with SMTP id k9-v6mr21159699lja.24.1548788587792;
 Tue, 29 Jan 2019 11:03:07 -0800 (PST)
MIME-Version: 1.0
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
 <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com> <a18f2081-cf5d-d914-bb16-dba51c949c30@gmail.com>
 <36be9ca6-4aa0-f00a-c1b4-a59026a1909e@georgianit.com>
In-Reply-To: <36be9ca6-4aa0-f00a-c1b4-a59026a1909e@georgianit.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 29 Jan 2019 12:02:54 -0700
Message-ID: <CAJCQCtQ=mGdZ+90uR68hwqFcZaNP8xQwKXkpO395xB+KBXRkxA@mail.gmail.com>
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
To:     Remi Gauvin <remi@georgianit.com>
Cc:     DanglingPointer <danglingpointerexception@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 28, 2019 at 3:52 PM Remi Gauvin <remi@georgianit.com> wrote:
>
> On 2019-01-28 5:07 p.m., DanglingPointer wrote:
>
> > From Qu's statement and perspective, there's no difference to other
> > non-BTRFS software RAID56's out there that are marked as stable (except
> > ZFS).
> > Also there are no "multiple serious data-loss bugs".
> > Please do consider my proposal as it will decrease the amount of
> > incorrect paranoia that exists in the community.
> > As long as the Wiki properly mentions the current state with the options
> > for mitigation; like backup power and perhaps RAID1 for metadata or
> > anything else you believe as appropriate.
>
> Should implement some way to automatically scrub on unclean shutdown.
> BTRFS is the only (to my knowlege) Raid implementation that will not
> automatically detect an unclean shutdown and fix the affected parity
> blocks, (either by some form of write journal/write intent map, or full
> resync.)

There's no dirty bit set on mount, and thus no dirty bit to unset on
clean mount, from which to infer a dirty unmount if it's present at
the next mount.

If there were a way to implement an abridged scrub, it could be done
on every mount if metadata uses raid56 profile. But I think Qu is
working on something like a raid56 that would obviate the problem,
which is probably the best and most scalable solution.

An abridged scrub could be metadata only, and only if it's raid56 profile.

But still in 2019, we have this super crap default SCSI block layer
command timeout of 30 seconds. This encourages corruption in common
consumer devices by prematurely resetting it when it's merely in deep
recoveries that take longer than 30s. And this prevents automatic
repair from happening, since it prevents the device from reporting a
discrete read + sector value error, and therefore the problem gets
masked behind link resets.


-- 
Chris Murphy
