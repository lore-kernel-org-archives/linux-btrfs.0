Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34566 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab2FYNTZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 09:19:25 -0400
Date: Mon, 25 Jun 2012 15:19:22 +0200
From: David Sterba <dave@jikos.cz>
To: Andrew Mahone <andrew.mahone@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] btrfs: lz4/lz4hc compression
Message-ID: <20120625131922.GC28144@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1340438748-348-1-git-send-email-andrew.mahone@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1340438748-348-1-git-send-email-andrew.mahone@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 23, 2012 at 04:05:43AM -0400, Andrew Mahone wrote:
> A large portion of the work was done by Dave Sterba, but in flattening the
> commits attribution has been lost. My contribution has been in debugging some
> of the cases in which it could crash or produce incorrect data, and cleaning
> it up for the ML.

Sorry, but how could the attribution get _lost_ ? I wrote like 80% of
the code and there's no single Signed-off-by for me?
Documentation/SubmittingPatches ch. 12 is quite clear how to use the
S-O-B line.

I'm glad that somebody came and helped to move the patchset forward, I
don't mind sharing the credit for the respective parts. I'm
intentionally publishing some WIP branches or paritally working research
projects in my git repo as I don't have enough time to finalize all of
them.

In this case it's just your work on patch [3/5] in file lz4_wrapper.c.

> Andrew Mahone (5):
>   btrfs: lz4: import lz4/lz4hc C and header files
>   btrfs: lz4: add incompat flags and compression types
>   btrfs: lz4: add lz4_wrapper implementing btrfs compression interface
>   btrfs: lz4: add lz4 files in Makefile
>   btrfs: enable lz4/lz4hc compression


david
