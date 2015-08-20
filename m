Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:36175 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbbHTBzo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 21:55:44 -0400
Received: by vkif69 with SMTP id f69so4332793vki.3
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2015 18:55:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D3CC3E72-929E-4ADF-826F-62DCB6BD827C@lime-technology.com>
References: <D3CC3E72-929E-4ADF-826F-62DCB6BD827C@lime-technology.com>
Date: Wed, 19 Aug 2015 19:55:43 -0600
Message-ID: <CAJCQCtSVn7BSYY=Ofq6OsKfHyv_PTKGOg7uP=tUC4XTNQ42v0w@mail.gmail.com>
Subject: Re: Questions on use of NOCOW impact to subvolumes and snapshots
From: Chris Murphy <lists@colorremedies.com>
To: Jonathan Panozzo <jonp@lime-technology.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 19, 2015 at 6:44 PM, Jonathan Panozzo
<jonp@lime-technology.com> wrote:
> Hello btrfs mailing list!
>
> I have a two questions regarding the use of the NOCOW bit and how this affects scrub and snapshots.
>
> Question 1:  If I apply the NOCOW attribute to a file or directory, how does that affect my ability to run btrfs scrub?

nodatacow includes nodatasum and no compression. So it means these
files are presently immune from scrub check and repair so long as it's
based on checksums. I don't know if raid56 scrub compares to parity
and recomputes parity (assumes data is correct), absent checksums,
which would be similar to how md raid 56 does it.


> Question 2:  If I apply the NOCOW attribute recursively to a btrfs subvolume I create,

There's no such thing as recursive application of this xattr to files.
Recursivity would only apply to directories (and probably nested
subvolumes but I haven't tested it).


> then take a snapshot of that subvolume, make changes to the files in the snapshot, and then make changes to the files in the subvolume, does this cause data in the snapshot to be corrupted?  It doesn’t appear so, but I’m confused how it’s not if COW has been disabled using the NOCOW bit.

http://www.spinics.net/lists/linux-btrfs/msg31342.html

Any changes to a snapshot nocow file are cow. Any additional changes
to those extents are nocow until those extents are likewise snapshot
(by the file being reflink copied or subvolume is snapshot). So if the
change to an extent will only affect a particular instance of a nocow
file, the write is overwrite (nocow). If it's a shared extent, then
the write is cow, and that extent is (initially) not shared and thus
additional writes are nocow.


-- 
Chris Murphy
