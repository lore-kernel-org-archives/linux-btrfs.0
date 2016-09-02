Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36462 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750809AbcIBAOE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 20:14:04 -0400
Received: by mail-oi0-f65.google.com with SMTP id b22so9266651oii.3
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Sep 2016 17:12:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
References: <1471023419.16857.9.camel@gmail.com> <57C426AB.3020607@cn.fujitsu.com>
 <1472485953.3290.0.camel@gmail.com> <57C4EB85.7030000@cn.fujitsu.com>
 <1472561404.3179.3.camel@gmail.com> <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com> <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com> <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com> <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com> <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com> <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com> <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 1 Sep 2016 18:12:30 -0600
Message-ID: <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>,
        Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 1, 2016 at 12:47 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:


> 2. Snapper's default snapshot creation configuration is absolutely
> pathological in nature, generating insane amounts of background resource
> usage and taking up huge amounts of space.  If this were changed, you would
> be a lot less dependent on being able to free up snapshots based on space
> usage.

That's diplomatic.

They know all of this already though, but instead of toning down
snapper defaults, they're amping up the voluming by enabling quotas
instead.

There is only one logical reason for this that I can thing of. They're
trying to increase problem reports, presumably in order to smooth out
noisy data, maybe even by getting better bug reports like Ronan's. But
I think this is a specious policy.

> It's poor choices like this that fall into the category of 'Ooh, this looks
> cool, let's do it!' made by major distros that are most of the reason that
> BTRFS has such a bad reputation right now.

Over on Factory list, they're trying to have this two ways. First
they're saying quotas are stable as they've implemented them in the
Leap 4.4 kernel. And they consider the btrfs-progs man page warning
that quotas aren't yet stable even in 4.7, and aren't recommended
unless the user will use them, is a bug that should be removed from
their copy of the man page.

So, what are they using? Pulling out such warnings doesn't make
upstream code backported to their 4.4 kernel magically stable. If
they're using out of tree quota code, fine, remove the warnings. But
then, what is this code? How does it interact with upstream kernels?



-- 
Chris Murphy
