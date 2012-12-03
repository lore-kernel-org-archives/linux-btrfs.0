Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab2LCLfs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Dec 2012 06:35:48 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 8EFE6A4FFA
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Dec 2012 12:35:47 +0100 (CET)
Date: Mon, 3 Dec 2012 12:35:47 +0100
From: Arvin Schnell <aschnell@suse.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Snapper snapshot comparison algorithm - send/receive questions
Message-ID: <20121203113547.GA19321@suse.de>
References: <CAFhuFEdxHxdiAutfxxsQ9i0OJj_CfRwWD-0LuhvoJYGHkTsG4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <CAFhuFEdxHxdiAutfxxsQ9i0OJj_CfRwWD-0LuhvoJYGHkTsG4A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 01, 2012 at 01:24:20PM +0530, nafisa mandliwala wrote:

> I needed help with understanding the snapshot comparison algorithm
> that snapper uses and its shortcomings. From reading the code, what I
> understood is that it does a block by block compare. I'm not very sure
> if that's the best way to go about it. Also, since the send receive
> code is still in development stages, is there a scope to add more
> functionality to it?

Mainly snapper does a directory traversal and a block-by-block
comparison of files which is indeed a inefficient comparison
algorithm.

I already had a look at using the new send/receive ioctl to
improve the comparison and have a few question:

1. snapper only needs to know that a file has changed but the
   send stream also contains the new content which might has to
   be read from disk.

   Mark Fasheh has made a patch for a flag for the send ioctl to
   not include the content (don't know if he posted it here since
   I was kicked of the list twice). With no write commands in the
   stream how can I detect a file content change? Currently there
   seems to be a truncate after the write but is that guaranteed?

   Btw: There are many apparently useless truncates, e.g. after a
   chmod. What are these good for?

2. Is it possible to add a ioctl for send that takes open
   file-descriptors for parent_root and clone_sources? Otherwise
   it's insecure to use from snapper (which has root privileges
   and sometimes operates in directories users can modify). Such
   a ioctl would also reduce the number of btrfs related
   functions needed.

3. Overall lots of functions are needed to use the
   send/receive. Are there any plans to create a btrfs-library
   that contains the required functions
   e.g. btrfs_read_and_process_send_stream, subvol_uuid_search
   and tree_search?

Regards,
  Arvin

-- 
Arvin Schnell, <aschnell@suse.de>
Senior Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg)
Maxfeldstraße 5
90409 Nürnberg
Germany
