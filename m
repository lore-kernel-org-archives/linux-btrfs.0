Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36324 "EHLO
        mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161744AbcIZRwZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 13:52:25 -0400
Received: by mail-pa0-f48.google.com with SMTP id qn7so47749284pac.3
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Sep 2016 10:52:24 -0700 (PDT)
Date: Mon, 26 Sep 2016 10:52:22 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [PATCH v2 3/6] Btrfs: catch invalid free space trees
Message-ID: <20160926175222.GD31938@vader.DHCP.thefacebook.com>
References: <cover.1474580472.git.osandov@fb.com>
 <1381db7b5de30b8ea0d2e87aff26bfdb83b030e7.1474580472.git.osandov@fb.com>
 <32fd73be-8b59-7df0-177d-4a2900522f18@mendix.com>
 <20160926173916.GB31938@vader.DHCP.thefacebook.com>
 <81a752ae-b9d8-50a7-d533-975d89ae01d8@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <81a752ae-b9d8-50a7-d533-975d89ae01d8@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 26, 2016 at 07:46:02PM +0200, Hans van Kranenburg wrote:
> On 09/26/2016 07:39 PM, Omar Sandoval wrote:
> > On Sat, Sep 24, 2016 at 09:50:53PM +0200, Hans van Kranenburg wrote:
> >> On 09/23/2016 02:24 AM, Omar Sandoval wrote:
> >>> From: Omar Sandoval <osandov@fb.com>
> >>>
> >>> There are two separate issues that can lead to corrupted free space
> >>> trees.
> >>>
> >>> 1. The free space tree bitmaps had an endianness issue on big-endian
> >>>    systems which is fixed by an earlier patch in this series.
> >>> 2. btrfs-progs before v4.7.3 modified filesystems without updating the
> >>>    free space tree.
> >>>
> >>> To catch both of these issues at once, we need to force the free space
> >>> tree to be rebuilt. To do so, add a FREE_SPACE_TREE_VALID compat_ro bit.
> >>> If the bit isn't set, we know that it was either produced by a broken
> >>> big-endian kernel or may have been corrupted by btrfs-progs.
> >>
> >> This tekst will be read by anyone git blaming the source to find out
> >> what FREE_SPACE_TREE_VALID does, and maybe to find an answer to why
> >> their filesystem just got corrupted after using progs < v4.7.3, even if
> >> they run a new kernel which knows about this bit.
> >>
> >> Since the above text suggests this situation can be dealt with, the text
> >> is a bit misleading/incomplete. The construction with the bit requires
> >> active cooperation from whatever external tool that is changing the fs,
> >> to also flip this bit, to keep the filesystem from subsequently
> >> corrupting itself.
> >>
> >> So, starting to use this bit can only detect corruption by btrfs-progs
> >> before v4.7.3 once, and only exactly once.
> >>
> >> My suggestion is to just add a sentence like the following after "[...]
> >> may have been corrupted by btrfs-progs.": "Caution: Since btrfs-progs
> >> before v4.7.3 will not clear this bit after modifying the filesystem,
> >> keeping to use these older versions will again result in an inconsistent
> >> free space tree, without having an ability to detect this."
> > 
> > Like I mentioned in the cover letter of the series, btrfs-progs won't
> > touch filesystems with the new bit set:
> > 
> > ┌[root@silver ~]
> > └# btrfs --version
> > btrfs-progs v4.7.2
> > ┌[root@silver ~]
> > └# btrfstune -x /dev/vdb1
> > couldn't open RDWR because of unsupported option features (2).
> > Open ctree failed
> > 
> > That's the point of compat bits. They're a whitelist rather than a
> > blacklist, and until we explicitly update btrfs-progs to allow that bit,
> > it will only allow read-only access.
> > 
> > What happened with the earlier FREE_SPACE_TREE compat_ro bit is that we
> > mistakenly added it to the mask of supported compat_ro bits before it
> > was safe to do so.
> 
> Aha! Now I see. If it sees something from the future, it just thinks:
> "whoa, not going to touch this".

Exactly.

> Thanks for your patience. :)

Thanks for taking a look :)

-- 
Omar
