Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0AC0C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 05:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46FE420685
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 05:06:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="JjRH3EKf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46FE420685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbeJaOCx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 10:02:53 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:33389 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbeJaOCw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 10:02:52 -0400
Received: by mail-lf1-f41.google.com with SMTP id i26so6334128lfc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 22:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=99Zu9Mhquz6rsx8HjV3e3fsEXZbW1qZOS4d8BCPXgQ4=;
        b=JjRH3EKfYpFqj7ZRTAh/6jJbSMzjXTmA8hPhC/82UxpRbX3DB9ZoBmdARVYvCBHA8P
         wHml3Z861Ut+YNMvBmHgkxwYHbj8K65lWEAbGOgXs/GgGubEbVGCwQ2S/VDQkhKPSyG3
         Oc5yaGiJWN4jGS1QYM0shWa3Su0yb+qMo52cb50BNl//dd5yIwxDxYN9uvpJCEKzvjnz
         OY4oL+k/0delQJ9OIpC5psWAheaBKH5lljDTU8KI+6tREbbSGvb6e/CGrSPK4IClwZLn
         PO7xNS9O+QjTlkrad0Jl2hdxKHpTpdjKFQU9UNd7UZ6aroLMelhpWjbXz77DJBx1jQjH
         UCvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=99Zu9Mhquz6rsx8HjV3e3fsEXZbW1qZOS4d8BCPXgQ4=;
        b=JHOnc/RfhNLx5uDrkPak/A96xk/Ea3KireSDilp8c8H5GlFLeSQWioy3Ete4vqtqJZ
         KdPHbW06Bbzlqa5fMypMlpKEtJF9pXrG00l2clhWBBXof+QfiAGpZ5h+130X1z8ge2H+
         G4EKsR3h3AqkOiBjMjaWXmcdYDdfS5K1WlmWu8cPpNCeMY29Lwf0IwnoFB62Mi9UggGd
         ltPspXRTzDE9unVk49s8pl15QN89lVam/iYrAsALiPDhC+OnyY6MltnZq00acCIAKh7X
         atgFH0iIDv+sOVyyXk2/af+bLM9IRFnBFCf21j4jyrzY1AlFIN42l6UwWY8Wihf5ue95
         StUg==
X-Gm-Message-State: AGRZ1gJznJTllYwx6yGMfoSX4nzRFgtDM5zrqiutEzgryAitJLdUa3YM
        VvmkmCpokvjp35v5LSvOFaFJ7Xw7toqGGbS5/1qHlA==
X-Google-Smtp-Source: AJdET5eBX1YJ1JbTAEdSjyV5gHpISinGLOxn1uHe9d+POfLac0w4PxRDH3uuSDKTKR5vEYP87+b76ev4cLigPLVII4U=
X-Received: by 2002:a19:f89:: with SMTP id 9mr809529lfp.10.1540962381971; Tue,
 30 Oct 2018 22:06:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:4f11:0:0:0:0:0 with HTTP; Tue, 30 Oct 2018 22:06:21
 -0700 (PDT)
X-Originating-IP: [192.240.97.84]
In-Reply-To: <CAJzMQG2mAfux8+ij9KqeOfmfN0b-_6kHzh3dwoofYExNk0KiAw@mail.gmail.com>
References: <CAJzMQG2xPu7vy60qDjip+u93=3GU0v_ZXE9h8t_Tj1Vf6f5EnA@mail.gmail.com>
 <CAJCQCtTTBOdK5Z=7SDb8W+q7Px+kyLb6hAo06piw=zxDYtrSgA@mail.gmail.com> <CAJzMQG2mAfux8+ij9KqeOfmfN0b-_6kHzh3dwoofYExNk0KiAw@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 31 Oct 2018 01:06:21 -0400
X-Google-Sender-Auth: cYVmG1mw1fG5BqzPdzBWQ2HdpR0
Message-ID: <CAJCQCtSFnGz+M+xRNzajwdqFbhcAQtLAf8aAqB1xXcbvEd9j7g@mail.gmail.com>
Subject: Re: Where is my disk space ?
To:     Barbet Alain <alian123soleil@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 30, 2018 at 4:44 PM, Barbet Alain <alian123soleil@gmail.com> wrote:
> Thanks for answer !
> alian@alian:~>  sudo btrfs sub list -ta /
> [sudo] Mot de passe de root :
> ID      gen     top level       path
> --      ---     ---------       ----
> 257     79379   5               <FS_TREE>/@
> 258     79386   257             @/var
> 259     79000   257             @/usr/local
> 260     79376   257             @/tmp
> 261     79001   257             @/srv
> 262     79062   257             @/root
> 263     79001   257             @/opt
> 264     78898   257             @/boot/grub2/x86_64-efi
> 265     78933   257             @/boot/grub2/i386-pc
>
> Yes it's opensuse, but I don't see any snapper config enable.
> For memory, I use docker that full my disk, I remove subvolume, but
> it's look like something is missing somewhere.

Try

mount -o subvolid=5 <dev> /mnt
cd /mnt
btrfs fi du -s *

Maybe that will help reveal where it's hiding. It's possible btrfs fi
du does not cross bind mounts. I know the Total column does include
amounts in nested subvolumes.



-- 
Chris Murphy
