Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:47026 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbcCAQjb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 11:39:31 -0500
Subject: Re: btrfs-progs: initial scan-build results
To: Alexander Fougner <fougner89@gmail.com>
References: <56D58E93.9000705@googlemail.com>
 <CAGGqMYRKppf3vxjLCHrgwCp5-E6jf8kc6Mdj-NVmhoux6W-eVQ@mail.gmail.com>
 <56D5B90C.6000101@googlemail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56D5C5C1.7000202@googlemail.com>
Date: Tue, 1 Mar 2016 17:39:29 +0100
MIME-Version: 1.0
In-Reply-To: <56D5B90C.6000101@googlemail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/01/16 16:45, Holger Hoffstätte wrote:
> On 03/01/16 14:41, Alexander Fougner wrote:
>> All zero-sized allocations are false positives, except the

Right, I've now also reviewed them all and they are all guarded
by other conditions or plain wrong - very likely because this
particular warning itself turns out to be a bug in llvm:
https://llvm.org/bugs/show_bug.cgi?id=15708

!"§$%

-h

