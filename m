Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab3J3Py4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Oct 2013 11:54:56 -0400
Date: Wed, 30 Oct 2013 16:54:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: swapfile on btrfs, temporary solution for wiki
Message-ID: <20131030155453.GA8516@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAGqmi74OvQ=BFroP+QCf6eUtc61__LYRGtZJNcPz1XrSWX-q_w@mail.gmail.com>
 <CAGqmi74F9GurJL73qtU4JG+Fi4RbXE7tiaO1uEQqEY2ym278eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGqmi74F9GurJL73qtU4JG+Fi4RbXE7tiaO1uEQqEY2ym278eA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 24, 2013 at 11:52:01PM +0300, Timofey Titovets wrote:
> Hello, i suggest temporary solution to use swap file under btrfs.
> I test it, and it work good.
> 
> I invent simple the way, how create and using swap file, just see
> following sh code:
> 
> swapfile=$(losetup -f) #free loop device
> truncate -s 8G /swap   #create 8G sparse swap file

I'd suggest to do full dd on that file and make it NOCOW first. That way
it should minimize attempts to actually allocate the file blocks at the
time they're needed for swap out.

Also a bit of stress testing that this actually works is needed.

> losetup $swapfile /swap #mount file to loop
> mkswap  $swapfile
> swapon  $swapfile


david
