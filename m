Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:36544 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbbIPLfp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 07:35:45 -0400
Received: by vkfp126 with SMTP id p126so98604527vkf.3
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 04:35:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net>
References: <55F88ECC.1040604@menke.ac>
	<pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net>
Date: Wed, 16 Sep 2015 12:35:44 +0100
Message-ID: <CA+BsyQ44kPzk1txVUro7vv2=CH6SF3=9zoSkpMVmqnjtuws5Zw@mail.gmail.com>
Subject: Re: BTRFS as image store for KVM?
From: Brendan Heading <brendanheading@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Btrfs has two possible solutions to work around the problem.  The first
> one is the autodefrag mount option, which detects file fragmentation
> during the write and queues up the affected file for a defragmenting
> rewrite by a lower priority worker thread.  This works best on the small
> end, because as file size increases, so does time to actually write it
> out, and at some point, depending on the size of the file and how busy
> the database/VM is, writes are (trying to) come in faster than the file
> can be rewritten.  Typically, there's no problem under a quarter GiB,
> with people beginning to notice performance issues at half to 3/4 GiB,
> tho on fast disks and not too busy VMs/DBs (which may well include your
> home system, depending on what you use the VMs for), you might not see
> problems until size reaches 2 GiB or so.  As such, autodefrag tends to be
> a very good option for firefox sqlite database files, for instance, as
> they tend to be small enough not to have issues.  But it's not going to
> work so well for multi-GiB VM images.

[unlurking for the first time]

This problem has been faced by a certain very large storage vendor
whom I won't name, who provide an option similar to the above. Reading
between the lines I think their approach is to try to detect which
accesses are read-sequential, and schedule those blocks for rewriting
in sequence. They also have a feature to run as a background job which
can be scheduled to run during an off peak period where they can
reorder entire files that are significantly out of sequence. I'd
expect the algorithm is intelligent ie there's no need to rewrite
entire large files that are mostly sequential with a few out-of-order
sections.

Has anyone considered these options for btrfs ? Not being able to run
VMs on it is probably going to be a bit of a killer ..

regards

Brendan
