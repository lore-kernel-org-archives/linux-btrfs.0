Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab3HPQak (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 12:30:40 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7GGUe8n011188
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 12:30:40 -0400
Date: Fri, 16 Aug 2013 09:30:39 -0700
From: Zach Brown <zab@redhat.com>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How btrfs resize should work ?
Message-ID: <20130816163039.GK12314@lenny.home.zabbo.net>
References: <alpine.LFD.2.00.1308161011160.1968@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LFD.2.00.1308161011160.1968@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> So it appears that it only resized part of the file system which
> lies on /dev/sda to 3G. This behavior is confusing as hell, is this
> really desirable behaviour ?

Yeah, 'btrfs filesystem resize' is misnamed.  It only resizes a
specified device which defaults to devid 1 if you don't specify one.
The documentation is just tragically wrong:

"
       filesystem resize [devid:][+/-]<size>[gkm]|[devid:]max <path>
              Resize a filesystem identified by <path> for the
              underlying device devid.
"

Nope.

> fix this somehow, it does it expect user to take care of this (I
> hope not). Because currently ssm is not able to resize btrfs
> correctly.

What *would* be correctly?  What does ssm expect to be able to do with
all of the devices under a file system after it is resized?

Put another way: if you couldn't inspect the btrfs metadata, what would
a unit test for this look like that would pass?

- z
