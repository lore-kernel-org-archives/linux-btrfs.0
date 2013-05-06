Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab3EFSiW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 May 2013 14:38:22 -0400
Date: Mon, 6 May 2013 11:38:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>,
        stable@vger.kernel.org, Tristan Seligmann <mithrandi@mithrandi.net>
Subject: Re: [PATCH] btrfs: don't stop searching after encountering the wrong
 item
Message-ID: <20130506183821.GA13827@kroah.com>
References: <5187EB02.8030207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5187EB02.8030207@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 06, 2013 at 07:40:18PM +0200, Gabriel de Perthuis wrote:
> The search ioctl skips items that are too large for a result buffer, but
> inline items of a certain size occuring before any search result is
> found would trigger an overflow and stop the search entirely.
> 
> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=57641
> 
> Signed-off-by: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>
> ---
>  fs/btrfs/ioctl.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
