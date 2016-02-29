Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbcB2MLg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Feb 2016 07:11:36 -0500
Date: Mon, 29 Feb 2016 13:11:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com,
        linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH V15 00/15] Btrfs: Subpagesize-blocksize: Allow I/O on
 blocks whose size is less than page size
Message-ID: <20160229121120.GT23746@suse.cz>
Reply-To: dsterba@suse.cz
References: <1455212873-14829-1-git-send-email-chandan@linux.vnet.ibm.com>
 <2493765.95l8sSnlWq@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2493765.95l8sSnlWq@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 29, 2016 at 11:22:48AM +0530, Chandan Rajendra wrote:
> Can you please look into the patchset and provide review comments if any. I am
> hoping to get the patchset merged by linux-4.6.

4.6 is not realistic for patchset of such impact. The preparatory
patchset will be merged to 4.6, the core will possibly go to 4.7 if the
reviews pass.
