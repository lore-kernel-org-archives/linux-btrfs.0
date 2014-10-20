Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:58475 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbaJTUVL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 16:21:11 -0400
Message-ID: <54456EB0.9020503@inwind.it>
Date: Mon, 20 Oct 2014 22:21:04 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, russell@coker.com.au
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: strange 3.16.3 problem
References: <201410181454.19375.russell@coker.com.au> <54426C16.5030206@pobox.com> <201410191041.42013.russell@coker.com.au> <54454858.8010802@pobox.com>
In-Reply-To: <54454858.8010802@pobox.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/20/2014 07:37 PM, Robert White wrote:
> On 10/18/2014 04:41 PM, Russell Coker wrote:
[...]
> Also you said that you are using a 32bit user space "copied from
> another server" under a 64bit kernel. Is the "ls" command a 32 bit
> executable then?

Could this be related to the inode overflow in 32 bit system 
(see inode_cache options) ? If so running a 64bit "ls -i" should
work....


> -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
