Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:53436 "EHLO zlom.siedziba.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934944AbdC3WNl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 18:13:41 -0400
From: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <pp@siedziba.pl>
Subject: Re: Shrinking a device - performance?
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
 <20170327130730.GN11714@carfax.org.uk>
 <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
 <20170327194847.5c0c5545@natsu>
 <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
 <22746.30348.324000.636753@tree.ty.sabi.co.uk>
 <b0f6b00e-4c70-72d1-8683-c05bb72a0968@siedziba.pl>
 <22749.11946.474065.536986@tree.ty.sabi.co.uk>
Message-ID: <67132222-17c3-b198-70c1-c3ae0c1cb8e7@siedziba.pl>
Date: Fri, 31 Mar 2017 00:13:04 +0200
MIME-Version: 1.0
In-Reply-To: <22749.11946.474065.536986@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> The proposed "move whole chunks" implementation helps only if
> there are enough unallocated chunks "below the line". If regular
> 'balance' is done on the filesystem there will be some, but that
> just spreads the cost of the 'balance' across time, it does not
> by itself make a «risky, difficult, slow operation» any less so,
> just spreads the risk, difficulty, slowness across time.

Isn't that too pessimistic? Most of my filesystems have 90+% of free
space unallocated, even those I never run balance on. For me it wouldn't
just spread the cost, it would reduce it considerably.
