Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D6CC2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 18:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFC132080A
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 18:01:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="wmoaRXx8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFC132080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbeJaC4K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 22:56:10 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:32931 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbeJaC4K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 22:56:10 -0400
Received: by mail-lf1-f42.google.com with SMTP id i26so5288419lfc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 11:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=U5IZNVw0XRuJgWrpiDmENpGNaFVzsepZDD//fNUvza4=;
        b=wmoaRXx8FN0ZQRBffpiXCdWmpxiNujl7fBF5ktqUPG/VuF9z59CPtwOcWE/hR4juTi
         /Flk3l+hqxtsAV+8MaFkbvU/el8QM0qDRJMc5lr3jS75rnA/Fhv83PVo4/j8ih40yzCe
         WbxyGyB4ou3vjcgA5jAIpyeOgnkJ4CKTpEbglkc9U2YxTkNqL+YEeJSek4F9rTNd6kHq
         6OIxJW3bDQs6LpZoGq2ntCqkf472ELkOniXOSTTZZA94kH/YTaTk1CdeiT29C59nCEt4
         x+F64EpUK9i2jH0iVkePi1Bfd3zgluSLMeDYRINB7SpaD4UIlnO2kzQoRob6O0pWgD6o
         jThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=U5IZNVw0XRuJgWrpiDmENpGNaFVzsepZDD//fNUvza4=;
        b=RcXpXCe0rXkEBqxg+j6lGsig9+wSfv2dILwm8OcrOaNADzXk8impQqx/J3fox/SYU0
         NMqGof3wloQWnQ0+3g7nAlQbdkD/yfIdRbS7Aqd/iz332Dl7SZ3DnksOptwsH0LeEB/T
         hN5SknIQdAc+/reLlToscwR+GCFYgC1Fy3BS4gu1pJHoNg/zfQV3TGVUzPVJW9lr5SmC
         7FHhXrTVaiYJHBhgEx7UIuT/qCazaET6ZEGimGXARN9BRFLWoMtArYl0J4MzZNoZOoXs
         seAEPib/63QA4fOhCLGrttvnCUgYoZRIQq5VaS9qjbrAAvzv6T6D2cj6OUZQtrMeaeQX
         XiDQ==
X-Gm-Message-State: AGRZ1gJKJZDKd/FTmqmYhCH8lo/AJ/o0k5bxvmqKYsoSxIuTdwV8kmtT
        1LWT227QzbWU6sVOnKnXvhBDsotTQlbXaAy7y2eaLQ==
X-Google-Smtp-Source: AJdET5eY719StFxbQzJbbqOAV2tKdqP7VJceqgXD6cup1josPl6pm/hKQtSKzlKnnVJh2XB7Epi+l1Q7lwlIK1Mc9wU=
X-Received: by 2002:a19:e01e:: with SMTP id x30mr2484148lfg.89.1540922499438;
 Tue, 30 Oct 2018 11:01:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:4f11:0:0:0:0:0 with HTTP; Tue, 30 Oct 2018 11:01:38
 -0700 (PDT)
X-Originating-IP: [192.240.96.67]
In-Reply-To: <CAJzMQG2xPu7vy60qDjip+u93=3GU0v_ZXE9h8t_Tj1Vf6f5EnA@mail.gmail.com>
References: <CAJzMQG2xPu7vy60qDjip+u93=3GU0v_ZXE9h8t_Tj1Vf6f5EnA@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 30 Oct 2018 12:01:38 -0600
X-Google-Sender-Auth: 8sjM37HDflyjQxPjKrG2xH5C0Lw
Message-ID: <CAJCQCtTTBOdK5Z=7SDb8W+q7Px+kyLb6hAo06piw=zxDYtrSgA@mail.gmail.com>
Subject: Re: Where is my disk space ?
To:     Barbet Alain <alian123soleil@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 30, 2018 at 9:17 AM, Barbet Alain <alian123soleil@gmail.com> wrote:
> Hi,
> I experienced disk out of space issue:
> alian:~ # df -h
> Filesystem      Size  Used Avail Use% Mounted on
> devtmpfs        7.8G     0  7.8G   0% /dev
> tmpfs           7.8G   47M  7.8G   1% /dev/shm
> tmpfs           7.8G   18M  7.8G   1% /run
> tmpfs           7.8G     0  7.8G   0% /sys/fs/cgroup
> /dev/sda6        41G   35G  5.1G  88% /
> /dev/sda6        41G   35G  5.1G  88% /var
> /dev/sda6        41G   35G  5.1G  88% /root
> /dev/sda6        41G   35G  5.1G  88% /srv
> /dev/sda6        41G   35G  5.1G  88% /opt
> /dev/sda6        41G   35G  5.1G  88% /boot/grub2/i386-pc
> /dev/sda6        41G   35G  5.1G  88% /usr/local
> /dev/sda6        41G   35G  5.1G  88% /tmp
> /dev/sda6        41G   35G  5.1G  88% /boot/grub2/x86_64-efi
> /dev/sda7       424G  200G  225G  48% /home
>
>
> It say I use 35Go / 41. But I have only 5,8Go of data:
> alian:~ # btrfs fi du -s /
>      Total   Exclusive  Set shared  Filename
>    5.84GiB     5.84GiB       0.00B  /
> alian:/ # du -h --exclude ./home --max-depth=0
> 6.2G    .

I suspect there are snapshots taking up space that are no located in
the search path starting at /

What do you get for:

$ sudo btrfs sub list -ta /

Is this an openSUSE system? If snapper is enabled, you'll need to ask
it to delete some of the snapshots to free up space rather than doing
it with btrfs user space tools.




> alian:/ # btrfs fi df /
> Data, single: total=35.00GiB, used=34.18GiB
> System, DUP: total=32.00MiB, used=16.00KiB
> Metadata, DUP: total=384.00MiB, used=216.75MiB
> GlobalReserve, single: total=22.05MiB, used=0.00B
>
> I try to run btrfs balance multiple time with various parameters but
> it doesn't change anything nor trying btrf check in single user mode.
>
> Where is my 30 Go missing ?



-- 
Chris Murphy
