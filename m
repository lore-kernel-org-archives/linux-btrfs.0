Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:51992 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbbGIUm4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jul 2015 16:42:56 -0400
Date: Thu, 9 Jul 2015 14:42:55 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Grimshaw <grimshaw@linux.vnet.ibm.com>
Cc: dsterba@suse.cz, jbacik@fb.com, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-doc@vger.kenrel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: filesystems: btrfs: Fixed typos and
 whitespace
Message-ID: <20150709144255.31bfa0e0@lwn.net>
In-Reply-To: <201507081744.t68HipCa005698@oc0285321175.ibm.com>
References: <201507081744.t68HipCa005698@oc0285321175.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 08 Jul 2015 10:44:51 -0700
Daniel Grimshaw <grimshaw@linux.vnet.ibm.com> wrote:

> I am a high school student trying to become familiar with
> Linux kernel development. The btrfs documentation in
> Documentation/filesystems had a few typos and errors in
> whitespace. This patch corrects both of these.
> 
> This is a resend of an earlier patch with corrected patchfile.

Applied to the docs tree, thanks.

Just FYI, if you put lines like the last one above after the '---' line,
they won't find their way into the commit changelog, which is
preferable.  I edited it out.

jon
