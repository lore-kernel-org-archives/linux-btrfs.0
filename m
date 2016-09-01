Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34023 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbcIAWid (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 18:38:33 -0400
Received: by mail-oi0-f48.google.com with SMTP id m11so11881916oif.1
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Sep 2016 15:38:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
References: <1471023419.16857.9.camel@gmail.com> <57C426AB.3020607@cn.fujitsu.com>
 <1472485953.3290.0.camel@gmail.com> <57C4EB85.7030000@cn.fujitsu.com>
 <1472561404.3179.3.camel@gmail.com> <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com> <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com> <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com> <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com> <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 1 Sep 2016 11:07:25 -0600
Message-ID: <CAJCQCtS6xfSuD=A=5AZGjp-Antn4PE0NYw58W1KSL6ePk1bgmA@mail.gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Chris Murphy <lists@colorremedies.com>, Jeff Mahoney <jeffm@suse.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 1, 2016 at 7:21 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> Yes, you can just run `btrfs quota disable /` and it should work.  This
> ironically reiterates that one of the bigger problems with BTRFS is that
> distros are enabling unstable and known broken features by default on
> install.  I was pretty much dumbfounded when I first learned that OpenSUSE
> is enabling BTRFS qgroups by default since they are known to not work
> reliably and cause all kinds of issues.

Yes, I've just confirmed this on the OpenSUSE Factory mailing list.
[1] This is default on Tumbleweed (devel) and Leap (stable), and also
SLE 12 SP2.

The feature that depends on it, that's actually enabling it is snapper:
http://snapper.io/2016/05/18/space-aware-cleanup.html

That feature says "btrfs quota support looks mature enough" which is
big news to me. If it's that mature, why not make it the mkfs default?
Just turn it on for everyone out of the gate? And if it isn't that
mature, is it really appropriate for broad, by default, silent
deployment for opensuse stable, and SUSE enterprise? I'm surprised no
one said on this list that qgroups were stable enough for widespread
testing for list regulars first. It just suddenly ends up enabled
across three major distro outputs?

Even the fucking error messages were misleading. It wasn't until the
most recent call trace that qgroups was even considered as possibly
being related to this. How is it that busting a quota limit doesn't
cause a very explicit quota related message, rather than a generic
enospc?


[1] https://lists.opensuse.org/opensuse-factory/2016-09/msg00033.html


-- 
Chris Murphy
