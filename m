Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31202 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932232AbaAaOHa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jan 2014 09:07:30 -0500
Message-ID: <52EBAE13.9000405@fb.com>
Date: Fri, 31 Jan 2014 09:07:15 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <russell@coker.com.au>, <linux-btrfs@vger.kernel.org>
Subject: Re: GPF on access to presumably corrupted file
References: <201401311824.29611.russell@coker.com.au>
In-Reply-To: <201401311824.29611.russell@coker.com.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/31/2014 02:24 AM, Russell Coker wrote:
> The attached dmesg log shows the results of trying to cat a file on a BTRFS
> filesystem when running the latest Debian/Unstable kernel (upstream 3.12.8
> with some Debian patches that probably aren't relevant to BTRFS).
>
> I've rebooted the Thinkpad in question and repeated the problem after a
> reboot.  So I am fairly sure that the problem isn't directly caused by memory
> corruption.  I presume that it's corruption on disk causing this repeatable
> problem and such corruption could be caused by a memory error (which is
> something I've had happen before on a different system).  But I don't think
> that such corruption should cause a GPF.
>
> So while I think we should consider the possibility that the filesystem was
> corrupted due to a hardware fault (of which there are several possibilities
> when dealing with a laptop) the inability to recover seems like a bug in
> BTRFS.
>
> When this happens every process that tries to access the file in question is
> reported as being stuck in D state.  Sometimes such processes respond to kill
> -9 (I thought that was impossible) and sometimes they remain until reboot.
>
This may be a bug we just fixed in the recent git pull, are you running 
with compression?  If you are try the recent for-linus branch from Chris 
and see if you still have the problem.  Thanks,

Josef
