Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:20708 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab3DZKvU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 06:51:20 -0400
Message-ID: <517A5C27.3090803@giantdisaster.de>
Date: Fri, 26 Apr 2013 12:51:19 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: device delete to get errors from the kernel
References: <51623C0C.4060709@oracle.com> <517A4B44.5060608@oracle.com>
In-Reply-To: <517A4B44.5060608@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 26 Apr 2013 17:39:16 +0800, Anand Jain wrote:
> 
>  As showed in the previous email in this thread, we need to get
>  the error string from the kernel to the cli to improve the
>  usability of the product.
>  As also said, I was looking at two way which I think we could
>  do this, here I take the 2nd approach which is to pass the error
>  string though the ioctl args. Which leads to change in the
>  ioctl-structure. But..
> 
>  This comes with a caveat that both btrfs-progs and btrfs-kernel
>  patch together either must be applied or removed.
> 
>   [PATCH] btrfs-progs: device delete to get errors from the kernel
>   [PATCH] btrfs: device delete to get errors from the kernel
> 
>  Which is not a developer/integrator friendly rule. If there
>  is anything I could do to help on this pls do let me know.
> 
>  There are quite a number of cli which needs passing of the
>  the error string from the kernel to cli. Which I plan to work
>  once we finalize the approach to address this issue.
> 
>  Thanks for your time to review this.

The regular procedure is to define an enumeration of numerical error
codes. And in user mode, somewhere in the btrfslib you add a function to
map the numerical error code to a string. I mean, you don't export a
string in first place, you export something numerical that allows
applications to evaluate the specific error code.

One use case where numerical error codes are better would be that a user
friendly GUI replaces the kernel developer assigned error strings with
friendly error strings for real human beings, maybe including advices,
how to avoid that error, how to go on.

About the issue you mentioned, that you need to change the kernel and
the user mode at the same time:
You can keep it compatible. Just do not delete the old kernel interface.
The user mode program could try the new interface first, and if it
fails, fall back to the old interface. You can use the same ioctl number
for both ways if you change the length of the ioctl parameter.

