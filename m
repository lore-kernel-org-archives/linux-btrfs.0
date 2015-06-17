Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:36291 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431AbbFQO6T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 10:58:19 -0400
Received: by ykdr198 with SMTP id r198so42120047ykd.3
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 07:58:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150617071654.GI16468@merlins.org>
References: <20150617071654.GI16468@merlins.org>
Date: Wed, 17 Jun 2015 08:58:18 -0600
Message-ID: <CAJCQCtRwy_beFwAH8=WV0VpVW3295rB4UY6WQ0ZJf+bXynuXnw@mail.gmail.com>
Subject: Re: BTRFS: read error corrected: ino 1 off 226840576 (dev
 /dev/mapper/dshelf1 sector 459432)
From: Chris Murphy <lists@colorremedies.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 17, 2015 at 1:16 AM, Marc MERLIN <marc@merlins.org> wrote:

> So I can understand how I may have had a few blocks that are in a bad
> state.
> I'm getting a few (not many) of those messages in syslog.
> BTRFS: read error corrected: ino 1 off 226840576 (dev /dev/mapper/dshelf1 sector 459432)

I think more information is needed at the time of this entry, maybe
the previous 20 entries or so. That Btrfs thinks there is a read error
is different than when it thinks there's a checksum error. For example
when I willfully corrupt one sector that I know contains metadata,
then read the file or do a scrub:

[48466.824770] BTRFS: checksum error at logical 20971520 on dev
/dev/sdb, sector 57344: metadata leaf (level 0) in tree 3
[48466.829900] BTRFS: checksum error at logical 20971520 on dev
/dev/sdb, sector 57344: metadata leaf (level 0) in tree 3
[48466.834944] BTRFS: bdev /dev/sdb errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[48466.853589] BTRFS: fixed up error at logical 20971520 on dev /dev/sdb


I'd expect in your case you have a bdev line that reads rd 1, corrupt 0.


> Just to make sure I understand, do those messages in syslog mean that my
> metadata got corrupted a bit, but because I have 2 copies, btrfs can fix
> the bad copy by using the good one?

Probably but not enough information has been given to conclude that.


> Also, if my actual data got corrupted, am I correct that btrfs will
> detect the checksum failure and give me a different error message of a
> read error that cannot be corrected?

Yes, it looks like this when the file is directly read:

[ 1457.231316] BTRFS warning (device sdb): csum failed ino 257 off 0
csum 3703877302 expected csum 1978138932
[ 1457.231842] BTRFS warning (device sdb): csum failed ino 257 off 0
csum 3703877302 expected csum 1978138932

It looks like this during a scrub:

[ 1540.865520] BTRFS: checksum error at logical 12845056 on dev
/dev/sdb, sector 25088, root 5, inode 257, offset 0, length 4096,
links 1 (path: grub2-install)
[ 1540.865534] BTRFS: bdev /dev/sdb errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[ 1540.866944] BTRFS: unable to fixup (regular) error at logical
12845056 on dev /dev/sdb


-- 
Chris Murphy
