Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:60522 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3ATP21 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 10:28:27 -0500
Received: by mail-ee0-f52.google.com with SMTP id b15so2321527eek.25
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jan 2013 07:28:26 -0800 (PST)
Date: Sun, 20 Jan 2013 17:28:25 +0200
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH 0/5] Mutually exclusive ops fixes
Message-ID: <20130120152825.GA1919@zambezi.lan>
References: <1358695352-7140-1-git-send-email-idryomov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358695352-7140-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 20, 2013 at 05:22:27PM +0200, Ilya Dryomov wrote:
> Hello,
> 
> This is a set of fixes for mutually exclusive ops stuff added by Stefan
> as part of the dev-replace patchset.  The main one here is the first
> patch, it fixes a regression in balancing interface.  The second patch
> brings EINVAL error code back.  The rest are relatively minor ordering
> fixes.

You can pull from

git://github.com/idryomov/btrfs-unstable.git mutex-ops@next-master

top commit 2f68aafa90fedb3cdb80f0a8517a2130c5c035b0

Thanks,

		Ilya
