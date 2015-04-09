Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932885AbbDIJXO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 05:23:14 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20150409174916.5a2efef5@notabene.brown>
References: <20150409174916.5a2efef5@notabene.brown>
To: NeilBrown <neilb@suse.de>
Cc: dhowells@redhat.com, linux-btrfs@vger.kernel.org, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH/RFC] fscache/cachefiles versus btrfs
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 09 Apr 2015 10:23:08 +0100
Message-ID: <29536.1428571388@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

NeilBrown <neilb@suse.de> wrote:

>  Is there a better way?  Could a better way be created?  Maybe
>  SEEK_DATA_RELIABLE ??

fiemap() maybe?

> Also, if you do try to use fscache on btrfs with 3.19, then nothing gets
> cached (as expected) and with a heavy load you can lose a race and get an
> asserting fail in fscache_enqueue_operation

Do you have the patches here applied?

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=fscache-fixes

David
