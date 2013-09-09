Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807Ab3IIWuZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 18:50:25 -0400
Date: Tue, 10 Sep 2013 00:50:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Andy Grover <agrover@redhat.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>
Subject: Re: btrfs.h and btrfs-progs licensing
Message-ID: <20130909225023.GU32382@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <522E3A0E.6080504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <522E3A0E.6080504@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 09, 2013 at 02:13:50PM -0700, Andy Grover wrote:
> However, as it stands, the kernel's include/uapi/linux/btrfs.h and
> btrfs-progs are GPLv2, which means that a "libbtrfs" that is based on either
> of these might also be construed to need to be GPLv2, and any program
> *using* libbtrfs might also be construed to need to be GPLv2.

Looking at "nm libbtrfs.a" there are rbtree and crc32c symbols included
in the library, licensed under GPLv2, the rest is pure userspace code and
the people are around to ask about relicensing.

david
