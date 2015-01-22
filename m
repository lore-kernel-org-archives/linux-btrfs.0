Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbbAVQYM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Jan 2015 11:24:12 -0500
Date: Thu, 22 Jan 2015 17:24:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, wangshilong1991@gmail.com
Subject: Re: [PATCH v4] btrfs-progs: make btrfs qgroups show human readable
 sizes
Message-ID: <20150122162409.GK13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421914303-32650-1-git-send-email-fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421914303-32650-1-git-send-email-fancn.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 22, 2015 at 04:11:43PM +0800, Fan Chengniang wrote:
> v3:
> - remove --human-readable option
> - add --raw, --si, --iec, --kbytes, --mbytes, --gbytes, --tbytes options
> - by default, sizes are shown in human readable format
> - make columns which show sizes align to right. Others aligned to left.
> v4:
> - change default output be raw, instead of human readable.Because xfstest
> result depend on the raw output.

I've merged v3, that's what we want to present to the user. I'll send a
patch to fstests to force the raw bytes output.
