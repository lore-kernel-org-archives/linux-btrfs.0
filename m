Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852Ab3KZPF1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 10:05:27 -0500
Message-ID: <5294B8B4.5030407@redhat.com>
Date: Tue, 26 Nov 2013 09:05:24 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs tagged as v3.12
References: <20131125214534.8160.40797@ret.masoncoding.com>
In-Reply-To: <20131125214534.8160.40797@ret.masoncoding.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/25/13, 3:45 PM, Chris Mason wrote:
> Hi everyone,
> 
> I've tagged the current btrfs-progs repo as v3.12.  The new idea is that
> instead of making the poor distros pull from git, I'll be creating
> tagged releases at roughly the same pace as Linus cuts kernels.
> 
> Given the volume of btrfs-progs patches, we should have enough new code
> and fixes to justify releases at least as often as the kernel.  Of
> course, if there are issues that need immediate attention, I'll tag a .y
> release (v3.12.1 for example).
> 
> If the progs changes slow down, we might skip a version.  But tracking
> kernel version numbers makes it easier for me to line up bug reports,
> mostly because I already devote a fair number of brain cells to
> remembering how old each kernel is.
> 
> Just let me know if there are any questions.

Cool!  I've built it for Fedora 19, 20, and rawhide, updates should
trickle out soon.

-Eric

