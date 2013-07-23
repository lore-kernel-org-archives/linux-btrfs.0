Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:50288 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab3GWQGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 12:06:11 -0400
Received: by mail-oa0-f41.google.com with SMTP id n10so11841943oag.28
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 09:06:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3DF45F2F-A56D-4302-AB84-31A6A3084A39@vanrein.org>
References: <3DF45F2F-A56D-4302-AB84-31A6A3084A39@vanrein.org>
Date: Tue, 23 Jul 2013 10:06:10 -0600
Message-ID: <CAE5mzvj_f2GDYiE=RVhppfhXK+0vCindPROJA6g+XoumSBmYUA@mail.gmail.com>
Subject: Re: Manual deduplication would be useful
From: cwillu <cwillu@cwillu.com>
To: Rick van Rein <rick@vanrein.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 23, 2013 at 9:47 AM, Rick van Rein <rick@vanrein.org> wrote:
> Hello,
>
> For over a year now, I've been experimenting with stacked filesystems as a way to save on resources.  A basic OS layer is shared among Containers, each of which stacks a layer with modifications on top of it.  This approach means that Containers share buffer cache and loaded executables.  Concrete technology choices aside, the result is rock-solid and the efficiency improvements are incredible, as documented here:
>
> http://rickywiki.vanrein.org/doku.php?id=openvz-aufs
>
> One problem with this setup is updating software.  In lieu of stacking-support in package managers, it is necessary to do this on a per-Container basis, meaning that each installs their own versions, including overwrites of the basic OS layer.  Deduplication could remedy this, but the generic mechanism is known from ZFS to be fairly inefficient.
>
> Interestingly however, this particular use case demonstrates that a much simpler deduplication mechanism than normally considered could be useful.  It would suffice if the filesystem could check on manual hints, or stack-specifying hints, to see if overlaid files share the same file contents; when they do, deduplication could commence.  This saves searching through the entire filesystem for every file or block written.  It might also mean that the actual stacking is not needed, but instead a basic OS could be cloned to form a new basic install, and kept around for this hint processing.
>
> I'm not sure if this should ideally be implemented inside the stacking approach (where it would be stacking-implementation-specific) or in the filesystem (for which it might be too far off the main purpose) but I thought it wouldn't hurt to start a discussion on it, given that (1) filesystems nowadays service multiple instances, (2) filesystems like Btrfs are based on COW, and (3) deduplication is a goal but the generic mechanism could use some efficiency improvements.
>
> I hope having seen this approach is useful to you!
>
> Please reply-all?  I'm not on this list.
>
> Cheers,
>  -Rick--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

There's patches providing offline dedup (i.e., manually telling the
kernel which files to consider) floating around:
http://lwn.net/Articles/547542/
