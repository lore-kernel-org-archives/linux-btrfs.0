Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbbG3JWs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jul 2015 05:22:48 -0400
Date: Thu, 30 Jul 2015 11:22:35 +0200
From: David Sterba <dsterba@suse.com>
To: Brendan Heading <brendanheading@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: compilation errors when using musl libc
Message-ID: <20150730092235.GO6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1438195057-9400-1-git-send-email-brendanheading@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438195057-9400-1-git-send-email-brendanheading@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 29, 2015 at 07:37:37PM +0100, Brendan Heading wrote:
> - limits.h must be included to pick up PATH_MAX.
> - remove double declaration of BTRFS_DISABLE_BACKTRACE
> 
> kerncompat.h assumed that if __GLIBC__ was not defined,
> it could safely define BTRFS_DISABLE_BACKTRACE, however this can be
> defined by the configure script. Added a check to ensure it is not
> defined first.
> 
> Signed-off-by: Brendan Heading <brendanheading@gmail.com>

Applied, thanks.
