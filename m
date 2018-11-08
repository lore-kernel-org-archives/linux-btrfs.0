Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE3FC46465
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 09:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECE1620825
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 09:27:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fiXltfW1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECE1620825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbeKHTB4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 14:01:56 -0500
Received: from mail-qk1-f178.google.com ([209.85.222.178]:46467 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbeKHTB4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2018 14:01:56 -0500
Received: by mail-qk1-f178.google.com with SMTP id q1so25245184qkf.13
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Nov 2018 01:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=caN0sZG/4a6XxrjR0bHBQPOUNXbnOPEUS8OIc6zVMKI=;
        b=fiXltfW1SCMmGO4Naz3+NCVRq7ZkShl/ddWjddamZTbsZwz3oW27h/CumRSYdlU42J
         F3enPOF+jNA/90u7HwGPhrD1Jlfusm79hF7/xjXlGU1ZcGC/e+t4Dh5SBnHpaRdzYA0y
         Pm8q/lD9CXKU1YmzJSJpKLHLo9Q4pe04NVrBFRWM2qFWDMCJ5EmC3pY8LlTXfjJUZqNN
         2XjcfHW/Yv0cii1vCtgFgD/LReyn2DsdGXyL6EqqgvZT7om/28jMO0zCcfXPv6arvbdC
         LvWD+0PD0Qc/whUYf5JARrtemOQbaHobCWf83/oM+oApTUkcV6kLF3HayMh100SWl/77
         OzOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=caN0sZG/4a6XxrjR0bHBQPOUNXbnOPEUS8OIc6zVMKI=;
        b=UIY9Pf4XZ/lYXm4w4f37sDH5OfVWehjpZCu5Um77jdcIpR9nr8CQdwCz0wdk5JvB17
         RHZO/QIYllkybGmsdotM9LpKjR30Y4mDCbhnaVya8Y2idt6+KtyoKALycBYFLPPsnf72
         sb7WylRebaAo12A+w/bsGTw2j31EXmFpN1y2DOvDh0IWKn848uxyqXbNTbF+7zZEkgQN
         QTL6hNFL4rFtSz/e8uWxDsWnQ9qKl620wKaW6L0/GL6ERNMi20MFBYldDnK6gnIy3dyi
         Mzm2ySf7tV2DacArMTRG4becnTMY1YH6PPL2KX82Z0MeGO3v+vO5Q10HmtyVDLqD7BqO
         cqMw==
X-Gm-Message-State: AGRZ1gIG0SN8MM7vkAw4wV08l2BdgVUEx/fV11Z1aArFcefvWQsu28jb
        WdFbsY/QRHanh8ud0zo6hKq6E1IrbjXqLEPZmqJXnA==
X-Google-Smtp-Source: AJdET5cYzf+XiN8HzuNKGgOYEeisMjLHopPAOYvTsid7DGfBuaVkpf18cg8zG67hS1Em6G15R9pvCpjFB6mTblbQZh8=
X-Received: by 2002:a37:93c3:: with SMTP id v186-v6mr3437438qkd.186.1541669238055;
 Thu, 08 Nov 2018 01:27:18 -0800 (PST)
MIME-Version: 1.0
References: <CAJzMQG2xPu7vy60qDjip+u93=3GU0v_ZXE9h8t_Tj1Vf6f5EnA@mail.gmail.com>
 <CAJCQCtTTBOdK5Z=7SDb8W+q7Px+kyLb6hAo06piw=zxDYtrSgA@mail.gmail.com>
 <CAJzMQG2mAfux8+ij9KqeOfmfN0b-_6kHzh3dwoofYExNk0KiAw@mail.gmail.com>
 <CAJCQCtSFnGz+M+xRNzajwdqFbhcAQtLAf8aAqB1xXcbvEd9j7g@mail.gmail.com>
 <CAJCQCtQiqUVNin9Ga7HB8oUrgwQ9h9V+etZLooqX3_Sb_KNz0Q@mail.gmail.com> <CAJzMQG1-cv6iNzw4jAv8QALo7Z2maapsyzPJOwALZks-=7HvFg@mail.gmail.com>
In-Reply-To: <CAJzMQG1-cv6iNzw4jAv8QALo7Z2maapsyzPJOwALZks-=7HvFg@mail.gmail.com>
From:   Barbet Alain <alian123soleil@gmail.com>
Date:   Thu, 8 Nov 2018 10:27:06 +0100
Message-ID: <CAJzMQG3Ln50NiPLAE6tME8gXraKcKUJjTa9=LGGweRrcnDtyLg@mail.gmail.com>
Subject: Re: Where is my disk space ?
To:     lists@colorremedies.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi !
Just to give you end of the story:
I move my /var/lib/docker to my home (other partition), and my space
come back ...
I let docker here & don't try to put it again on / to see if problem come b=
ack.
Le mer. 31 oct. 2018 =C3=A0 08:34, Barbet Alain <alian123soleil@gmail.com> =
a =C3=A9crit :
>
> > Also, since you don't have any snapshots, you could also find this
> > conventionally:
> >
> > # du -sh /*
>
>
> Usually yes, but here not. It's just like when you remove a file when
> a process still use it and write in it, and fcsk will be not happy
> next time.
> But I reboot & check with btrfs check withtout any issue :-/
>
> alian@alian:/> sudo btrfs fi du -s *
>      Total   Exclusive  Set shared  Filename
>    1.58MiB     1.58MiB       0.00B  bin
>   42.69MiB    42.69MiB       0.00B  boot
>   14.78MiB    14.78MiB       0.00B  etc
>  532.40MiB   532.40MiB       0.00B  lib
>    9.88MiB     9.88MiB       0.00B  lib64
>      0.00B       0.00B       0.00B  mnt
>   23.96MiB    23.96MiB       0.00B  opt
>  128.00KiB   128.00KiB       0.00B  root
>    9.74MiB     9.74MiB       0.00B  sbin
>      0.00B       0.00B       0.00B  selinux
>      0.00B       0.00B       0.00B  srv
>   15.92MiB    15.92MiB       0.00B  tmp
>    4.86GiB     4.86GiB       0.00B  usr
>  345.65MiB   345.65MiB       0.00B  var
>
> alian@alian:~> sudo du --exclude /home -sh /*
> 2,1M    /bin
> 43M     /boot
> 0       /dev
> 20M     /etc
> 534M    /lib
> 11M     /lib64
> 0       /mnt
> 24M     /opt
> 0       /proc
> 172K    /root
> 18M     /run
> 11M     /sbin
> 0       /selinux
> 0       /srv
> 0       /sys
> 16M     /tmp
> 5,2G    /usr
> 355M    /var
