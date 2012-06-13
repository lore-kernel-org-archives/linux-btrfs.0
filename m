Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49648 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab2FMTo7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 15:44:59 -0400
Date: Wed, 13 Jun 2012 15:44:55 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, rm@romanrm.ru
Subject: Re: [PATCH v2] E2fsprogs: add missing usage for No_COW
Message-ID: <20120613194455.GA17990@thunk.org>
References: <1339577802-31343-1-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339577802-31343-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 13, 2012 at 04:56:42PM +0800, Liu Bo wrote:
> Add the missing usage for No_COW since we've supported No_COW flag.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>

Applied, although I changed the commit desciption to read:

    chattr: add the -C option to the usage message

    	    	       	      	     - Ted
