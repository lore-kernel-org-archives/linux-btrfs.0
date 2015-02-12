Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258AbbBLJnT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 04:43:19 -0500
Date: Thu, 12 Feb 2015 10:43:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Kevin Mulvey <kevin@kevinmulvey.net>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Mulvey <kmulvey@linux.com>
Subject: Re: [PATCH] fix spacing in btrfs/inode.c
Message-ID: <20150212094317.GO28877@suse.cz>
Reply-To: dsterba@suse.cz
References: <1423707442-9485-1-git-send-email-kmulvey@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423707442-9485-1-git-send-email-kmulvey@linux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 11, 2015 at 09:17:22PM -0500, Kevin Mulvey wrote:
> This is a patch to inode.c that fixes some spacing errors found by checkpatch.pl

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Cleanup_projects

"Please note that pure whitespace and style reformatting changes are not
really necessary at this phase of development. They get fixed along
regular changes. Possibly once upon in a while a patch that fixes many
if not all whitespace errors could work, but otherwise it's considered a
noise."
