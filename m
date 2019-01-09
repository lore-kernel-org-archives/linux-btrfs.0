Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CD1C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 20:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7530206B7
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 20:47:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q03YBpza"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfAIUrr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Jan 2019 15:47:47 -0500
Received: from mail-lj1-f176.google.com ([209.85.208.176]:45437 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfAIUrr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2019 15:47:47 -0500
Received: by mail-lj1-f176.google.com with SMTP id s5-v6so7667947ljd.12
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Jan 2019 12:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3KH3vKox76gpRpeH65Va2/5fcmNWw4okxKpMTTmuLRw=;
        b=Q03YBpzap4OWTV3thMJsGGMDk+tmykV1+cjpYfGx74sBCKgQ5d8qNqZfmzHVBz2yL8
         bIZhuNkaByJWX1OAhKjM0yCCnIV+pFQtOxb3aeyIuK7kf8t9BHxU/cuXycIqhkQh3/LN
         LToqUnRy3+gC2wk+R7k9MveAMxOixwKbo0clQW01yzYv1F5A3sjbnu3fRIezX+3TeimK
         tK/RSyXKj1CDclJal2Ei8vOEI1jbAQf1gjcXN0LJv7XVud2s27n/SRzkixiLa/qV7eak
         QQuGRLZwVi8t9gnonyX/99K/n3u+YwaQHr871cOqX93V7yhzyFbgOs6gH2UT2xQuEIfO
         fqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3KH3vKox76gpRpeH65Va2/5fcmNWw4okxKpMTTmuLRw=;
        b=taz7FQCrYiC4SJpoflephIJlpzW3hC+jfxeAS7mXUbZZFM5EbJn9Gb8hZWu2I0Urqn
         SZJgVOpt5BY5UwxwE8Fv19r9aGpS6U4fyoQQdbPWfVm/KIC2CSEJDQUh9qu1R+NZjF8U
         Pt1qA0M+NOptW+YxXFyCo+yNbs6lwr3xCYlljVuEfGY2vtj6840FpIUdkRAu5pbbUww2
         3wbR0F+hISh35DTmTFn/VLSsHZP8CGFdLBX7tTFK86BvZE8K/M+2tS6R4l1ZC1h6k7zt
         58AsdveSC1ChARwUuV4+h46HcOb5ZSatLflN8BH6GqUXk29TeJoGl/63EZ30VZheUdgE
         Ug6Q==
X-Gm-Message-State: AJcUukf+UhapjA/m6borSN2TwWQ6bsVMEbHY7Vvcgn8K2R3Ezv7q9tNz
        rZc/M65QjpZgnfGaFizYPjil1TxOcwSigMELoyttTV3AR9M=
X-Google-Smtp-Source: ALg8bN79eAx8GEe/3263cgXT9WoOT/3L5Yoe1EwY15Yfx/Lx7xCCQZ2imZ2F2Shj0Rgf7ums0SjBbC8be2zxdMLTHMI=
X-Received: by 2002:a2e:1603:: with SMTP id w3-v6mr4350178ljd.33.1547066865388;
 Wed, 09 Jan 2019 12:47:45 -0800 (PST)
MIME-Version: 1.0
References: <cbffc26e-a57f-e1ad-284c-a54431c4e2f1@gmail.com> <64cf0762-bd59-3d77-8aca-94622233767f@gmail.com>
In-Reply-To: <64cf0762-bd59-3d77-8aca-94622233767f@gmail.com>
From:   Peter Becker <floyd.net@gmail.com>
Date:   Wed, 9 Jan 2019 21:47:34 +0100
Message-ID: <CAEtw4r1we4ctoTwvExFWwc1WFgtBJXYXOizNZrrzqyBGbHCv-A@mail.gmail.com>
Subject: Re: Balance of Raid1 pool, does not balance properly.
To:     Karsten Vinding <karstenvinding@gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

if, before the first balance run, many blocks were filled only in
parts, a behavior like this can be happen, because btrfs aggregate the
used space in a new block.
a second full balance run, should solve this.

you didn't need to move data away. btrfs only need a few GB of
unalloceted space for balancing. (see the output of "btrfs fi us
/mnt")

In generell i prefer a small balance-script like:

btrfs balance start -musage=50 -dusage=50 /mnt
btrfs balance start -musage=90 -dusage=90 /mnt
btrfs balance start /mnt

this aggregate all blocks that are filled to less than 50%, the the
same with blocks that are filled to less than 90%.
the last line will do a full rebalance if you real need. (this moves ALL blocks)

Am Mi., 9. Jan. 2019 um 18:23 Uhr schrieb Karsten Vinding
<karstenvinding@gmail.com>:
>
> Just a short answer.
>
> I didn't use the replace command.
>
> I added the new drive to the pool / array, and checked that it was
> registered.
> Following that I removed the 1TB drive with "btrfs device delete <drive>".
>
> As far as I know this should avoid the need to resize the new drive.
>
> "btrfs fi us" shows all the space as available. The drive shows 1.7TB as
> unallocated.
>
> I have started moving some data of the array to give btrfs some more
> room to move, and will follow what happens when I try a new balance
> later on.
