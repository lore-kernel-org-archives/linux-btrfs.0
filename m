Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbaBNQep (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 11:34:45 -0500
Date: Fri, 14 Feb 2014 17:34:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add dry-run option to restore command
Message-ID: <20140214163443.GV16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1391793123-4617-1-git-send-email-jmaggard10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391793123-4617-1-git-send-email-jmaggard10@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 07, 2014 at 09:12:03AM -0800, Justin Maggard wrote:
> Sometimes it is useful to see what btrfs restore is going to do
> before provisioning enough external storage to restore onto.
> Add a dry-run option so we can see what files and paths are found
> by restore, without actually restoring any data.

Ok, makes sense. I suggest to add the long option --dry-run as well. The
-D option sounds like "no data", so I'm ok to keep it as you've
proposed.

Please resend the patch and add your Signed-off-by line.
