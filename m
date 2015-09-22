Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331AbbIVHPy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 03:15:54 -0400
Date: Tue, 22 Sep 2015 09:14:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: tests: Move extract_image out of
 check_all_images for common use
Message-ID: <20150922071458.GE8891@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <154afcdd14c259551d843a157814fd0ff3589e8f.1441373012.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <154afcdd14c259551d843a157814fd0ff3589e8f.1441373012.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 04, 2015 at 09:23:49PM +0800, Zhao Lei wrote:
> Move code for extract image file to a function from check_all_images()
> for common use, so caller can use this function to extrace single
> image file.

Moving the code to a wrapper is good but return value via a variable is
not. The function is string-to-string, so it can just echo it at the
end.
