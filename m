Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34010 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753708AbcHaVsx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 17:48:53 -0400
Received: by mail-oi0-f68.google.com with SMTP id t127so5974538oie.1
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Aug 2016 14:48:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
References: <1471023419.16857.9.camel@gmail.com> <57C426AB.3020607@cn.fujitsu.com>
 <1472485953.3290.0.camel@gmail.com> <57C4EB85.7030000@cn.fujitsu.com>
 <1472561404.3179.3.camel@gmail.com> <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com> <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 31 Aug 2016 15:48:51 -0600
Message-ID: <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
Cc: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK it looks like with -w flag I can get a reliable indication of
whether quota is enabled or not:

[root@f24s ~]# btrfs quota enable /mnt/0
[root@f24s ~]# btrfs quota rescan -w /mnt/0
quota rescan started
[root@f24s ~]# btrfs quota disable /mnt/0
[root@f24s ~]# btrfs quota rescan -w /mnt/0
ERROR: quota rescan failed: Invalid argument


So if you did not enable quota support, and aren't sure if it's
enabled you can try 'btrfs quota rescan -w <mp>' but this might
actually be a bad idea, a rescan could take a while if you're actually
using quotas, I have no idea because I don't use them.

Perhaps someone can point out an easier way to determine whether
quotas are enabled?



Chris Murphy
