Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from manchmal.in-ulm.de ([217.10.9.201]:57074 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964992AbbLRUiH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Dec 2015 15:38:07 -0500
Date: Fri, 18 Dec 2015 21:38:04 +0100
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: ERROR: scrubbing <dev> failed for device id 1: ret=-1, errno=28
 (No space left on device)
Message-ID: <1450469988@msgid.manchmal.in-ulm.de>
References: <1450423394@msgid.manchmal.in-ulm.de>
 <CAPmG0jZYidy-ra-R-C5GQNQhUZeVSB6anCg7N9sFSY5NrrO61w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPmG0jZYidy-ra-R-C5GQNQhUZeVSB6anCg7N9sFSY5NrrO61w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager wrote...

> you need to do some balancing, as I think that the free space is too
> fragmented and the system fails to allocate extra metadata space
> needed for scrub doing writes into metadata.
> 
> # btrfs balance start -dusage=<number>
> with number somewhere between 5 and 50; first start with lower number
> and repeat and increase until the 5.17GiB gets closer down to the
> 3.75GiB

Thanks, that one worked with number 100. Still some ENOSPC errors but
appeareantly good enough to make scrubbing work.

> The issue is that for for a filesystem of this size (6.5GiB), it would
> have been better to have mixed data/metadata allocation. See help of
> mkfs.btrfs. So maybe you want to recreate the fs like that, otherwise
> you might easily hit this problem again if you don't monitor free
> space / balance regularly.

Will keep that in mind. Just out of curiousity: Initially, the file
system size was just 4 Gibyte. Is it possible this made things worse?


Oh, and by the way:

--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -77,7 +77,7 @@ where the space is reserved for the other block group type, is not available for
 allocation and can lead to ENOSPC state.
 +
 The recommended size for the mixed mode is for filesystems less than 1GiB. The
-soft recommendation is to use it for filesystems smaller than 5GiB. Thie mixed
+soft recommendation is to use it for filesystems smaller than 5GiB. The mixed
 mode may lead to degraded performance on larger filesystems, but is otherwise
 usable, even on multiple devices.
 +


    Christoph
