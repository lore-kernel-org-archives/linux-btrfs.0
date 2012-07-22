Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59838 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2GVPOB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jul 2012 11:14:01 -0400
Received: by weyx8 with SMTP id x8so3713100wey.19
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Jul 2012 08:14:00 -0700 (PDT)
Date: Sun, 22 Jul 2012 18:14:00 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: =?utf-8?B?U3fDom1p?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Change "small" filesystem to normal
Message-ID: <20120722151400.GA1934@zambezi.lan>
References: <500C16F0.6000205@petaramesh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <500C16F0.6000205@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 22, 2012 at 05:06:24PM +0200, Swâmi Petaramesh wrote:
> Hi,
> 
> I've created a "small" BTRFS filesystem, where metadata+data are mixed
> (and metadata are not DUP'ed).
> 
> Then I've enlarged the FS to 1 GB ; now I'd like to make it "normal"
> with separate data and metadata, and "DUP'ed" metadata.
> 
> Is there a way tp do this without reformatting the FS ?

No, currently there is no way to do this.  You'll have to create a new
filesystem with mkfs.btrfs.

Thanks,

		Ilya
