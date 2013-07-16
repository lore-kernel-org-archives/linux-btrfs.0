Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853Ab3GPP7N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jul 2013 11:59:13 -0400
Date: Tue, 16 Jul 2013 08:59:09 -0700
From: Zach Brown <zab@redhat.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Print key type in decimal everywhere
Message-ID: <20130716155909.GU25414@lenny.home.zabbo.net>
References: <1373981913-24659-1-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1373981913-24659-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 16, 2013 at 03:38:33PM +0200, Stefan Behrens wrote:
> This is confusing, sometimes the key type is printed in hex (without
> a leading "0x" which makes things even more complicated), sometimes
> in decimal...
> Change it to be in decimal everywhere.

This seems particularly reasonable to me because the key types are
defined with decimal constants in ctree.h.  I like it.

- z
