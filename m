Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:33758 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751830AbcJJH0X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 03:26:23 -0400
Received: by mail-lf0-f51.google.com with SMTP id x79so111755708lff.0
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Oct 2016 00:26:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKinxcUpjf1fD5__gd6XgmcyByFqz3JNgnk7z9iCAui+KWj2nA@mail.gmail.com>
References: <CAB9fVVH6S-Y0Li=6xyw2P23CEPwVRA6hRbjJNi+_3etHnqMh1w@mail.gmail.com>
 <CAKinxcWNP_tf77RkVAjE8C2Nd6LYDsAT2VJNM_m6QYmO7nVE9g@mail.gmail.com>
 <CAN05THSUtzUTXxKuQ7+fr7SDsbd0kGn8OGsXmkErS79Rh1ufLQ@mail.gmail.com> <CAKinxcUpjf1fD5__gd6XgmcyByFqz3JNgnk7z9iCAui+KWj2nA@mail.gmail.com>
From: Peter Becker <floyd.net@gmail.com>
Date: Mon, 10 Oct 2016 09:26:21 +0200
Message-ID: <CAEtw4r25A_9YVVpCSGbcg8sb+eQmg993SuSEg86EcexRuLiUdA@mail.gmail.com>
Subject: Re: raid levels and NAS drives
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>,
        Charles Zeitler <cfzeitler@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From experience, for a video-archiv and backup-server its not a
problem to use desktop drives if you respect the following thinks:

1. Avoid stock "green"-drives; For example, use the WD Idle tool to
stop excessive load cycles for WD Green drives
2. Desktop drives didn't have time-limited error recovery (TLER); if
you have bad sectores. the drive will try to read the sectore for 1-2
minutes
3. Avoid the cheap toshiba 5TB drives .. :)

I have i use: 3x WD Green 3TB, 1x WD Red 3TB, 1x WD Red 6TB, 1x Seagate NAS 3TB
