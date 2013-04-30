Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22757 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab3D3GMe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 02:12:34 -0400
Message-ID: <517F6158.5000405@oracle.com>
Date: Tue, 30 Apr 2013 14:14:48 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: device delete to get errors from the kernel
References: <51623C0C.4060709@oracle.com> <517A4B44.5060608@oracle.com> <517A5C27.3090803@giantdisaster.de>
In-Reply-To: <517A5C27.3090803@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Thanks Stefan.

::

> About the issue you mentioned, that you need to change the kernel and
> the user mode at the same time:
> You can keep it compatible. Just do not delete the old kernel interface.
> The user mode program could try the new interface first, and if it
> fails, fall back to the old interface. You can use the same ioctl number
> for both ways if you change the length of the ioctl parameter.

  Here there won't be a definite failure as such,
  kernel could send or read garbage if the old and
  new structures don't match.

  The problem with most of the ioctl api structures
  are they don't (already) share the struct len. So
  it won't be possible to know which version of the
  structure is being used by the other party?

Anand
