Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:35842 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751820AbdBHCL7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 21:11:59 -0500
Received: by mail-ua0-f172.google.com with SMTP id 96so99302027uaq.3
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 18:11:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170207140058.GA4249@carfax.org.uk>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
From: Peter Zaitsev <pz@percona.com>
Date: Tue, 7 Feb 2017 21:11:57 -0500
Message-ID: <CA+RUij3yQ83HQzN8VfzAaku6+HTcXEz+iqu5nV1=UVX6Gc4ddw@mail.gmail.com>
Subject: Re: BTRFS for OLTP Databases
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Kai,

I guess your message did not make it to me as I'm not subscribed to the list.

I totally understand what the the snapshot is "crash consistent"  -
consistent to the state of the disk you would find if you shut down
the power with no notice,
for many applications it is a problem however it is fine for many
databases which already need to be able to recover correctly from
power loss

for MySQL this works well for Innodb storage engine it does not work for MyISAM

The great of such "uncoordinated" snapshot is what it is instant and
have very little production impact -  if you want to "freeze" multiple
filesystems or
even worse flush MyISAM table it can take a lot of time and can be
unacceptable for many 24/7 workloads.

Or are you saying BTRFS snapshots do not provide this kind of consistency ?

> Hi Hugo,
>
> For the use case I'm looking for I'm interested in having snapshot(s)
> open at all time.  Imagine  for example snapshot being created every
> hour and several of these snapshots  kept at all time providing quick
> recovery points to the state of 1,2,3 hours ago.  In  such case (as I
> think you also describe)  nodatacow  does not provide any advantage.

Out of curiosity, I see one problem here:

If you're doing snapshots of the live database, each snapshot leaves
the database files like killing the database in-flight. Like shutting
the system down in the middle of writing data.

This is because I think there's no API for user space to subscribe to
events like a snapshot - unlike e.g. the VSS API (volume snapshot
service) in Windows. You should put the database into frozen state to
prepare it for a hotcopy before creating the snapshot, then ensure all
data is flushed before continuing.

I think I've read that btrfs snapshots do not guarantee single point in
time snapshots - the snapshot may be smeared across a longer period of
time while the kernel is still writing data. So parts of your writes
may still end up in the snapshot after issuing the snapshot command,
instead of in the working copy as expected.

How is this going to be addressed? Is there some snapshot aware API to
let user space subscribe to such events and do proper preparation? Is
this planned? LVM could be a user of such an API, too. I think this
could have nice enterprise-grade value for Linux.

XFS has xfs_freeze and xfs_thaw for this, to prepare LVM snapshots. But
still, also this needs to be integrated with MySQL to properly work. I
once (years ago) researched on this but gave up on my plans when I
planned database backups for our web server infrastructure. We moved to
creating SQL dumps instead, although there're binlogs which can be used
to recover to a clean and stable transactional state after taking
snapshots. But I simply didn't want to fiddle around with properly
cleaning up binlogs which accumulate horribly much space usage over
time. The cleanup process requires to create a cold copy or dump of the
complete database from time to time, only then it's safe to remove all
binlogs up to that point in time.

-- 
Regards,
Kai

On Tue, Feb 7, 2017 at 9:00 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Feb 07, 2017 at 08:53:35AM -0500, Peter Zaitsev wrote:
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
>
>    Well, nodatacow will still allow snapshots to work, but it also
> allows the data to fragment. Each snapshot made will cause subsequent
> writes to shared areas to be CoWed once (and then it reverts to
> unshared and nodatacow again).
>
>    There's another approach which might be worth testing, which is to
> use autodefrag. This will increase data write I/O, because where you
> have one or more small writes in a region, it will also read and write
> the data in a small neghbourhood around those writes, so the
> fragmentation is reduced. This will improve subsequent read
> performance.
>
>    I could also suggest getting the latest kernel you can -- 16.04 is
> already getting on for a year old, and there may be performance
> improvements in upstream kernels which affect your workload. There's
> an Ubuntu kernel PPA you can use to get the new kernels without too
> much pain.
>
>    Hugo.
>
> --
> Hugo Mills             | I don't care about "it works on my machine". We are
> hugo@... carfax.org.uk | not shipping your machine.
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |



-- 
Peter Zaitsev, CEO, Percona
Tel: +1 888 401 3401 ext 7360   Skype:  peter_zaitsev
