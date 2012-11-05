Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:54762 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab2KEQGx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Nov 2012 11:06:53 -0500
Date: Mon, 5 Nov 2012 17:06:49 +0100
From: David Sterba <dave@jikos.cz>
To: Alex <alex@bpmit.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: (late) REQUEST: Default mkfs.btrfs block size
Message-ID: <20121105160649.GM3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <loom.20121031T131532-168@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20121031T131532-168@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 31, 2012 at 12:20:39PM +0000, Alex wrote:
> As one 'stuck' with 4k leaves on my main machine for the moment, can I request
> the btrfs-progs v0.20 defaults to more efficient decent block sizes before
> release. Most distro install programs for the moment don't give access to the
> options at install time and there seems to be is a significant advantage to 16k
> or 32k

IMHO this should be fixed inside the installer, changing defaults for a
core utility will affect everybody. 4k is the most tested option and
thus can be considered "safe for everybody".

The installer may let you to enter a shell and create the filesystem by
hand, then point it to use it for installation.

david
