Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511Ab3AWQDQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 11:03:16 -0500
Date: Wed, 23 Jan 2013 17:03:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Racz Zoli <racz.zoli@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: File system development question
Message-ID: <20130123160314.GK28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CANoGd8=7Q=1yDiQxhkwQiNSf2d78p85AN-kkEn=i_2Vsat6paA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANoGd8=7Q=1yDiQxhkwQiNSf2d78p85AN-kkEn=i_2Vsat6paA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 22, 2013 at 11:39:31PM +0200, Racz Zoli wrote:
> Can somebody help me with links to documentations, books or howtos
> about how and where to start file system development in linux? It
> doesn`t necessarily need to contain a full source code. I don`t want
> to only copy paste somebody else`s code, and voila, I`m a kernel
> developer. I would like to understand step by step how the vfs api is
> actually working, how to do things, and maybe in the future to be able
> to write my own file system, or to contribute to an existing one.

You may find this book useful

Practical File System Design: The Be File System
http://www.nobius.org/~dbg/practical-file-system-design.pdf

or for specific topics

Understanding the Linux Kernel
http://ceata.org/~tct/resurse/utlk.pdf

Where the APIs changed, look into existing implementations, I don't know
about any book that describes recent status of linux internals.

david
