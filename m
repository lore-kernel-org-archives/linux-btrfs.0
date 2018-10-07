Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F8FC65C31
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 08:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69FC320895
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 08:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U1Kbn7in"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69FC320895
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbeJGPQB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 11:16:01 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]:45396 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbeJGPQB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2018 11:16:01 -0400
Received: by mail-qk1-f172.google.com with SMTP id m8-v6so10396470qka.12
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Oct 2018 01:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uOr6PMGCGDEdpfeqdQmtwgXjrkq8ArgvSJAU0ukqCSc=;
        b=U1Kbn7in6ZdqX0Lq1iGG5WmD8I8SYW48jpWRTMhWUpCWLRDQzX7rzFJzqa5Wb2RZ98
         5WI2AlWoezPOvhKrwBU0yYBPZT/2FylqPuUh4otbL6ZKZGyUOQ4oLATGOTGy7oxcl2NU
         udX9ttHjSejff8w44N3v2BSg6BUVxq/J8SpuGC37C2Cz+0CRMKF9cIKkIcJMHgrcv1e1
         YiyIXoLNaeYhFsKb8/DILlaF8PVs4DcAsfA9C0ZCA1zJuel2jsDBueYghMGYxkTRVIGD
         XsJoQHNTBfWB1Gv7QAhgsodJHQ69kMo6SRjC0d8d6R9VtduUm02tn7q9DStZLCf4VWKg
         xHvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uOr6PMGCGDEdpfeqdQmtwgXjrkq8ArgvSJAU0ukqCSc=;
        b=lh6EQLRfOZK9uKQwxueLn347OUYZgXa3UTaavQRrhhCJoUeOTNN6+1y5xhTlhU2wO+
         3sc5IMyhxB/lz2INyR85BpapDxMCm1kllV84C3tnFTmfoko9t2veyJyEQ9xJH15Fli5H
         CTme+mnU997V0IO0YJxptuWgXlmACnjlyt/Ix+SzEB8ptCKN+gBXWeEXoxqTf1dHqtNV
         JPnYi3Ku1pkfLZWk/SAvXISmO4RAerAIhjum18xrCFEVdnrsl66/tYzYqCHyvbqKdnuo
         TAOTc1NLXTdcUULm6r/igI+amIDS8HMduAzArbM1TcoUd6nPKwav958yTZSiB9gQpHG9
         eXKQ==
X-Gm-Message-State: ABuFfoj4v/HPvX574OZRE3NRoly2llRSnKC5CChUI8R4gqKpU21EKZuF
        1VkryYV7O//F9wQwZLDml0Fie3+Y4gPAcikX4pY=
X-Google-Smtp-Source: ACcGV635Hou7Mfhv+8ZezvwsMstuxB5hddyljbIhwKBIhwsD1iH1Y+U35DQbWFqH+nXwEX+9r2K35ucKQr19gYhEL1Q=
X-Received: by 2002:a37:a6d8:: with SMTP id p207-v6mr14908924qke.226.1538899772933;
 Sun, 07 Oct 2018 01:09:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com> <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
 <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com> <CAG__1a7Yc4eZ=YHsr8mZFCyu2ceW3CJDhgK0XDQK=wipVtQUxw@mail.gmail.com>
 <2122b08c-0fa9-b774-cbad-67b71f5084d4@gmx.com>
In-Reply-To: <2122b08c-0fa9-b774-cbad-67b71f5084d4@gmx.com>
From:   evan d <forumscollective@gmail.com>
Date:   Sun, 7 Oct 2018 10:09:21 +0200
Message-ID: <CAG__1a75dV6zVzMQFrnN-6u0iPXQRgvKebTkM1kxoiKgm3bcwg@mail.gmail.com>
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS filesystem
To:     quwenruo.btrfs@gmx.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> If first 128M doesn't hit, I highly doubt something more strange happened.

Not sure I follow, do you mean if it doesn't hit then it's likely
something else went wrong?


> I'm considering something like encryption.
> Maybe the disk is already encrypted by hardware?

The drives were never encrypted, none of my drives are


> Windows is just a black box, I have no idea what a Windows could do to a
> disk.
>
> But it doesn't explain why the 2nd super block can't be located, unless
> Windows is wipe more data than the first 128M.

I'm thinking Windows may have tried to convert them to Dynamic disk on
detecting them and assuming they're empty.

>
> If the disk is larger than 256G, would you please try to locate the last
> possible super at 256G?

They're both 6TB drives

>
> # dd if=/dev/sdb bs=1M of=last_chance.raw count=128 skip=256M
> # grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" last_chance.raw

dd returns:
dd: /dev/sdb: cannot skip: Invalid argument
