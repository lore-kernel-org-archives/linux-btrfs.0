Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34989 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3KGUVY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 15:21:24 -0500
Received: by mail-pd0-f180.google.com with SMTP id p10so1084274pdj.25
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Nov 2013 12:21:24 -0800 (PST)
Date: Thu, 7 Nov 2013 12:21:21 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, hch@infradead.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Chris Mason <chris.mason@fusionio.com>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH 1/9] block: Convert various code to bio_for_each_segment()
Message-ID: <20131107202121.GF3842@kmo>
References: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
 <1383608187-27368-2-git-send-email-kmo@daterainc.com>
 <20131107112630.GA31798@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131107112630.GA31798@quack.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 07, 2013 at 12:26:30PM +0100, Jan Kara wrote:
> On Mon 04-11-13 15:36:19, Kent Overstreet wrote:
> > With immutable biovecs we don't want code accessing bi_io_vec directly -
> > the uses this patch changes weren't incorrect since they all own the
> > bio, but it makes the code harder to audit for no good reason - also,
> > this will help with multipage bvecs later.
>   I think you've missed the code in fs/ext4/page-io.c in the conversion
> (likely because it was added relatively recently).

Thanks!
