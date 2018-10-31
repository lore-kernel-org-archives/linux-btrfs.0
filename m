Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B9CBC0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 07:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1559320840
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 07:34:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b4LqVDtx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1559320840
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbeJaQbw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 12:31:52 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:46780 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbeJaQbw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 12:31:52 -0400
Received: by mail-qt1-f170.google.com with SMTP id c16-v6so16561894qtj.13
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2018 00:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pTjN1vwrglTwiOdjzAnn3CE2yXqN5y1hmJrFgWdbK8U=;
        b=b4LqVDtxqOv7SS9TrM6OFkNB0YAchV5fuuIfyHB9edhEPSpVWi6GK51jiYgDHr9GPw
         CLOiKdoDUAMy05y8Zuj3j47LRug8i3qdErFe72oZQEk3RzhO5GMzez7UV6MfJSGEulUJ
         K/4Mk3EUunVOk4YXEcfa3HkJ9wL1d760x6sZ2Hq4iqRwozG2iTPd9uG3aaDsVv+FTWiu
         YrHFRm/JINHT3pFdY3pbcwI73sO6kM3FzYcfKHHj4nYhbL2VnV6p7oti3w/8Tuz45Ao6
         SJc7NrRyFcCvdwsHRUUHH1Z5ZQi8IHrUsxm7NuPTYNKqmq+LzDpMI3WGm3EJtUf8YkXu
         ObtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pTjN1vwrglTwiOdjzAnn3CE2yXqN5y1hmJrFgWdbK8U=;
        b=ODsAURefU9epNLr/mh5O0QC9yYX9U+wgpIYMLRIdEUKJaR8ndftRO2Fi5OIXcOxwqf
         829hpu1U8cd0K9tyjbKJhDDQH3oo/pn4PzaCE/fw4lH1p8UaWJfqlXrD/AdMTMOKa8kP
         4Ilvj3uXCtyvwZBd154XTyyZ9ZO+ba63dFOHhzRE2S0s+RfqmyxxAO7iRpaDsKMNzTkJ
         cenM73PHl02Zd6hS87gn4N6Kf3LtuuQW4eaJCxaJY50EQRGW3xmUZePxvCeYiCF9+pON
         m66zG9dOBVpaHXmvI0YODGIqFg1CftJGBVsWCgJGWKpy+HXhT+pW8TrIaPjAH5oqvV1h
         3V2g==
X-Gm-Message-State: AGRZ1gI3wkhXhdO0+NKRFgulZc4hCpVoVWDkUPw2Sd/BpbkBdQyj3vSc
        g14BvTtuhJagZZIm8+VwTTA5UzP/1lnkH46ucG/lvLeS
X-Google-Smtp-Source: AJdET5f562KqulNgX4vLOJKEgR5M7wmOvuK4d6kenbRrUjngC8iGfYWUpxdOb4Mx4qsCemabz5RvSliXGKchgR3LG7Y=
X-Received: by 2002:ac8:1207:: with SMTP id x7-v6mr1630752qti.317.1540971294853;
 Wed, 31 Oct 2018 00:34:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAJzMQG2xPu7vy60qDjip+u93=3GU0v_ZXE9h8t_Tj1Vf6f5EnA@mail.gmail.com>
 <CAJCQCtTTBOdK5Z=7SDb8W+q7Px+kyLb6hAo06piw=zxDYtrSgA@mail.gmail.com>
 <CAJzMQG2mAfux8+ij9KqeOfmfN0b-_6kHzh3dwoofYExNk0KiAw@mail.gmail.com>
 <CAJCQCtSFnGz+M+xRNzajwdqFbhcAQtLAf8aAqB1xXcbvEd9j7g@mail.gmail.com> <CAJCQCtQiqUVNin9Ga7HB8oUrgwQ9h9V+etZLooqX3_Sb_KNz0Q@mail.gmail.com>
In-Reply-To: <CAJCQCtQiqUVNin9Ga7HB8oUrgwQ9h9V+etZLooqX3_Sb_KNz0Q@mail.gmail.com>
From:   Barbet Alain <alian123soleil@gmail.com>
Date:   Wed, 31 Oct 2018 08:34:39 +0100
Message-ID: <CAJzMQG1-cv6iNzw4jAv8QALo7Z2maapsyzPJOwALZks-=7HvFg@mail.gmail.com>
Subject: Re: Where is my disk space ?
To:     lists@colorremedies.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> Also, since you don't have any snapshots, you could also find this
> conventionally:
>
> # du -sh /*


Usually yes, but here not. It's just like when you remove a file when
a process still use it and write in it, and fcsk will be not happy
next time.
But I reboot & check with btrfs check withtout any issue :-/

alian@alian:/> sudo btrfs fi du -s *
     Total   Exclusive  Set shared  Filename
   1.58MiB     1.58MiB       0.00B  bin
  42.69MiB    42.69MiB       0.00B  boot
  14.78MiB    14.78MiB       0.00B  etc
 532.40MiB   532.40MiB       0.00B  lib
   9.88MiB     9.88MiB       0.00B  lib64
     0.00B       0.00B       0.00B  mnt
  23.96MiB    23.96MiB       0.00B  opt
 128.00KiB   128.00KiB       0.00B  root
   9.74MiB     9.74MiB       0.00B  sbin
     0.00B       0.00B       0.00B  selinux
     0.00B       0.00B       0.00B  srv
  15.92MiB    15.92MiB       0.00B  tmp
   4.86GiB     4.86GiB       0.00B  usr
 345.65MiB   345.65MiB       0.00B  var

alian@alian:~> sudo du --exclude /home -sh /*
2,1M    /bin
43M     /boot
0       /dev
20M     /etc
534M    /lib
11M     /lib64
0       /mnt
24M     /opt
0       /proc
172K    /root
18M     /run
11M     /sbin
0       /selinux
0       /srv
0       /sys
16M     /tmp
5,2G    /usr
355M    /var
