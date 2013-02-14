Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934317Ab3BNMXB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 07:23:01 -0500
Date: Thu, 14 Feb 2013 13:22:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs-progs: check out if the swap device
Message-ID: <20130214122259.GI12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201302140753.AA00021@FM-323941448.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201302140753.AA00021@FM-323941448.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 14, 2013 at 04:53:04PM +0900, Tsutomu Itoh wrote:
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Worked for me here in these situations (ie. mkfs failed, filenames
specified given as simple path or with mixture of ./ and ../ leading to
the device):

* mounted /dev/sdx
* /dev/sdx part of a multi-device mounted fs
* /dev/sdx swap device
* file as a swap device
* swap files with funny names: \ \040 \134 \888 <space>

Tested-by: David Sterba <dsterba@suse.cz>
