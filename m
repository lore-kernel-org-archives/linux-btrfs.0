Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45768 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3I0QOU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 12:14:20 -0400
Date: Sat, 28 Sep 2013 00:14:06 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: William Lima <wlima@primate.com.br>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: compression via chattr
Message-ID: <20130927161405.GA28191@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAOPVPepnhLQo+EG_vhGMsCHCd7p4G7HGYe16Ctmz23O61TPoUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOPVPepnhLQo+EG_vhGMsCHCd7p4G7HGYe16Ctmz23O61TPoUg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 27, 2013 at 12:10:03PM -0300, William Lima wrote:
> Enabling compression via chattr +c works with ZLIB (default method)
> only, right? Since there is no way to specify a compression method.
> Cannot I use LZO this way?

You can add compress=lzo into your mount options, then chattr +c will
work with LZO, sorry, I know it's not good, but that may be all we can
do about it for now.

-liubo
