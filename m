Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rei.romanrm.net ([172.104.66.239]:35952 "EHLO rei.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751364AbeENI11 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 04:27:27 -0400
Date: Mon, 14 May 2018 13:20:04 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW
 set
Message-ID: <20180514132004.3afec300@natsu>
In-Reply-To: <90871596-c030-930b-57ad-7db63b4f579d@suse.com>
References: <20180514070210.27047-1-wqu@suse.com>
        <90871596-c030-930b-57ad-7db63b4f579d@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 14 May 2018 11:10:34 +0300
Nikolay Borisov <nborisov@suse.com> wrote:

> But if we have mounted the fs with FORCE_COMPRESS shouldn't we disregard
> the inode flags, presumably the admin knows what he is doing?

Please don't. Personally I always assumed chattr +C would prevent both CoW and
compression, and used that as a way to override volume-wide compress-force for
a particular folder. Now that it turns out this wasn't working, the patch
would fix it to behave in line with prior expectations.

-- 
With respect,
Roman
