Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64979 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbaCCCcx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Mar 2014 21:32:53 -0500
Message-ID: <5313EA72.1010000@fb.com>
Date: Sun, 2 Mar 2014 21:35:30 -0500
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <russell@coker.com.au>, <linux-btrfs@vger.kernel.org>
Subject: Re: GPF in 3.13.4 Debian kernel
References: <201403031123.53133.russell@coker.com.au>
In-Reply-To: <201403031123.53133.russell@coker.com.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/02/2014 07:23 PM, Russell Coker wrote:
> I've attached the kernel message log from a GPF that occurred running the
> Debian kernel package of kernel 3.13.4.  This happens repeatedly and started
> doing so with Debian kernel 3.12.8.
>
> This is not the first time I've seen a filesystem corruption occur related to
> Kmail files that causes a kernel panic.  I wonder if Kmail has some file
> access pattern that triggers a BTRFS bug.
>

Looks like this one:

https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=for-linus&id=514ac8ad8793a097c0c9d89202c642479d6dfa34

It's in a batch that needed extra attention for a stable backport, which 
I've finally got finished off here.

If you want to try linus master, it should be fixed.  Or you can wait 
for my weekend run to finish against the stable tree and I'll have it 
for you tomorrow.

-chris
