Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36792 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753015AbcHaXJ7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 19:09:59 -0400
Received: by mail-oi0-f65.google.com with SMTP id b22so6133537oii.3
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Aug 2016 16:09:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
References: <1471023419.16857.9.camel@gmail.com> <57C426AB.3020607@cn.fujitsu.com>
 <1472485953.3290.0.camel@gmail.com> <57C4EB85.7030000@cn.fujitsu.com>
 <1472561404.3179.3.camel@gmail.com> <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com> <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com> <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 31 Aug 2016 17:09:38 -0600
Message-ID: <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 31, 2016 at 5:03 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 8/31/16 6:58 PM, Chris Murphy wrote:

> Does Ronan's call trace showing
>> /fs/btrfs/qgroup.c:2667
>>> btrfs_qgroup_free_meta implicate qgroups as a possible source of his problem? That trace would only happen if quotas were enabled, right?
>>
>
> Yeah.  That warning doesn't get checked unless they're enabled.

OK so Ronan, I'm gonna guess the simplest work around for your problem
is to disable quota support, and see if the problem happens again.

If it doesn't happen again then it sounds like the reproduce steps are:

a. enable quota support
b. do something metadata heavy workload that's also maybe hitting
fsync; from opensuse list the example that sometimes causes it:


  osc co home:Ronis_BR/julia
  cd home:Ronis_BR/julia
  osc build --root=`pwd`/jail openSUSE_Tumbleweed x86_64

I wonder if it's easier to hit it on a hard drive, slower fsyncs?

-- 
Chris Murphy
