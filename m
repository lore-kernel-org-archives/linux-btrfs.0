Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45914 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932729AbcGKRbL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 13:31:11 -0400
Subject: Re: stat() on btrfs reports the st_blocks with delay (data loss in
 archivers)
To: <dsterba@suse.cz>, Pavel Raiskup <praiskup@redhat.com>,
        <linux-btrfs@vger.kernel.org>, bug-tar <bug-tar@gnu.org>
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
 <20160711144119.GY13336@twin.jikos.cz>
 <67a9457e-3925-e6b3-65db-ff30c6386678@fb.com>
 <20160711151620.GZ13336@twin.jikos.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <f1b987b5-f060-fd79-eef4-99658cc35049@fb.com>
Date: Mon, 11 Jul 2016 13:30:58 -0400
MIME-Version: 1.0
In-Reply-To: <20160711151620.GZ13336@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/11/2016 11:16 AM, David Sterba wrote:
> On Mon, Jul 11, 2016 at 11:00:55AM -0400, Chris Mason wrote:
>> So, the real bug is that we're letting some delalloc stat hang around
>> after the truncate, probably related to IO in progress.  We do already
>> account for delalloc in what we return to stat, but there's a corner
>> case involving truncate where we screw it up.
>
> So the original testcase:
>
>>>>     a) some "tool" creates sparse file
>>>>     b) that tool does not sync explicitly and exits ..
>>>>     c) tar is called immediately after that to archive the sparse file
>>>>     d) tar considers [2] the file is completely sparse (because st_blocks is
>>>>        zero) and archives no data.  Here comes data loss.
>
> will not happen. The application would basically have to mimick the
> provided reproducer script and do the truncate/write loop and be lucky
> enough to let tar hit the short race window.
>

Looking harder there is a race window that can trigger this without the 
truncate loop:

1) application calls write(), we make the pages delalloc (in-ram 
st_blocks goes up)
2) VM calls write_cache_pages, we go find a contiguous delalloc range
3) We call cow_file_range on the locked range of pages
4) cow_file_range clears the delalloc bits (in-ram st_blocks goes down)

< ----- race begins here ----->

5) The io is started
6) The IO completes and extents are inserted into the metadata
7) the on disk/in-ram st_blocks goes up

< ---- race ends here ---->

This makes a ton more sense than leaking delalloc bits.

-chris
