Return-Path: <SRS0=mVxD=RJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07323C43381
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 18:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCD0F20652
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 18:00:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PhjdKZMo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730600AbfCFR77 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Mar 2019 12:59:59 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44707 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728944AbfCFR76 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Mar 2019 12:59:58 -0500
Received: by mail-qt1-f194.google.com with SMTP id d2so13832268qti.11
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Mar 2019 09:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LiihgEvbWQ8MT5wVsYlfcxwrVSH2+uk+gQFhbWrEIyc=;
        b=PhjdKZMoTa+F1gpTN9WOA4Ib2hEwdo3MTcVY3RLNnQqxiSZPr7TuPTnR2YIUn4k16l
         2gixKwNyrsA/wvAqaJ/GQToFo849FZZyN1cVc61nAwjVCmpAq7VwmnFA9y+7BD/pQZD7
         dnf737wZsBzTKVR6GloWwfCxdMYDupfSTijZ2YYXDVlCt+YwIYzMFZf855qNj/btjB+z
         1ELi6V1JuyjCNHLiNGH2ksbr76a7YX43cRLpVezvDK1SdxeV0ifGULPY0/bLYPGMJLf2
         MZ8pbv9Vlt0wTRa+Z5B4vg5fJSwyNptHGRxMZ1X1Wa1e2moLoH3beWhHxWaK3NuogOm7
         zusw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LiihgEvbWQ8MT5wVsYlfcxwrVSH2+uk+gQFhbWrEIyc=;
        b=F0FcBEaSAxn6FF3iRnEYCXpln1gI5xJXKG9Y+of82btUjb5hX6b+jSoQbFjZ9Mbg4c
         ojz5boS75qSjhjBZJJPNkxrGYOS80stYM9Jb83xqYbb7LrXK4MEBzPK2ejVYGMxky4NY
         JZRU/BXiRu5tFAIES6dGHoIZ8hkBARpEgMh1MIJLZ3PhslxehwF1bQZK0RGNKkb4ytX4
         JN9PMe8UCAqH9Qv7CHowFvAg9yFECK7ZFa+E9rAJ6JVRRBm0IOu7NZpvYoZInhBJunio
         3T4iAcT2HsEzRSpOj7X11qyQXLJBz4RO1jSTXwqKZxsLBQjFr++wTcOxaL4n5Jf1nmYY
         5bVw==
X-Gm-Message-State: APjAAAUSikSGqUD0j/2hJ331ArXSdjNZ/lXeCehvWIJA5i73CF9bRIDD
        9BVZzm9lJ8zHGNJ8nbHlGDl9jW2avr3MXJrcqY8VNLai
X-Google-Smtp-Source: APXvYqwrbkqdBEDifFNN/AVQUiaQLfubvp1nIq8SGqaMIaSPtSznmsqH3Pyt7VnxJRjm0/v5kIUtmpByMmemnNGDncA=
X-Received: by 2002:a0c:88db:: with SMTP id 27mr7243667qvo.41.1551895198237;
 Wed, 06 Mar 2019 09:59:58 -0800 (PST)
MIME-Version: 1.0
References: <3ac57b0b1d8a4060b7411b4b3db5c52f@nevion.com>
In-Reply-To: <3ac57b0b1d8a4060b7411b4b3db5c52f@nevion.com>
From:   Patrik Lundquist <patrik.lundquist@gmail.com>
Date:   Wed, 6 Mar 2019 18:59:46 +0100
Message-ID: <CAA7pwKOhQc97ea1gpLqetBmsK=1kGYp4H7T700gBU4UK1OFOSw@mail.gmail.com>
Subject: Re: btrfs filesystem failing with 'No space left on device' after 4 hours
To:     Michael Firth <MFirth@nevion.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 6 Mar 2019 at 16:53, Michael Firth <MFirth@nevion.com> wrote:
>
> Is there any way to get more debugging from what is going on?

Try mounting with enospc_debug.

> The system is running stock Debian 9 (Stretch). It was running their late=
st 4.9 kernel (Rev 4.9.144-3.1) when the problem first occurred. After two =
instances of the problem, I rolled back to their previous kernel (Rev 4.9.1=
30-2), which the system had been running error free for several months, but=
 the failures have continued.
>

4.9 is pretty old for Btrfs. I'd use the backported kernel which
currently is 4.19.
