Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:46972 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbcCAPpT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 10:45:19 -0500
Subject: Re: btrfs-progs: initial scan-build results
To: Alexander Fougner <fougner89@gmail.com>
References: <56D58E93.9000705@googlemail.com>
 <CAGGqMYRKppf3vxjLCHrgwCp5-E6jf8kc6Mdj-NVmhoux6W-eVQ@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56D5B90C.6000101@googlemail.com>
Date: Tue, 1 Mar 2016 16:45:16 +0100
MIME-Version: 1.0
In-Reply-To: <CAGGqMYRKppf3vxjLCHrgwCp5-E6jf8kc6Mdj-NVmhoux6W-eVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

thanks for taking a look. I hadn't actually delved in too deeply yet.

On 03/01/16 14:41, Alexander Fougner wrote:
> All zero-sized allocations are false positives, except the
> btrfs-image.c. This can be fixed by placing the num_threads at the top
> instead of after calloc().

Well..I stepped into metadump_init() and num_pthreads is definitely 0;
setting it to 1 before continuing starts & coordinates with a new thread,
as expected. What the analyser complains about, and what I also didn't
know until just now because I stopped remembering C standard details
shortly after approx. BSD 4.2 ;-) is the second half of the following bit
from calloc(1):

  If nmemb or size is 0, then calloc() returns either NULL, or  a
  unique pointer value that can later be successfully passed to free()

So this works implicitly and is OK since it still checks for NULL
and num_pthreads==0 later on.

Well..good thing we talked about it. :-)

cheers
Holger

