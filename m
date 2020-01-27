Return-Path: <SRS0=pm4w=3Q=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAA4C2D0DB
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Jan 2020 21:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A7A022527
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Jan 2020 21:48:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="BI5QlFlm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgA0Vsv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 Jan 2020 16:48:51 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:51808 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgA0Vsv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Jan 2020 16:48:51 -0500
Received: by mail-wm1-f42.google.com with SMTP id t23so229513wmi.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2020 13:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XQuF04xMP+jcaOkSBvM2f87r2qSO1vtrS5Bc6ZcrRBw=;
        b=BI5QlFlm4PPMpXkVRgqHjVzBwZyRTTJTvY1zVddK4ZA+OeF1erU0cGSN6cKe2WyYiz
         V7qokS+s2yGLTPGocIfXvV1Nek94bVqtRnewAnU4mi+j3ssttyv3rLjRmbl24vyHnN/w
         svYDwfm4SlP3wub+NJ05hpzaV4v7b02KbLtJXiDPtbkHnBexOW78nEbGxmlypqMKNKzV
         RukxEYRH08RP63a5q5DS78Q7MnMxLBp3VkvbsiOiuVh77zGPcktYbWUQnyGHQFoyKLLi
         EcIoMHwtjLO8ACrIul+22VHZ8oNJKtqjxZkxhbb8eA8mbOqouP5BFgBt10tRxZyQJ6Sr
         BYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XQuF04xMP+jcaOkSBvM2f87r2qSO1vtrS5Bc6ZcrRBw=;
        b=hjv01zwzjAFagabIhDOjKsGxgskyrxZXm2oUu17xiLbcYbkBytzR0U5A+8BhEFh1cJ
         tP4lo4t79Ijg5cnUs5AQ4xgKeZV0ZJUVSLG7UPYJuNBXuWxH7whTtiBTZgiZsvtwuZ19
         VkXUKeXnH2oCpCX0GWQgJeKKkF4OoBqyUAVMNzbuzYJIxoW5jAVVf62LaKgRiczBZqki
         BFrcahOYf5uWTDR8UDFaNiiZ9nmv9X7ENjb/W5KdWdUhXIW4cUlohDjsnXXtDYsRumEg
         ZRia8DDp1LTRRaGysbfhFIRZj018mg56hEhHpMKs+q1odP1CsBaEvOjEI+evFU1XpopI
         elEw==
X-Gm-Message-State: APjAAAXQ/BZyAbyvgrBvgqVdbQ5cwt1tQDawr0KXllxPNtKsWuAMvogv
        yKxGphIjWDg3ogxyu5KfBXYfNRxTJaelyvFNC9uq9g==
X-Google-Smtp-Source: APXvYqyz2pOq6EDj3wmvESWUeof4hz5B33sfcKGMFTVaR32ij9tzLNFKFlMArt7iOlmn8U8pZc17klV1S6EZZgGLxDI=
X-Received: by 2002:a7b:c147:: with SMTP id z7mr698827wmi.168.1580161729220;
 Mon, 27 Jan 2020 13:48:49 -0800 (PST)
MIME-Version: 1.0
References: <c541f131-c60b-4957-0f86-3039da69f788@gmail.com>
In-Reply-To: <c541f131-c60b-4957-0f86-3039da69f788@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 27 Jan 2020 14:48:33 -0700
Message-ID: <CAJCQCtShdXA2SRkHvfRAS8EVLRRzCmJ3HA-Ynk=uOEc+9XD7iQ@mail.gmail.com>
Subject: Re: Endless mount and backpointer mismatch
To:     Pepie 34 <pepie34@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 27, 2020 at 2:20 PM Pepie 34 <pepie34@gmail.com> wrote:
>
> Dear BTRFS community,
>
> I've a raid 1 setup on two luks encrypted drives for 4 years that serves
> me as btrbk backup target from an other computer.
> There is a lot of ro snaptshots on it.
>
> I've mistakenly launched a balance on it which was extremely slow and
> tried to cancelled it.
> After two days of cancelling without results, I decided to power off the
> computer.
>
> After the reboot, even with the skip_balance mount option, the mounting
> is endless, no error in the kernel message and it never mounts.
>
> What I have done so far:
> - mount the volume with the ro option (fast to mount, data OK).
> - scrub in ro mode, no error found
> - btrfs check
> In the extent check  there is plenty of errors like this :
> =>
> ref mismatch on [9404816285696 32768] extent item 6, found 5
>
> incorrect local backref count on 9404816285696 parent 5712684302336
> owner 0 offset 0 found 0 wanted 1 back 0x55f371ee1ad0
> backref disk bytenr does not match extent record, bytenr=9404816285696,
> ref bytenr=0
> backpointer mismatch on [9404816285696 32768]
> <=
> No errors in other checks, though checking "quota groups" is very slow.
>
> What should I do ? btrfs check --repair ?
> btrfs check --init-extent-tree ?
> btrfs --clear-space-cache ?

None of the above.

What kernel version and btrfs-progs? Newer kernels should have better
performance with quota enabled and many snapshots, even though I think
that combination is still not advised for performance reasons. Older
kernel might have a known bug related to the behavior you're
experiencing, but we need to know the versions.



-- 
Chris Murphy
