Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42847 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab2IXSmo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 14:42:44 -0400
Received: by wibhr14 with SMTP id hr14so5279861wib.1
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2012 11:42:43 -0700 (PDT)
Date: Mon, 24 Sep 2012 21:42:42 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Miao Xie <miaox@cn.fujitsu.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] Btrfs: cleanup duplicated division functions
Message-ID: <20120924184241.GB3098@zambezi.lan>
References: <5051BAB8.7080200@cn.fujitsu.com>
 <505A8632.10101@cn.fujitsu.com>
 <505C2E62.2000400@cn.fujitsu.com>
 <20120923114924.GA1975@zambezi.lan>
 <505FBFCE.3010503@cn.fujitsu.com>
 <20120924164742.GN14582@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120924164742.GN14582@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 06:47:42PM +0200, David Sterba wrote:
> On Mon, Sep 24, 2012 at 10:05:02AM +0800, Miao Xie wrote:
> > Generally, we should check the value when it is input. If not, we might
> > run our program with the wrong value, and it is possible to cause unknown
> > problems. So I think the above chunk is necessary.
> 
> The difference is that giving an invalid value will exit early (your
> version), while Ilya's version will clamp the 'usage' to the allowed
> range during processing. From usability POV, I'd prefer to let the
> command fail early with a verbose error eg. that the range is invalid.

I think that's the job for progs, and that's where this and a few other
checks are currently implemented.

There is no possibility for "unknown problems", that's exactly how it's
been implemented before the cleanup.  The purpose of balance filters
(and the usage filter in particular) is to lower the number of chunks we
have to relocate.  If someone decides to use raw ioctls, and supplies us
with the invalid value, we just cut it down to a 100 and proceed.
usage=100 is the equivalent of not using the usage filter at all, so the
raw ioctl user will get what he deserves.

This is very similar to what we currently do with other filters.  For
example, "soft" can only be used with "convert", and this is checked by
progs.  But, if somebody were to set a "soft" flag without setting
"convert" we would simply ignore that "soft".  Same goes for "drange"
and "devid", invalid ranges, invalid devids, etc.  Pulling all these
checks into the kernel is questionable at best, and, if enough people
insist on it, should be discussed separately.

Thanks,

		Ilya
