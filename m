Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbbHFOjC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Aug 2015 10:39:02 -0400
Date: Thu, 6 Aug 2015 16:38:39 +0200
From: David Sterba <dsterba@suse.com>
To: =?utf-8?B?77+977+977+977+977+977+9?= <kenneth.kang@lge.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: FW: btrfs-progs: android build
Message-ID: <20150806143839.GK31669@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <003201d0d02c$3349fe10$99ddfa30$@lge.com>
 <003f01d0d02c$96c92f10$c45b8d30$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <003f01d0d02c$96c92f10$c45b8d30$@lge.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Thu, Aug 06, 2015 at 06:45:11PM +0900, ������ wrote:
> Hi, I made btrfs-progs android build script and test it.\

Thanks. The changes as they stand are too intrusive to be added but give
me an idea what's needed.

The makefile part shares some variables with current make and adds some
specific variables and includes. Ideally there's only one makefile but
I think that we can live with a separate makefile for android as there
seem to be specific quirks that would complicate the common makefile.

This means we'd have to keep the shared part in sync manually but it's
not that hard. New files or new libs, this always requires more care.

> And need some help on btrfs_wipe_existing_sb().\
> On the test it looks work well.\

The code changes should be hidden in wrappers and pulled via a separate
header file. If this is not possible, the ifdefs should be in the
function implementations (eg. is_ssd, check_overwrite), not at the call
sites.

Other than that, I don't mind adding support for android builds.  I don't
have an android build environment at hand and cannot verify that it's
always working, so the same holds as for musl libc, fixes are up to you.
