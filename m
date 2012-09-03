Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:53571 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495Ab2ICQuc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Sep 2012 12:50:32 -0400
Date: Mon, 3 Sep 2012 18:49:06 +0200
From: David Sterba <dave@jikos.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: dave@jikos.cz, Ben Wreder <benwreder@hotmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Tail packing
Message-ID: <20120903164906.GJ17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <DUB117-W3224DDE372041F789CA47FB5A60@phx.gbl>
 <20120902052537.GF17430@twin.jikos.cz>
 <5044067E.7000607@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5044067E.7000607@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 03, 2012 at 09:23:10AM +0800, Li Zefan wrote:
> If the actual size of the file is > 3916 bytes, no matter how compressible it is,
> it won't be inlined.

You're right, sorry for misinformation.
