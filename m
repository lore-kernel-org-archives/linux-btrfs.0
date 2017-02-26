Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:58405 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbdBZFr7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Feb 2017 00:47:59 -0500
Date: Sun, 26 Feb 2017 06:47:12 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Bhasker C V <bhasker@unixindia.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS hybrid system setup issues
Message-ID: <20170226054712.bt73qk4vqm5civw2@angband.pl>
References: <CAPLCSGCeD5KaFmMZWCKQ8nEbMEYTeDsb4ksgxQiU7-6P7dR=3w@mail.gmail.com>
 <1020cf90-bb59-eea4-5f82-166427b3363e@mendix.com>
 <CAPLCSGCWighTDFAyN3ixz3Xk5_ArLJfGaWHSDyvstZ9cZmx6rQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPLCSGCWighTDFAyN3ixz3Xk5_ArLJfGaWHSDyvstZ9cZmx6rQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 26, 2017 at 10:47:40AM +0530, Bhasker C V wrote:
> I compiled kernel 4.10 and I can confirm it is working fnie now.  4.10
> has the compat-ioctl patches for btrfs progs to work with x86_64
> kernel in i386 userland.

So does 4.9.10 if you prefer running long-lived releases.

-- 
Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
  ./configure --host=zx-spectrum --build=pdp11
