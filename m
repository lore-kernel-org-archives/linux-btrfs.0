Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:46356 "EHLO zlom.siedziba.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933206AbdC3PJO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 11:09:14 -0400
Subject: Re: Shrinking a device - performance?
To: Peter Grandi <pg@btrfs.for.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
 <20170327130730.GN11714@carfax.org.uk>
 <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
 <20170327194847.5c0c5545@natsu>
 <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
 <22746.30348.324000.636753@tree.ty.sabi.co.uk>
From: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <pp@siedziba.pl>
Message-ID: <b0f6b00e-4c70-72d1-8683-c05bb72a0968@siedziba.pl>
Date: Thu, 30 Mar 2017 17:00:19 +0200
MIME-Version: 1.0
In-Reply-To: <22746.30348.324000.636753@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> As a general consideration, shrinking a large filetree online
> in-place is an amazingly risky, difficult, slow operation and
> should be a last desperate resort (as apparently in this case),
> regardless of the filesystem type, and expecting otherwise is
> "optimistic".

The way btrfs is designed I'd actually expect shrinking to be fast in
most cases. It could probably be done by moving whole chunks at near
platter speed, instead of extent-by-extent as it is done now, as long as
there is enough free space. There was a discussion about it already:
http://www.spinics.net/lists/linux-btrfs/msg38608.html. It just hasn't
been implemented yet.

