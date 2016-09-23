Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:36001 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035155AbcIWPUu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 11:20:50 -0400
Received: by mail-qt0-f193.google.com with SMTP id 11so3621874qtc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2016 08:20:50 -0700 (PDT)
Message-ID: <1474644041.5010.4.camel@gmail.com>
Subject: Re: [SOLVED] BTRFS constantly reports "No space left on device"
 even with a huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Josef Bacik <jbacik@fb.com>, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Jeff Mahoney <jeffm@suse.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Fri, 23 Sep 2016 12:20:41 -0300
In-Reply-To: <949294ac-fe4a-10b1-70aa-e9a65530d0d5@fb.com>
References: <1471023419.16857.9.camel@gmail.com>
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
         <6ae8684e-a671-1f8d-9ad3-1299b442bd3c@gmail.com>
         <1474552982.3206.12.camel@gmail.com>
         <ea4797a6-87af-1b52-ccf0-4139186491b0@fb.com>
         <1474563967.3206.16.camel@gmail.com>
         <949294ac-fe4a-10b1-70aa-e9a65530d0d5@fb.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys!

After a week without experiencing the problem, I think we can mark this
problem as solved. I want to thanks all the devs on this list. You were
always very helpful. For anyone who is still experiencing the reported
problem, upgrade to kernel 4.7.3 and I think you will be fine :)

Best regards and thank you all,
Ronan Arraes
