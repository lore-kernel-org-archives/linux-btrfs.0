Return-Path: <SRS0=eQkg=OK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA4FC04EB9
	for <linux-btrfs@archiver.kernel.org>; Sat,  1 Dec 2018 15:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D89520834
	for <linux-btrfs@archiver.kernel.org>; Sat,  1 Dec 2018 15:16:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aasWrqwZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D89520834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbeLBC24 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 1 Dec 2018 21:28:56 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:37462 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbeLBC24 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Dec 2018 21:28:56 -0500
Received: by mail-wr1-f50.google.com with SMTP id j10so7976276wru.4
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Dec 2018 07:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=8yskvswqLIOxYYGNwS2A78Wi/PRdNOjJU8T13u5ZhD8=;
        b=aasWrqwZX5GCAsqBxsqSla02B/hzVJe+FgKZ/1G2x7ajoSdoUGSt/6rh2KDThR98e+
         Fie8LGL9EI7b7wbYCwoRD4nm3/PEgOZ+rIJ9+rpdrVieC/MM4icXPVDhqkzEHA9AH6X+
         6aqdGvkGTnzdsvoYIDmiywht8TpRMYpAR1tuJe2GxCv/P0GaYbrQ2T5o5zxJoqH5MwW0
         sbOrZaW/ZnvLKrpFb3sQLbvIIhvsWwWu37PJxVj3vwQs01hnH8/BeugyAYDwaHXL5SAT
         GG0DXHSO0+8c7GQlT3FC1Wf1bcInccZsk0ePDJlCsOOeMJad5b0fqGaxbaZoUDXRpSvW
         uCww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=8yskvswqLIOxYYGNwS2A78Wi/PRdNOjJU8T13u5ZhD8=;
        b=dM9f3FSt6n39XTdoOKy/ARB1cw6EQDpfkTtJGKl/FFCf9+pOUO6RWRMFGQISkTG5IX
         xoHUxXXpSPuoFFjoB0Ip7/rdBTStN2Ty2NohP8Lo7ejNmM1qMfZW6JPygs5kBJNiopkV
         cRASJ28LeIQ/yO2Y8/fGXTYfqv6n8jNGc0ZxoSAX1YyQ5q9lBnftTN1qRFDO12s4Uzf9
         Bwu1/AEjS7h0/TujuN5ks10jgly2CChxXz1Y9DKzZur8/TQjP70V4kRRXjFDw9Yk+/Iy
         QWRqhh8ywjE9VfGpcpM6TZ9NCpXDCb5MT4gA3f3pxwGSZkLUTO7F3RGaHAqZV/tqu9cV
         H4zQ==
X-Gm-Message-State: AA+aEWYKZz67HI3HoCYUU6iFzrparj2eI56LXe9NscVkbZfyBjG1HiOB
        VVm5NsJ7PeXsGrQzqkTWU+D15Zm4T/bGWSDq4bmJsvL2
X-Google-Smtp-Source: AFSGD/U7QH7TpgO40yshAkNDEYnxu+DQ6e5b846s24lzgaqhSL5TE/loE6EV6Uqfp6VUD3RWaqNa+DuxHzVXJJKeUFk=
X-Received: by 2002:adf:8228:: with SMTP id 37mr8141675wrb.160.1543677370762;
 Sat, 01 Dec 2018 07:16:10 -0800 (PST)
MIME-Version: 1.0
References: <61991cd9-13ba-1834-3112-0f10e925a48c@nuclearwinter.com>
In-Reply-To: <61991cd9-13ba-1834-3112-0f10e925a48c@nuclearwinter.com>
From:   "Janos Toth F." <toth.f.janos@gmail.com>
Date:   Sat, 1 Dec 2018 16:15:57 +0100
Message-ID: <CANznX5GqHJwx+y6b9kruzYXEP93oEhRtHyG_yuWwHV286+fQdw@mail.gmail.com>
Subject: Re: Possible deadlock when writing
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I obviously can't be sure (due to obscure nature of this issue) but I
think I observed similar behavior. For me it usually kicked in during
scheduled de-fragmentation runs. I initially suspected it might have
something to do with running defrag on files which are still opened
for appending writes (through specifying the entire root subvolume
folder recursively). But it kept happening after I omitted those
folders. And I think defrag has nothing more to do with this other
than generating a lot of IO. The SMART status is fine on all disks in
the multi-device filesystem. When this happens the write buffer in the
system RAM is ~full, manual sync hangs forever but some read
operations are successful. Normal reboot is not possible since sync
won't finish (but usually locks the system up pretty well if
attempted).

I didn't see this happening since I updated to 4.19.3 (if I recall
correctly). Although not much time has passed.
On Mon, Nov 26, 2018 at 8:14 PM Larkin Lowrey <llowrey@nuclearwinter.com> wrote:
>
> I started having a host freeze randomly when running a 4.18 kernel. The
> host was stable when running 4.17.12.
>
> At first, it appeared that it was only IO that was frozen since I could
> run common commands that were likely cached in RAM and that did not
> touch storage. Anything that did touch storage would freeze and I would
> not be able to ctrl-c it.
>
> I noticed today, when it happened with kernel 4.19.2, that backups were
> still running and that the backup app could still read from the backup
> snapshot subvol. It's possible that the backups are still able to
> proceed because the accesses are all read-only and the snapshot was
> mounted with noatime so the backup process never triggers a write.
>
> There never are any errors output to the console when this happens and
> nothing is logged. When I first encountered this back in Sept. I managed
> to record a few sysrq dumps and attached them to a redhat ticket. See
> links below.
>
> https://bugzilla.redhat.com/show_bug.cgi?id=1627288
> https://bugzilla.redhat.com/attachment.cgi?id=1482177
>
> I do have several VMs running that have their image files nocow'd.
> Interestingly, all the VMs, except 1, seem to be able to write just
> fine. The one that can't has frozen completely and is the one that
> regularly generates the most IO.
>
> Any ideas on how to debug this further?
>
> --Larkin
