Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964AbaCLLPJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 07:15:09 -0400
Date: Wed, 12 Mar 2014 12:15:07 +0100
From: David Disseldorp <ddiss@suse.de>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Avi Miller <avi.miller@oracle.com>, Lists <lists@benjamindsmith.com>,
        linux-btrfs@vger.kernel.org
Subject: xfstests btrfs/035 (was Re: Testing BTRFS)
Message-ID: <20140312121507.1f4e7f9b@plati.site>
In-Reply-To: <531F5F12.4080009@redhat.com>
References: <loom.20140306T191655-366@post.gmane.org>
	<pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>
	<loom.20140307T144540-512@post.gmane.org>
	<pan$72cea$1961f20d$d4386bc$889c1510@cox.net>
	<531E5B44.6030502@benjamindsmith.com>
	<DFAE9B5E-2C12-4215-B4CA-016CBD4575EC@oracle.com>
	<531F5F12.4080009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Eric,

On Tue, 11 Mar 2014 14:08:02 -0500, Eric Sandeen wrote:

> Indeed, testing 3.8.13-26.2.1.el6uek.x86_64 (which is, I believe,
> the kernel which Avi referred to) via xfstests, I saw
> failures on btrfs/009 and btrfs/022; then the box deadlocked
> on btrfs/024.  I rebooted & resumed, then deadlocked on btrfs/030.
> Rebooted and resumed again, then panicked on btrfs/035.  At that
> point I stopped.

FWIW, Liu Bo recently proposed a fix for the btrfs/035 BUG_ON():

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/33327

Cheers, David
