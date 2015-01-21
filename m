Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:63440 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbbAUED5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 23:03:57 -0500
Received: by mail-yk0-f171.google.com with SMTP id 10so5621173ykt.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jan 2015 20:03:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO-oUUQhfJ_LnwaQmr_-sJK_oTCE89R11N3kM-vj-Gv6Wg@mail.gmail.com>
References: <CA+WRLO9nCFgjHzY1F_xR5PpmgaSEemfmZ=MtiSpiaHcROQnq-A@mail.gmail.com>
	<CA+WRLO8gGUxxHhqQfgQWXyU0kT2=nf7u5oPFYJTWY=hSMNBj=w@mail.gmail.com>
	<CAJCQCtRe+0n84PUZuWKw0UUwK_RF_AhW4sMZ+07r96qaNvRWKg@mail.gmail.com>
	<CA+WRLO-VnULLGOE1VkrOortCdQNCKPCwJ70FDJL3KQwru8TLhQ@mail.gmail.com>
	<CAJCQCtQQnovS94fo-hRQa_O6Q7EM9KOCPFxC3FTkTC4=CT93sA@mail.gmail.com>
	<CA+WRLO89nFArYhRgjqPBruW0avExOZcf9iZgvusLAr_+4ddxoQ@mail.gmail.com>
	<CAJCQCtTiboWRVkZLE2Te9Kb00SXxUk0_AwE5xv-vTHxrpaDCqA@mail.gmail.com>
	<CA+WRLO-oUUQhfJ_LnwaQmr_-sJK_oTCE89R11N3kM-vj-Gv6Wg@mail.gmail.com>
Date: Tue, 20 Jan 2015 21:03:56 -0700
Message-ID: <CAJCQCtRZy3Pi5CF4a9CfQSzmFm9poumJhBZaSRixRrpqsBPk_g@mail.gmail.com>
Subject: Re: btrfs convert running out of space
From: Chris Murphy <lists@colorremedies.com>
To: Gareth Pye <gareth@cerberos.id.au>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 20, 2015 at 4:04 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
> Yeah, we don't have that much space spare :(
>
> File system has been going strong from when it was created with early
> RAID5 code, then converted to RAID10 with kernel 3.12.
>
> There aren't any nocow files to my knowledge but there are plenty of
> files larger than a gig on the file system. The first few results from
> logical-resolve have been for files in the 1G~2G range, so that could
> be some sticky spaghetti.

Are any of those big files in a snapshot? The snapshotting may be
pinning a bunch of large extents, so even if it seems like the volume
has enough space, it might actually be running out of space. All I can
think of is progressively removing the files that are implicated in
the conversion failure. That could mean just deleting older snapshots
that you probably don't need, progressively getting to the point where
you migrate those files off this fs to another one, and then delete
them (all instances in all subvol/snapshots) and just keep trying.

Is a btrfs check happy? Or does it complain about anything?

I've had quite good luck just adding a drive (two drives for raid1/10
volumes) to an existing btrfs volume, they don't have to be drdb, they
can be local block devices, either physical drives or LV's. I've even
done this with flash drives (kinda scary and slow but it worked).

I'd still suggest contingency planning in case this volume becomes
temperamental and you have no choice but to migrate it elsewhere.
Better to do it on your timetable than the filesystem's.

-- 
Chris Murphy
