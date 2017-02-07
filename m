Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:33109 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755382AbdBGS74 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 13:59:56 -0500
Received: by mail-ua0-f177.google.com with SMTP id i68so91845357uad.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 10:59:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <579c53e4-f993-dd85-b5a4-76a0b201b899@suse.com>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <579c53e4-f993-dd85-b5a4-76a0b201b899@suse.com>
From: Peter Zaitsev <pz@percona.com>
Date: Tue, 7 Feb 2017 13:59:54 -0500
Message-ID: <CA+RUij2QOP=bJos8p6NswZqSdbhwZ7frTdaLtZaiGBc4vKajCg@mail.gmail.com>
Subject: Re: BTRFS for OLTP Databases
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jeff,

Thank you very much for explanations. Indeed it was not clear in the
documentation - I read it simply as "if you have snapshots enabled
nodatacow makes no difference"

I will rebuild the database in this mode from scratch and see how
performance changes.

So far the most frustating for me was periodic stalls for many seconds
 (running sysbench workload).  What was the most puzzling  I get this
even if I run workload at the  50% or less of the full load  -  Ie
database can handle 1000 transactions/sec and I only inject 500/sec
and I still have those stalls.

This is where it looks to me like some work is being delayed and when
it requires stall for a few seconds to catch up.    I wonder  if there
are some configuration options available to play with.

So far I found BTRFS rather  "zero configuration" which is great if it
works but it is also great to have more levers to pull if you're
having some troubles.


On Tue, Feb 7, 2017 at 1:27 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 2/7/17 8:53 AM, Peter Zaitsev wrote:
>> Hi,
>>
>> I have tried BTRFS from Ubuntu 16.04 LTS   for write intensive OLTP MySQL
>> Workload.
>>
>> It did not go very well ranging from multi-seconds stalls where no
>> transactions are completed to the finally kernel OOPS with "no space left
>> on device" error message and filesystem going read only.
>>
>> I'm complete newbie in BTRFS so  I assume  I'm doing something wrong.
>>
>> Do you have any advice on how BTRFS should be tuned for OLTP workload
>> (large files having a lot of random writes)  ?    Or is this the case where
>> one should simply stay away from BTRFS and use something else ?
>>
>> One item recommended in some places is "nodatacow"  this however defeats
>> the main purpose I'm looking at BTRFS -  I am interested in "free"
>> snapshots which look very attractive to use for database recovery scenarios
>> allow instant rollback to the previous state.
>>
>
> Hi Peter -
>
> There seems to be some misunderstanding around how nodatacow works.
> Nodatacow doesn't prohibit snapshot use.  Snapshots are still allowed
> and, of course, will cause CoW to happen when a write occurs, but only
> on the first write.  Subsequent writes will not CoW again.  This does
> mean you don't get CRC protection for data, though.  Since most
> databases do this internally, that is probably no great loss.  You will
> get fragmentation, but that's true of any random-write workload on btrfs.
>
> Timothy's comment about how extents are accounted is more-or-less
> correct.  The file extents in the file system trees reference data
> extents in the extent tree.  When portions of the data extent are
> unreferenced, they're not necessarily released.  A balance operation
> will usually split the data extents so that the unused space is released.
>
> As for the Oopses with ENOSPC, that's something we'd want to look into
> if it can be reproduced with a more recent kernel.  We shouldn't be
> getting ENOSPC anywhere sensitive anymore.
>
> -Jeff
>
> --
> Jeff Mahoney
> SUSE Labs
>



-- 
Peter Zaitsev, CEO, Percona
Tel: +1 888 401 3401 ext 7360   Skype:  peter_zaitsev
