Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309Ab3GaUyJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 16:54:09 -0400
Date: Wed, 31 Jul 2013 13:54:05 -0700
From: Zach Brown <zab@redhat.com>
To: Mike Audia <mikey_a@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is the checkpoint interval adjustable?
Message-ID: <20130731205405.GL32145@lenny.home.zabbo.net>
References: <20130731200229.221580@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20130731200229.221580@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 31, 2013 at 04:02:29PM -0400, Mike Audia wrote:
> I believe 30 sec is the default for the checkpoint interval.  Is this adjustable?

It doesn't look like it.  It looks like it's implemented with raw '30's
in the code.

                delay = HZ * 30;
...
                    (now < cur->start_time || now - cur->start_time <
30)) {

If you want more frequent forced commits you could always syncfs()
regularly from userspace, I suppose.

- z
