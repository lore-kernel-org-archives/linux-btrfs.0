Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:47993 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933516AbbGHQiZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jul 2015 12:38:25 -0400
Date: Wed, 8 Jul 2015 10:38:24 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Grimshaw <grimshaw@linux.vnet.ibm.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Documentation: filesystems: btrfs: Fixed typos and whitespace
Message-ID: <20150708103824.3569b16f@lwn.net>
In-Reply-To: <559D402C.2040205@linux.vnet.ibm.com>
References: <559D402C.2040205@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 08 Jul 2015 08:22:20 -0700
Daniel Grimshaw <grimshaw@linux.vnet.ibm.com> wrote:

> I am a high school student trying to become familiar with Linux kernel
> development.

That's great!

> The btrfs documentation in Documentation/filesystems had a
> few typos and errors in whitespace. This patch corrects both of these.

So I went to apply this patch to the docs tree, but it fails to apply due
to whitespace problems of its own; something has corrupted your patch on
its way out to the mailing list.

Can I ask you to fix up your email client so that it doesn't do this?
Please have a look at Documentation/email-clients.txt for some hints; in
particular, there are things that can be done to bludgeon Thunderbird
(which you appear to be using) into a more cooperative state of mind.
Once you've done that, send the patch to yourself and try to apply the
result; after that works, please resubmit your patch here.

One comment, though: "checksum" (or "checksumming") is pretty standard
usage and shouldn't really be "fixed".

Thanks,

jon
