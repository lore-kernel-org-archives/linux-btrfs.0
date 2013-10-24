Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:41134 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab3JXFy2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 01:54:28 -0400
Date: Thu, 24 Oct 2013 14:54:15 +0900
From: Tomasz Chmielewski <tch@virtall.com>
Cc: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: CPU: 2 PID: 1543 at fs/btrfs/ctree.c:1322
 btrfs_search_old_slot+0x338/0x81d [btrfs]()
Message-ID: <20131024145415.668b5ede@virtall.com>
In-Reply-To: <20131023132844.2a206238@virtall.com>
References: <20131021122123.43b3aa50@virtall.com>
	<20131021151032.708cc7d2@virtall.com>
	<20131021125317.GK1032@twin.jikos.cz>
	<20131022025025.169941de@virtall.com>
	<20131022154619.GW1032@twin.jikos.cz>
	<20131023010411.42d30c97@virtall.com>
	<20131022162019.GY1032@twin.jikos.cz>
	<20131023132844.2a206238@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 23 Oct 2013 13:28:44 +0900
Tomasz Chmielewski <tch@virtall.com> wrote:

OK, putting high load aside - it finished, with no errors:

# btrfs scrub status /mnt/lxc1
scrub status for 8d08ad6d-4543-4fe5-8b1b-640dc1423d41
        scrub started at Wed Oct 23 04:19:55 2013 and finished after 68479 seconds
        total bytes scrubbed: 3.50TB with 0 errors

-- 
Tomasz Chmielewski
http://wpkg.org
