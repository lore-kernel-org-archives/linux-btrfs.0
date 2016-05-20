Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33474 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbcETKhj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 06:37:39 -0400
Received: by mail-oi0-f43.google.com with SMTP id v145so172222877oie.0
        for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 03:37:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160519234815.GH21200@dastard>
References: <CAJfpeguD-S=CEogqcDOYAYJBzfyJG=MMKyFfpMo55bQk7d0_TQ@mail.gmail.com>
	<20160519090521.GA26114@dhcp22.suse.cz>
	<CAJfpegvqPrP=AtaOSwMX1s=-oVAEE97NMwEHUkg93dBWvOykHw@mail.gmail.com>
	<20160519234815.GH21200@dastard>
Date: Fri, 20 May 2016 12:37:37 +0200
Message-ID: <CAJfpegvH1jSF-sHk-AAYtF_nip8DN_Y3-FDLmnJVtkUGA2vdtQ@mail.gmail.com>
Subject: Re: sharing page cache pages between multiple mappings
From: Miklos Szeredi <miklos@szeredi.hu>
To: Dave Chinner <david@fromorbit.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 20, 2016 at 1:48 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, May 19, 2016 at 12:17:14PM +0200, Miklos Szeredi wrote:
>> On Thu, May 19, 2016 at 11:05 AM, Michal Hocko <mhocko@kernel.org> wrote:
>> > On Thu 19-05-16 10:20:13, Miklos Szeredi wrote:
>> >> Has anyone thought about sharing pages between multiple files?
>> >>
>> >> The obvious application is for COW filesytems where there are
>> >> logically distinct files that physically share data and could easily
>> >> share the cache as well if there was infrastructure for it.
>> >
>> > FYI this has been discussed at LSFMM this year[1]. I wasn't at the
>> > session so cannot tell you any details but the LWN article covers it at
>> > least briefly.
>>
>> Cool, so it's not such a crazy idea.
>
> Oh, it most certainly is crazy. :P
>
>> Darrick, would you mind briefly sharing your ideas regarding this?
>
> The current line of though is that we'll only attempt this in XFS on
> inodes that are known to share underlying physical extents. i.e.
> files that have blocks that have been reflinked or deduped.  That
> way we can overload the breaking of reflink blocks (via copy on
> write) with unsharing the pages in the page cache for that inode.
> i.e. shared pages can propagate upwards in overlay if it uses
> reflink for copy-up and writes will then break the sharing with the
> underlying source without overlay having to do anything special.
>
> Right now I'm not sure what mechanism we will use - we want to
> support files that have a mix of private and shared pages, so that
> implies we are not going to be sharing mappings but sharing pages
> instead.  However, we've been looking at this as being completely
> encapsulated within the filesystem because it's tightly linked to
> changes in the physical layout of the filesystem, not as general
> "share this mapping between two unrelated inodes" infrastructure.
> That may change as we dig deeper into it...
>
>> The use case I have is fixing overlayfs weird behavior. The following
>> may result in "buf" not matching "data":
>>
>>     int fr = open("foo", O_RDONLY);
>>     int fw = open("foo", O_RDWR);
>>     write(fw, data, sizeof(data));
>>     read(fr, buf, sizeof(data));
>>
>> The reason is that "foo" is on a read-only layer, and opening it for
>> read-write triggers copy-up into a read-write layer.  However the old,
>> read-only open still refers to the unmodified file.
>>
>> Fixing this properly requires that when opening a file, we don't
>> delegate operations fully to the underlying file, but rather allow
>> sharing of pages from underlying file until the file is copied up.  At
>> that point we switch to sharing pages with the read-write copy.
>
> Unless I'm missing something here (quite possible!), I'm not sure
> we can fix that problem with page cache sharing or reflink. It
> implies we are sharing pages in a downwards direction - private
> overlay pages/mappings from multiple inodes would need to be shared
> with a single underlying shared read-only inode, and I lack the
> imagination to see how that works...

Indeed, reflink doesn't make this work.

We could reflink-up on any open (or on lookup), not just on write,
it's a trivial change in overlayfs.   Drawback is slower first
open/lookup and space used by duplicate trees even without
modification on the overlay.  Not sure if that's a problem in
practice.

I'll think about the generic downwards sharing.  For overlayfs it
doesn't need to be per-page, so that might make it somewhat simpler
problem.

Thanks,
Miklos
