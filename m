Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbbANANm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 19:13:42 -0500
Date: Wed, 14 Jan 2015 01:13:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, merlijn@wizzup.org
Subject: Re: [PATCH] Revert "btrfs-progs: disable backtrace and define
 __always_inline"
Message-ID: <20150114001341.GP3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421187619-24936-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421187619-24936-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 13, 2015 at 05:20:19PM -0500, Josef Bacik wrote:
> This reverts commit c2691f807ddd2c6b261c5707f6838a45d9275390 as it breaks
> backtracing on actual glibc environments.

This is to support musl libc. If it does not work then the test is wrong
and should be fixed. CCed the author.

http://openwall.com/lists/musl/2013/03/29/13

Seems that there's no ifdef way to find out the libc used.
