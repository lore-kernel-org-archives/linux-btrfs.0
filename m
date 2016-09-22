Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:35060 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933483AbcIVNmF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 09:42:05 -0400
Received: by mail-it0-f53.google.com with SMTP id r192so157446561ita.0
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 06:42:04 -0700 (PDT)
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Jeff Mahoney <jeffm@suse.com>, Josef Bacik <jbacik@fb.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>
References: <1471023419.16857.9.camel@gmail.com>
 <1472734635.3137.4.camel@gmail.com>
 <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com>
 <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
 <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
 <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
 <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com>
 <1472827395.3713.6.camel@gmail.com>
 <9dee919a-0e81-5ba7-ddc6-7dcdb3a6b873@suse.com>
 <1472829630.3713.8.camel@gmail.com>
 <506f2875-8cea-2d99-3664-52ee546adcfd@suse.com>
 <1472844353.3083.1.camel@gmail.com>
 <356a9e31-047e-d4c9-00ba-d01b6e92b266@cn.fujitsu.com>
 <1473359094.7190.1.camel@gmail.com>
 <86f87e36-db70-2ad1-cc20-3537dc7e529e@suse.com>
 <14f71ffe-4cc7-bad1-fde1-42d5e5f90d1d@suse.com>
 <08737c8d-9f1b-5f18-61a0-d3bb501eb950@fb.com>
 <9221d4d9-d114-4ffb-d2f8-6dc2d1cdb79c@suse.com>
 <57DF4E44.2040506@cn.fujitsu.com> <1474550402.3206.4.camel@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6ae8684e-a671-1f8d-9ad3-1299b442bd3c@gmail.com>
Date: Thu, 22 Sep 2016 09:41:53 -0400
MIME-Version: 1.0
In-Reply-To: <1474550402.3206.4.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-22 09:20, Ronan Arraes Jardim Chagas wrote:
> Guys,
>
> Something very strange happened. I have not seen the problem since
> Monday, which is pretty much the first time ever I work more than 3
> days without seeing it.
>
> Ok, it can be a coincidence. Notice that I did not change anything
> related to my work behavior. However, I did do two things:
>
> _ Update the kernel to 4.7.2; and
> _ Created 50 dummy files with 3.0 GiB each.
>
> Can anyone, please, tell me if these things seems to be correlated?
Most likely the kernel upgrade fixed things.  It's possible that the 
large allocation is impacting something and making it work, but I don't 
think that that is very likely.

