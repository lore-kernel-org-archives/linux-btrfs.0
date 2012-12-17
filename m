Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:34549 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab2LQKg1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 05:36:27 -0500
Date: Mon, 17 Dec 2012 11:36:24 +0100
From: Sander <sander@humilis.net>
To: Sylvain Alain <d2racing911@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs subvolume snapshot performance problem
Message-ID: <20121217103624.GA15304@panda>
Reply-To: sander@humilis.net
References: <CACR_K2uer3bniWAenoKe=-2BxT4vt4opXywCBbwGuaX7C8EgLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACR_K2uer3bniWAenoKe=-2BxT4vt4opXywCBbwGuaX7C8EgLA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sylvain Alain wrote (ao):
> gentootux ~ # mount /dev/sda4 -o
> noatime,ssd,discard,compress=lzo,noacl,space_cache,subvolid=0
              ^^^^^^^

> Instead of 3 secondes to run the snapshot, it took almost 4 minutes.

Let me repeat the answer cwillu gave to Russell on this, and Russell's
response:

Russell Coker wrote (ao):
> On Sun, 16 Dec 2012, cwillu <cwillu@cwillu.com> wrote:
> > Don't use discard; it's a non-queuing command, which means your
> > performance will suck unless your device is really terrible at
> > garbage collection (in which case, it's just the lesser of two evils).
> 
> Thanks for the advice. On one of my systems a reinstall of the linux-
> image-3.6-trunk-amd64 package went from almost 4 minutes to only 29
> seconds when I removed the discard option.
