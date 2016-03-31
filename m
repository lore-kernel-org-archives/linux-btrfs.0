Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f195.google.com ([209.85.217.195]:34430 "EHLO
	mail-lb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbcCaQrx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 12:47:53 -0400
MIME-Version: 1.0
In-Reply-To: <3E147309-67EA-4B29-B4E0-883BA03B7BFC@dilger.ca>
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
	<20160331003242.GA5813@localhost.localdomain>
	<20160331075529.GB4209@infradead.org>
	<3E147309-67EA-4B29-B4E0-883BA03B7BFC@dilger.ca>
Date: Thu, 31 Mar 2016 18:47:50 +0200
Message-ID: <CAPmG0jZEM0a7J1=LZMQ-Y6oM0BgB04uDKdb7MZgNso4QAt=mPA@mail.gmail.com>
Subject: Re: fallocate mode flag for "unshare blocks"?
From: Henk Slager <eye1tm@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Christoph Hellwig <hch@infradead.org>, Liu Bo <bo.li.liu@oracle.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 31, 2016 at 5:31 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Mar 31, 2016, at 1:55 AM, Christoph Hellwig <hch@infradead.org> wrote:
>>
>> On Wed, Mar 30, 2016 at 05:32:42PM -0700, Liu Bo wrote:
>>> Well, btrfs fallocate doesn't allocate space if it's a shared one
>>> because it thinks the space is already allocated.  So a later overwrite
>>> over this shared extent may hit enospc errors.
>>
>> And this makes it an incorrect implementation of posix_fallocate,
>> which glibcs implements using fallocate if available.
>
> It isn't really useful for a COW filesystem to implement fallocate()
> to reserve blocks.  Even if it did allocate all of the blocks on the
> initial fallocate() call, when it comes time to overwrite these blocks
> new blocks need to be allocated as the old ones will not be overwritten.

There are also use-cases on BTRFS with CoW disabled, like operations
on virtual machine images that aren't snapshotted.
Those files tend to be big and having fallocate() implemented and
working like for e.g. XFS, in order to achieve space and speed
efficiency, makes sense IMHO.
