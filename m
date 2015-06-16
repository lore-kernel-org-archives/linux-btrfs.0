Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36017 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830AbbFPItF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 04:49:05 -0400
Received: by igbiq7 with SMTP id iq7so37669393igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 01:49:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <557FCB10.7050304@gmail.com>
References: <557E9C2B.9030404@gmail.com>
	<20150615095720.GF9850@carfax.org.uk>
	<557FCB10.7050304@gmail.com>
Date: Tue, 16 Jun 2015 15:49:04 +0700
Message-ID: <CAG1y0sfhz7kdr3VN7V9EnpkJqh926+kHzZHGU2B7=62y-mVGgw@mail.gmail.com>
Subject: Re: CoW with webserver databases: innodb_file_per_table and dedicated
 tables for blobs?
From: "Fajar A. Nugraha" <list@fajar.net>
To: Ingvar Bogdahn <ingvar.bogdahn@googlemail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 16, 2015 at 2:06 PM, Ingvar Bogdahn
<ingvar.bogdahn@googlemail.com> wrote:
> Hi again,
>
> Benchmarking over time seems a good idea, but what if I see that a
> particular database does indeed degrade in performance? How can I then
> selectively improve performance for that file, since disabling cow only
> works for new empty files?
>

you might be overcomplicating things.

> Is it correct that bundling small random writes into groups of writes
> reduces fragmentation? If so, some form of write-caching should help? I'm
> still investigating, but one solution might be:
> 1) identify which exact tables do have frequent writes
> 2) decrease the system-wide write-caching (vm.dirty_background_ratio and
> vm.dirty_ratio) to lower levels, because this wastes lots of RAM by
> indiscriminately caching writes of the whole system, and tends to causes
> spikes where suddenly the entire cache gets written to disk and block the
> system. Rather use that RAM selectively to cache only the critical files.

IIRC innodb uses O_DIRECT by default, which should bypass fs cache, so
the above should be irrelevant


> 4) create a software RAID-1 made up of a ramdisk and a mounted image, using
> mdadm.
> 5) Setting up mdadm using rather large value for "write-behind="
> 6) put only those tables on that disk-backed ramdisk which do have frequent
> writes.
>

raid1 writes everything to both, so your write performance would still
be limited by the disk.
As for reads, instead of using ramdisk for half of md, I would just
use that amount of ram for innodb_buffer_pool


> What do you think?


I would say "determine your priorities".

If you absolutely need btrfs + innodb, then I would:
- increase innodb_buffer_pool
- don't mess with nocow, leave it as is
- don't mess with autodefrag
- enable compression on btrfs
- use latest known good kernel (AFAIK 4.0.5 should be good)

If you absolutely must have high performance with innodb, then I would
look at using raw block device directly for innodb. You'd lose all
btrfs features of course (e.g. snapshots), but it's a tradeoff for
performance.

If you don't HAVE to use innodb but still want to use btrfs, then I
would use tokudb engine instead (available in tokudb's mysql fork and
mariadb >= 10), with compression handled by tokudb (disable
compression in btrfs). tokudb doesn't support foreign constraint, but
other than that it should be able to replace innodb for your purposes.
Among other things, tokudb uses larger block size (4MB) so it should
help reduce fragmentation compared to innodb.

If you don't HAVE to use either btrfs or innodb, but just want "mysql
db that supports transactions with an fs that supports
snapshot/clone", then I would use zfs + tokudb. And read
http://blog.delphix.com/matt/2014/06/06/zfs-stripe-width/ (with the
exception that compression should be used in tokudb instead of zfs)

-- 
Fajar

>
> Ingvar
>
>
>
> Am 15.06.15 um 11:57 schrieb Hugo Mills:
>
>> On Mon, Jun 15, 2015 at 11:34:35AM +0200, Ingvar Bogdahn wrote:
>>>
>>> Hello there,
>>>
>>> I'm planing to use btrfs for a medium-sized webserver. It is
>>> commonly recommended to set nodatacow for database files to avoid
>>> performance degradation. However, apparently nodatacow disables some
>>> of my main motivations of using btrfs : checksumming and (probably)
>>> incremental backups with send/receive (please correct me if I'm
>>> wrong on this). Also, the databases are among the most important
>>> data on my webserver, so it is particularly there that I would like
>>> those feature working.
>>>
>>> My question is, are there strategies to avoid nodatacow of databases
>>> that are suitable and safe in a production server?
>>> I thought about the following:
>>> - in mysql/mariadb: setting "innodb_file_per_table" should avoid
>>> having few very big database files.
>>
>>     It's not so much about the overall size of the files, but about the
>> write patterns, so this probably won't be useful.
>>
>>> - in mysql/mariadb: adapting database schema to store blobs into
>>> dedicated tables.
>>
>>     Probably not an issue -- each BLOB is (likely) to be written in a
>> single unit, which won't cause the fragmentation problems.
>>
>>> - btrfs: set autodefrag or some cron job to regularly defrag only
>>> database fails to avoid performance degradation due to fragmentation
>>
>>     Autodefrag is a good idea, and I would suggest trying that first,
>> before anything else, to see if it gives you good enough performance
>> over time.
>>
>>     Running an explicit defrag will break any CoW copies you have (like
>> snapshots), causing them to take up additional space. For example,
>> start with a 10 GB subvolume. Snapshot it, and you will still only
>> have 10 GB of disk usage. Defrag one (or both) copies, and you'll
>> suddenly be using 20 GB.
>>
>>> - turn on compression on either btrfs or mariadb
>>
>>     Again, won't help. The issue is not the size of the data, it's the
>> write patterns: small random writes into the middle of existing files
>> will eventually cause those files to fragment, which causes lots of
>> seeks and short reads, which degrades performance.
>>
>>> Is this likely to give me ok-ish performance? What other
>>> possibilities are there?
>>
>>     I would recommend benchmarking over time with your workloads, and
>> seeing how your performance degrades.
>>
>>     Hugo.
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
