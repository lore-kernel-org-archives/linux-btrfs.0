Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:33497 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbdG0QSu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 12:18:50 -0400
Received: by mail-wm0-f46.google.com with SMTP id e199so48870wmd.0
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 09:18:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMG9ccxPHHwEYBYZddTaX96kEnan5NtDvhUW=gw+NoUe7amyiA@mail.gmail.com>
References: <CAMG9ccwAaWtK=VqNcB9z9Q2qLNHr3q0QmWR0hg=RoG1ynZB-ng@mail.gmail.com>
 <CAMG9ccxPHHwEYBYZddTaX96kEnan5NtDvhUW=gw+NoUe7amyiA@mail.gmail.com>
From: Ivan Sizov <sivan606@gmail.com>
Date: Thu, 27 Jul 2017 19:18:29 +0300
Message-ID: <CAMG9ccwx-45GtzrenH3cCgd2pnMqe5s-mvh2MH_Lp76A_yU=7A@mail.gmail.com>
Subject: Re: What are the typical usecase of "btrfs check --init-extent-tree"?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Small clarification after reading journal: errors stats weren't
changed on sda since December, but READ error count was increased on
sdc (especially in May, when I first noticed problems) and sdb.
