Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34893 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab2IQPFg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 11:05:36 -0400
Date: Mon, 17 Sep 2012 17:05:18 +0200
From: David Sterba <dave@jikos.cz>
To: jbacik@fusionio.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [RFC inside][PATCH] btrfs: allow setting NOCOW for a zero sized
 file via ioctl
Message-ID: <20120917150517.GR17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1347019015-3215-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1347019015-3215-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Josef, I noticed that you did not add the patch to btrfs-next. This is
understandable for a RFC patch of course, but I'd like to ask you to add
it into the queue, so people testing -next have a chance to give it a
try.

Thanks,
david
