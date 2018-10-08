Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF6BC677D0
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 12:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D26232085B
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 12:20:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PD8lzkzL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D26232085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbeJHTbj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 15:31:39 -0400
Received: from mail-it1-f169.google.com ([209.85.166.169]:50868 "EHLO
        mail-it1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbeJHTbi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2018 15:31:38 -0400
Received: by mail-it1-f169.google.com with SMTP id j81-v6so11144086ite.0
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2018 05:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DEtqVDWyguh1nDcjI15FxDuCgpKeVTWOLC91uPy8g9E=;
        b=PD8lzkzLSqEmW4XXsp+J542fg21rxVmSXRhevSCeEqWSrzbcQEzAdpHDQON59hEvph
         siNJk5Yoc7MB/oL68bJjgEa1hZ+6P735V7o+GXbWUnXrF3uC3EFeKKEL+YxtyDExMK2z
         mWC2aez/WWN6BEzEcPqr0wvKLrHxOY4DwkJyoUYqJS56fmY61Ds+2Cl7bQvviduHpgH3
         HTxzJ/ORlOZFrhc8Py9D07iVS4fQMu+yB/dHb5zzCdz9A3+/H6UqimM7wtmMqoZ2yJ9F
         X/H2rXEkjI59lUA7YdyygyrjERKyFfuIgGRFll/oTqSKyVF+G4U9Q9c+Vz7FHnfDK3W5
         35Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DEtqVDWyguh1nDcjI15FxDuCgpKeVTWOLC91uPy8g9E=;
        b=eDF9T9xZYYMpZy6T0vx0LLKfO9JC8FLLZqrZt9BF3FtAPPGIZmlKccEYL1+9xIGxZD
         0NmFcvEV38vmL5ViuPrVjwOlYjeKhagDn+9oNFplfruQPxYNNdz/JCe+6qSFULzU+8XM
         yQvG/jQBKtxg/bKC/qTlJJxscTse2GU8mpYH7Y5X9A9KWozHjaSE+Gh+xCQIiVUNndDv
         ANv6z1n9vZLohXe4BUTGmeDbNV8YyDST76owC8DntXfY3AWW/qV4fzfXNLfN5Y9xJYgz
         yjsWjWn7pwzo4i820uF5KyouWWJiyDflkY6pozzmndbFZHuduP0Z/ElqGbC3Gsp63QFB
         VOjQ==
X-Gm-Message-State: ABuFfohf/Kt9PyjgPqsf6wDgrZKv2LPbCH2ZFVTkrUTiSv8GBFe0TcJX
        jMZPJGapVOIYAvtyVLTMiGNKXnEs4nU=
X-Google-Smtp-Source: ACcGV612y9UXDp10c7O39YKtm6IXWE5kZl261oY11Rd+nUm+p7uTGyfdj1Qm/AeoGUy9dJ4VLwuvMw==
X-Received: by 2002:a24:94cc:: with SMTP id j195-v6mr5213953ite.34.1539001209927;
        Mon, 08 Oct 2018 05:20:09 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id e204-v6sm6442741ite.24.2018.10.08.05.20.08
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Oct 2018 05:20:08 -0700 (PDT)
Subject: Re: Understanding BTRFS RAID0 Performance
To:     linux-btrfs@vger.kernel.org
References: <54026c92-9cd1-2ac8-5747-c5405dd82087@panasas.com>
 <pan$77fbd$8ebaf02d$210deb71$a2b73f29@cox.net>
 <591cce01-0bdb-19ca-5454-1398283cd86e@panasas.com>
 <pan$ed78e$c67857b4$3003fa74$eefe6b3@cox.net>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3595aa77-9142-165e-c271-c2e4b1110f67@gmail.com>
Date:   Mon, 8 Oct 2018 08:20:06 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <pan$ed78e$c67857b4$3003fa74$eefe6b3@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-10-05 20:34, Duncan wrote:
> Wilson, Ellis posted on Fri, 05 Oct 2018 15:29:52 +0000 as excerpted:
> 
>> Is there any tuning in BTRFS that limits the number of outstanding reads
>> at a time to a small single-digit number, or something else that could
>> be behind small queue depths?  I can't otherwise imagine what the
>> difference would be on the read path between ext4 vs btrfs when both are
>> on mdraid.
> 
> It seems I forgot to directly answer that question in my first reply.
> Thanks for restating it.
> 
> Btrfs doesn't really expose much performance tuning (yet?), at least
> outside the code itself.  There are a few very limited knobs, but they're
> just that, few and limited or broad-stroke.
> 
> There are mount options like ssd/nossd, ssd_spread/nossd_spread, the
> space_cache set of options (see below), flushoncommit/noflushoncommit,
> commit=<seconds>, etc (see the btrfs (5) manpage), but nothing really to
> influence stride length, etc, or to optimize chunk placement between ssd
> and non-ssd devices, for instance.
> 
> And there's a few filesystem features, normally set at mkfs.btrfs time
> (and thus covered in the mkfs.btrfs manpage) but some of which can be
> tuned later, but generally, the defaults have changed over time to
> reflect the best case, and the older variants are there primarily to
> retain backward compatibility with old kernels and tools that didn't
> handle the newer variants.
> 
> That said, as I think about it there are some tunables that may be worth
> experimenting with.  Most or all of these are covered in the btrfs (5)
> manpage.
> 
> * Given the large device numbers you mention and raid0, you're likely
> dealing with multi-TB-scale filesystems.  At this level, the
> space_cache=v2 mount option may be useful.  It's not the default yet as
> btrfs check, etc, don't yet handle it, but given your raid0 choice you
> may not be concerned about that.  Need only be given once after which v2
> is "on" for the filesystem until turned off.
> 
> * Consider experimenting with the thread_pool=n mount option.  I've seen
> very little discussion of this one, but given your interest in
> parallelization, it could make a difference.
Probably not as much as you might think.  I'll explain a bit more 
further down where this is being mentioned again.
> 
> * Possibly the commit=<seconds> (default 30) mount option.  In theory,
> upping this may allow better write merging, tho your interest seems to be
> more on the read side, and the commit time has consequences at crash time.
Based on my own experience, having a higher commit time doesn't impact 
read or write performance much or really help all that much with write 
merging.  All it really helps with is minimizing overhead, but it's not 
even all that great at doing that.
> 
> * The autodefrag mount option may be considered if you do a lot of
> existing file updates, as is common with database or VM image files.  Due
> to COW this triggers high fragmentation on btrfs, and autodefrag should
> help control that.  Note that autodefrag effectively increases the
> minimum extent size from 4 KiB to, IIRC, 16 MB, tho it may be less, and
> doesn't operate at whole-file size, so larger repeatedly-modified files
> will still have some fragmentation, just not as much.  Obviously, you
> wouldn't see the read-time effects of this until the filesystem has aged
> somewhat, so it may not show up on your benchmarks.
> 
> (Another option for such files is setting them nocow or using the
> nodatacow mount option, but this turns off checksumming and if it's on,
> compression for those files, and has a few other non-obvious caveats as
> well, so isn't something I recommend.  Instead of using nocow, I'd
> suggest putting such files on a dedicated traditional non-cow filesystem
> such as ext4, and I consider nocow at best a workaround option for those
> who prefer to use btrfs as a single big storage pool and thus don't want
> to do the dedicated non-cow filesystem for some subset of their files.)
> 
> * Not really for reads but for btrfs and any cow-based filesystem, you
> almost certainly want the (not btrfs specific) noatime mount option.
Actually...  This can help a bit for some workloads.  Just like the 
commit time, it comes down to a matter of overhead.  Essentially, if you 
read a file regularly, than with the default of relatime, you've got a 
guaranteed write requiring a commit of the metadata tree once every 24 
hours.  It's not much to worry about for just one file, but if you're 
reading a very large number of files all the time, it can really add up.
> 
> * While it has serious filesystem integrity implications and thus can't
> be responsibly recommended, there is the nobarrier mount option.  But if
> you're already running raid0 on a large number of devices you're already
> gambling with device stability, and this /might/ be an additional risk
> you're willing to take, as it should increase performance.  But for
> normal users it's simply not worth the risk, and if you do choose to use
> it, it's at your own risk.
Agreed, if you're running RAID0 with this many drives, nobarrier may be 
worth it for a little bit of extra performance.  It will make writes a 
bit faster, and make them have less impact on concurrent reads.
> 
> * If you're enabling the discard mount option, consider trying with it
> off, as it can affect performance if your devices don't support queued-
> trim.  The alternative is fstrim, presumably scheduled to run once a week
> or so.  (The util-linux package includes an fstrim systemd timer and
> service set to run once a week.  You can activate that, or equivalent
> cron job if you're not on systemd.)
Even if you have queued discard support, you may still be better off 
using fstrim instead.  While queuing discards reduces their performance 
impact, some device firmware still can't handle them efficiently. 
Pretty much, test both ways, see which works better for your workload.
> 
> * For filesystem features you may look at no_holes and skinny_metadata.
> These are both quite stable and at least skinny-metadata is now the
> default.  These are normally set at mkfs.btrfs time, but can be modified
> later.  Setting at mkfs time should be more efficient.
> 
> * At mkfs.btrfs time, you can set metadata --nodesize.  The newer default
> is 16 KiB, while the old default was the (minimum for amd64/x86) 4 KiB,
> and the maximum is 64 KiB.  See the mkfs.btrfs manpage for the details as
> there's a tradeoff, smaller sizes increase (metadata) fragmentation but
> decrease lock contention, while larger sizes pack more efficiently and
> are less fragmented but updating is more expensive.  The change in
> default was because 16 KiB was a win over the old 4 KiB for most use-
> cases, but the 32 or 64 KiB options may or may not be, depending on use-
> case, and of course if you're bottlenecking on locks, 4 KiB may still be
> a win.
One caveat here, if you're running on top of another RAID platform, you 
can often get a small performance boost by matching the node size to the 
chunks size for the underlying RAID layer (so, the chunk size that 
replication is done at for replicated RAID, or the amount of data per 
disk per stripe for striped stuff).
> 
> 
> Among all those, I'd be especially interested in what thread_pool=n does
> or doesn't do for you, both because it specifically mentions
> parallelization and because I've seen little discussion of it.
There's been little discussion because the default value that gets 
selected is actually near optimal in all but the largest systems.  The 
default logic is to set this to either the total number of logical cores 
in the system or 8, whichever is less.  What this does is actually 
rather simple, it's functionally the maximum number of I/O requests that 
can be processed concurrently by BTRFS for that volume.

Now, in theory it might sound like increasing this should improve things 
here.  The problem with that is that beyond about 8 requests, you start 
to see the effects of lock contention a _lot_ more.  If you can find a 
way to mitigate the locking issues (check the end of my reply for more 
about that), bumping this up _might_ help, but it generally should still 
not be more than the number of logical cores in the system (I've done 
some testing myself, no matter how well you have lock contention 
mitigated, performance gains are at best negligible from using more 
threads than logical cores, and at worst you'll make performance 
significantly worse).
> 
> space_cache=v2 may also be a big boost for you, if you're filesystems are
> the size the 6-device raid0 implies and are at all reasonably populated.
> 
> (Metadata) nodesize may or may not make a difference, tho I suspect if so
> it'll be mostly on writes (but I'm not familiar with the specifics there
> so could be wrong).  I'd be interested to see if it does.
> 
> In general I can recommend the no_holes and skinny_metadata features but
> you may well already have them, and the noatime mount option, which you
> may well already be using as well.  Similarly, I ensure that all my btrfs
> are mounted from first mount with autodefrag, so it's always on as the
> filesystem is populated, but I doubt you'll see a difference from that in
> your benchmarks unless you're specifically testing an aged filesystem
> that would be heavily fragmented on its own.
> 
> 
> There's one guy here who has done heavy testing on the ssd stuff and
> knows btrfs on-device chunk allocation strategies very well, having come
> up with a utilization visualization utility and been the force behind the
> relatively recent (4.16-ish) changes to the ssd mount option's allocation
> strategy.  He'd be the one to talk to if you're considering diving into
> btrfs' on-disk allocation code, etc.

There are two other recommendations I would make:

* Stupid as it sounds, depending on your workload, you may actually see 
better performance with the single profile than the raid0 profile. 
Essentially, if you've got mostly big files that would span multiple 
devices in raid0 mode and you don't have a workload that needs 
concurrent access to the same file regularly, you can reduce contention 
for access to each individual device by running with the data profile 
set to single.

* If you can find some way to logically subdivide your workload, you 
should look at creating one subvolume per subdivision.  This will reduce 
lock contention (and thus make bumping up the `thread_pool` option 
actually have some benefits).
