Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:50193 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3GHVaj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jul 2013 17:30:39 -0400
Received: by mail-oa0-f50.google.com with SMTP id k7so6943103oag.23
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jul 2013 14:30:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130708211208.GF18204@twin.jikos.cz>
References: <CAMoswei+L-kH_O9uRecOorpS6Kf5hnZ9j3nxZ36kzFR6G9uXeg@mail.gmail.com>
	<20130708211208.GF18204@twin.jikos.cz>
Date: Mon, 8 Jul 2013 22:30:38 +0100
Message-ID: <CAMosweiZA75aN6--GdZqbTmg3HeaFGY8K+QUfJQZzopQhb_qfg@mail.gmail.com>
Subject: Re: Does balance implicitly defrag?
From: Paul Richards <paul.richards@gmail.com>
To: dsterba@suse.cz, Paul Richards <paul.richards@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8 July 2013 22:12, David Sterba <dsterba@suse.cz> wrote:
> On Tue, Jul 02, 2013 at 02:28:25PM +0100, Paul Richards wrote:
>> When I run "btrfs filesystem balance", does this implicitly
>> defragment the filesystem?  (Assuming there is plenty free space)
>
> In some sense it defragments the filesystem. The blockgroups are moved
> around based on the balance filter. Here a blockgroup consists of
> various and unrelated file extents. Extents representing a single file
> are not made contiguous, this is done by 'btrfs file defrag'.
>
> I think that the final layout of the 1G-chunks is not necessarily
> contiguous, ie. it depends on the chunk-allocator, the time of the
> allocation request and there's nothing like "preallocate 30G for whole
> balance and put all data together because the space is available".
>

Okay, I think I understand.  It sounds like balance will fix external
fragmentation (within the block groups, up to the 1G-chunk
granularity), and will not fix any internal fragmentation.

Thanks. :)




--
Paul Richards
@pauldoo
