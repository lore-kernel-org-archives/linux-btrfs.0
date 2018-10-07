Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D00C00449
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 12:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C80E42087D
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 12:26:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pDwBRivl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C80E42087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbeJGTdL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 15:33:11 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]:41306 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbeJGTdL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2018 15:33:11 -0400
Received: by mail-qt1-f182.google.com with SMTP id l41-v6so5810920qtl.8
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Oct 2018 05:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FO2fTDNpZfUDbBwVhVHfBER5fwikLrdvAY4azUYGezU=;
        b=pDwBRivlzsYEk5H6WIt+g6GMgh+GZYT3EUTWNWzlSoi9TgzXT73H0zKP1tkp8x73xZ
         0yoFqOxb8+CXw5WRUwtCd8fDfI/mnx6JS2POZ+oRBM+i4z1AjBjXGn9dc229pm1arfxg
         GYcmTi34cioFxUONMfQB0u2DznD9a4jCVStDDkvZOy2TlbhVngitQoKqdZK/F6BsvCwd
         hRJvH1J5FbyZTq86pfauoYo6IRTTmgxUthrp55/Wtd6m7HzjdQsbL8Vxq93Kk9zWPbWK
         0MbGlpcTaQrEz1aJW3zfagI/fiP8RL+N6C1IkZhAg/Ag/ZPuIT5W5XYLL0OP5cAYrBDZ
         j3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FO2fTDNpZfUDbBwVhVHfBER5fwikLrdvAY4azUYGezU=;
        b=M7/+yy0TACeUf3jEDf6FS1CPwQV00F5FMi+aSsMAVO015vHvZi2FzhzYT/quOMP0yN
         U7x6DYCxxinTMK6Bps9pN5zymzsYaQquQivj693L9e/RW2jmfkI/73G9XiJKLE4Fxktv
         hARSn3oPU8ZTFopUNZ0RrELkFb/rpKdf8VyvBmivxcGmdqR5xJEnbobGLw/Zu38stBf6
         myoQpxmh7/jcTURZL8F08JesXrzUQp9MdfK0s3IBtlKvzixLsLwx0vO7xAyNjWbNzEAD
         5BSePu0aa3Cls4C8n4rxGV9jKER8cHjpZ3bBQAFn4/eOk9ufL6QkJ8HuqDlZjYI+zINf
         phvg==
X-Gm-Message-State: ABuFfohpGaZ7/oL+UdDJMPVag98IviyrvMOoyTegK+Os5hzhT3lQHPHW
        8PTiVI2Lcc0qhNFH4fbDmMaxDZp3YWZVJWL33VU=
X-Google-Smtp-Source: ACcGV63fob6JNkcnW5TEW8HfdS/K16BRoabpaDX5csshe1Vvrhj+CA6ZRcVPjC3f4JJ9vnnuPGYugtMVcADIvFJnBTw=
X-Received: by 2002:ac8:190e:: with SMTP id t14-v6mr15665550qtj.327.1538915165702;
 Sun, 07 Oct 2018 05:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com> <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
 <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com> <CAG__1a7Yc4eZ=YHsr8mZFCyu2ceW3CJDhgK0XDQK=wipVtQUxw@mail.gmail.com>
 <2122b08c-0fa9-b774-cbad-67b71f5084d4@gmx.com> <CAG__1a75dV6zVzMQFrnN-6u0iPXQRgvKebTkM1kxoiKgm3bcwg@mail.gmail.com>
 <14c82713-72c8-a243-293b-5c482031f70a@gmx.com> <CAG__1a4_jPWJ2LcBQ2ubWeuXR3AWa4vS7vrV3Ysm-wFORddH7g@mail.gmail.com>
 <7ffc25c7-1442-99da-8600-add6b3ce2dd4@gmx.com> <CAG__1a63yUA3N4N2HjsTS7ng3tkxei6Vpo3QdckPu1CDLyv0yg@mail.gmail.com>
 <8968c012-7732-2338-c505-2027539cbe56@gmx.com>
In-Reply-To: <8968c012-7732-2338-c505-2027539cbe56@gmx.com>
From:   evan d <forumscollective@gmail.com>
Date:   Sun, 7 Oct 2018 14:25:54 +0200
Message-ID: <CAG__1a7yz1iX7+M7ybGNVHLiZehactYiiJ6EbnA57RDzzx=V2Q@mail.gmail.com>
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS filesystem
To:     quwenruo.btrfs@gmx.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> > I may as well use wipefs to clear crud from both drives, partition and
> > format them and then use them elsewhere.   -- this more or less
> > accurately summarise the situation?
>
> Unfortunately, yes.


I recall the machine these drives were in lost the onboard NIC when
the desktop switch it was connected to went up in smoke.  Perhaps it
was at that point the corruption occurred, albeit I seem to recall
checking the drives at the time.  Such is life.  If they pass extended
SMART tests they'll go back into use.
