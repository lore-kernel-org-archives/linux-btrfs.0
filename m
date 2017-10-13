Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41370 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753291AbdJMCwm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 22:52:42 -0400
Subject: Re: btrfs seed question
To: Joseph Dunn <jdunn14@gmail.com>, Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20171011204759.1848abd7@olive.ig.local>
 <ff596f2f-7232-4ee0-7967-6888236cc831@oracle.com>
 <20171012092028.1fbe79d9@olive.ig.local>
 <CAJCQCtREBoFKB6_gS2WpkRuiA4nV1Ar4pcRbDB6Gaf1t8vSkLw@mail.gmail.com>
 <20171012104438.4304e99a@olive.ig.local>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <4a1ade13-3a2a-edfa-9918-70cef7e3cf5a@oracle.com>
Date: Fri, 13 Oct 2017 10:52:25 +0800
MIME-Version: 1.0
In-Reply-To: <20171012104438.4304e99a@olive.ig.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>>> Not quite.  While the seed device is still connected I would like to
>>> force some files over to the rw device.  The use case is basically a
>>> much slower link to a seed device holding significantly more data than
>>> we currently need.  An example would be a slower iscsi link to the seed
>>> device and a local rw ssd.  I would like fast access to a certain subset
>>> of files, likely larger than the memory cache will accommodate. >>> If at a later time I want to discard the image as a whole I could
 >>> unmount the file system or


   Interesting. If you had not brought the idea of using seed device,
   I would have still thinking about bcache device as a solution for
   the above use case.

   However bcache device won't help to solve the further use case
   requirements as below..


>>> if I want a full local copy I could delete the
>>> seed-device to sync the fs.  In the mean time I would have access to
>>> all the files, with some slower (iscsi) and some faster (ssd) and the
>>> ability to pick which ones are in the faster group at the cost of one
>>> content transfer.

   I am thinking why not indeed leverage seed/sprout for this.
   Let me see how I (or if anyone could) allocate time to experiment
   on this.

  Thanks for your use case !

-Anand
