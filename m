Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbbCWSCu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 14:02:50 -0400
Date: Mon, 23 Mar 2015 14:02:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, zab@redhat.com, fstests@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 1/3] dm: log writes target
Message-ID: <20150323180245.GE3172@redhat.com>
References: <1426797070-27463-1-git-send-email-jbacik@fb.com>
 <1426797070-27463-2-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426797070-27463-2-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 19, 2015 at 04:31:08PM -0400, Josef Bacik wrote:

[..]
> + * We log writes only after they have been flushed, this makes the log describe
> + * close to the order in which the data hits the actual disk, not its cache.  So
> + * for example the following sequence (W means write, C means complete)
> + *
> + * Wa,Wb,Wc,Cc,Ca,FLUSH,FUAd,Cb,CFLUSH,CFUAd
> + *
> + * Would result in the log looking like this
> + *
> + * c,a,flush,fuad,b,<other writes>,<next flush>
> + *

A minor nit, Should this sequence be following.

c,a,b, flush,fuad,<other writes>,<next flush>

when flush completed by that time write of b has completed too. So it
should be written first?

Thanks
Vivek
