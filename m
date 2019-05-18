Return-Path: <SRS0=2HRi=TS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21DA0C04E87
	for <linux-btrfs@archiver.kernel.org>; Sat, 18 May 2019 04:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDB4D20882
	for <linux-btrfs@archiver.kernel.org>; Sat, 18 May 2019 04:14:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="zA2yMW/+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbfEREJ0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 18 May 2019 00:09:26 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:41002 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfEREJZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 May 2019 00:09:25 -0400
Received: by mail-lj1-f178.google.com with SMTP id k8so7938689lja.8
        for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2019 21:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rhTm4DukoVSVojlued0l0dJrdDC4VocEvkMWVztjvWE=;
        b=zA2yMW/+Icx2lrLg2juqbNLi+Ga9rZXhczJ1KsxypvOzRdbGDeLIivieyhKRGkZywn
         kJscEfOBaYFJaUAW/9+01r25EG+u0HUuaNk5rLlYG3CrL9Xsr+5dqj4Soxsa8Kbus3Q7
         WAwDyfICtwKjMig8zwITfSLi7LMlRoBiyyoH09ZwTuAyGiGQ9TbnU6ogENQPj+lj3RP/
         MHtDJXFnGruHMqkkIPRA5VOeQ0R6fY7J1M0xx6o7RILvrBIV/BFcFv7pHVUNxPLypDBw
         tq2/UedSFhWNj6KXOqjJDdaSe4aqBr4qteHTghepBi8wObvORlfPyyYDPkpLmXP91EiN
         gWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rhTm4DukoVSVojlued0l0dJrdDC4VocEvkMWVztjvWE=;
        b=ke3en1tcCpO0fHZ5/0H+Ueitzwll6Tx9CFxJBw1+nN5Erhpp2lJYSUVGLxq904/Q4P
         qhMczAE08VTrSgYnYPT3Mdh9E7VDvtOzw06eBI89car2ZTW9YhYJPBvomFn373xIZ1pu
         xhwUnOVoRI1VrCPbXtzuvMvHFnvOCFvDBYdULITfC3KHsJSClEsFFGwWq1mM+aWIgyP1
         qxWfnKKUxLM22nP/jOt+OUKprp76jXbBy8HgXBd5tAlq2OHpvI3SQKgPyLhvTMYykXl9
         EX3snXbnC4KAHLyN6xZOlcjd7RijmOLOaXkFwlq591A5IVG2FtLKAy/KeYj75JZanAlh
         HVwA==
X-Gm-Message-State: APjAAAU/GA+G4sYGu03R6nm4MusQ4WlEXea3AaApcZvIAIctOSfocnrR
        ragyqVR2+ojFoTI54RMq7soGzh7T9nWMBHJaNhcBv5e3wyE=
X-Google-Smtp-Source: APXvYqyExhH76sEfqkjs4Vx9UJBPBrxg1chjSFmnqsO42icKTeKKQhpMy3btI15BsaGdN8oyBt8SRINuaDbJKjJxp0I=
X-Received: by 2002:a2e:93c7:: with SMTP id p7mr17991311ljh.32.1558152563761;
 Fri, 17 May 2019 21:09:23 -0700 (PDT)
MIME-Version: 1.0
References: <297da4cbe20235080205719805b08810@bi-co.net> <CAJCQCtR-uo9fgs66pBMEoYX_xAye=O-L8kiMwyAdFjPS5T4+CA@mail.gmail.com>
 <8C31D41C-9608-4A65-B543-8ABCC0B907A0@bi-co.net>
In-Reply-To: <8C31D41C-9608-4A65-B543-8ABCC0B907A0@bi-co.net>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 17 May 2019 22:09:12 -0600
Message-ID: <CAJCQCtTZWXUgUDh8vn0BFeEbAdKToDSVYYw4Q0bt0rECQr9nxQ@mail.gmail.com>
Subject: Re: Massive filesystem corruption after balance + fstrim on Linux 5.1.2
To:     =?UTF-8?B?TWljaGFlbCBMYcOf?= <bevan@bi-co.net>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, May 17, 2019 at 11:37 AM Michael La=C3=9F <bevan@bi-co.net> wrote:
>
>
> I tried to reproduce this issue: I recreated the btrfs file system, set u=
p a minimal system and issued fstrim again. It printed the following error =
message:
>
> fstrim: /: FITRIM ioctl failed: Input/output error

Huh. Any kernel message at the same time? I would expect any fstrim
user space error message to also have a kernel message. Any i/o error
suggests some kind of storage stack failure - which could be hardware
or software, you can't know without seeing the kernel messages.

--=20
Chris Murphy
