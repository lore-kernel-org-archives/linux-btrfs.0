Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34909 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753471AbcHWQHS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 12:07:18 -0400
Received: by mail-oi0-f52.google.com with SMTP id 4so203078373oih.2
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 09:07:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTyuxQee_GzgZCY2WRC04LEXAOvbg_BW_uBVh+iTTgrEQ@mail.gmail.com>
References: <FBA93BA3BE574649A3C97265F3CE0D54013A625685@ber-vi4.ad.vi>
 <CAJCQCtQf2bhxWc6+nYoxYz8HquMOsj5hAfTc=5B2w0_1d8U9rQ@mail.gmail.com>
 <B26BAB7E-A049-4730-B7AD-3E906026F25C@visageimaging.com> <CAJCQCtSuiSrLVLVmF9wktcMJqApET0DoOf=_2V=oEb=5sPPTgg@mail.gmail.com>
 <E80D3AE3-69A9-40E7-9946-D2F66214828B@visageimaging.com> <CAJCQCtTyuxQee_GzgZCY2WRC04LEXAOvbg_BW_uBVh+iTTgrEQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 23 Aug 2016 10:07:16 -0600
Message-ID: <CAJCQCtTgzJxTV6WEre0jZ7d-f0Apng6kBoBfHmcktQfB5rq5xA@mail.gmail.com>
Subject: Re: btrfs partition fails to mount after power outage
To: Chris Murphy <lists@colorremedies.com>
Cc: Malte Westerhoff <MWesterhoff@visageimaging.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 23, 2016 at 10:05 AM, Chris Murphy <lists@colorremedies.com> wrote:


>btrfs-find-root -d /dev/mapper/VGBIGRAID6-DATA1

I meant to ask for

btrfs-debug-tree -d /dev/...





-- 
Chris Murphy
