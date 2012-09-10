Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:45032 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab2IJRQt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Sep 2012 13:16:49 -0400
Date: Mon, 10 Sep 2012 19:16:30 +0200
From: David Sterba <dave@jikos.cz>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Symlink to a long filename "filename too long" error
Message-ID: <20120910171630.GT17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120910163406.GG5053@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120910163406.GG5053@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 10, 2012 at 09:34:06AM -0700, Marc MERLIN wrote:
> Due to some filesystem corruption on my source device, I had a very long file as a symlink
> target that btrfs wasn't able to recreate.
> Mind you, in this case it's clearly not something I need, but is it
> expected/known that ext4 can store longer filenames than btrfs?

Btrfs can store symlink targets up to it's inline limit, 3917. xfs has
this limit hardcoded as 1024. ext4 has fast and non-fast symlink
storage, based on the target length, so it's able to store the maximum
PATH_MAX size into a full block for the non-fast case.

david
