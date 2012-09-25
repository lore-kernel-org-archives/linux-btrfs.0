Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:54155 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab2IYMzH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 08:55:07 -0400
Date: Tue, 25 Sep 2012 14:55:02 +0200
From: David Sterba <dave@jikos.cz>
To: ching <lsching17@gmail.com>
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not async metadata csums if we have hardware
 crc32c
Message-ID: <20120925125502.GV14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348510264-5781-1-git-send-email-jbacik@fusionio.com>
 <20120924210349.GP14582@twin.jikos.cz>
 <20120925105154.GS14582@twin.jikos.cz>
 <50619821.60609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50619821.60609@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 25, 2012 at 07:40:17PM +0800, ching wrote:
> How about enhancing the "*thread_pool=/number" mount option instead?
> 
> thread_pool=n     enable threadpool/**/for compression and checksum, MAY improve bandwidth/*
> */thread_pool=0     disable threadpool for compression and checksum, MIGHT reduce latency
> thread_pool=-1 or not provided    automatically managed (current behaviour and default choice)

Sorry, I don't understand the syntax, can you please write it more
clearly? Thanks.

> This should allow user to tradeoff between latency and bandwidth,
> furthermore, you do not need to assume that btrfs may use crc32c
> algorithm only forever.

Some sort of finer control over the threads makes sense, we should
distinguish for cpu-bound processing where paralelism wins and io-bound
where it is not helpful to add more and more threads that hammer a
single device (namely in case of HDD, so this should be tunable for the
devices with cheap seeks).

david
