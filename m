Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:55761 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaGBRoK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 13:44:10 -0400
Message-ID: <53B445F5.6060709@libero.it>
Date: Wed, 02 Jul 2014 19:48:37 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/01/2014 11:30 AM, Qu Wenruo wrote:
> This commit has the following problem:
> 1) Break the ro mount rule.
> When users mount the whole btrfs ro, it is still possible to mount
> subvol rw and change the contents. Which make the whole fs ro mount
> non-sense.

Where is the problem ? I see an use case when I want a conservative default: mount all ro except some subvolumes.

In any case it is not a security problem because if the user has the capability to mount a subvolume, also he has the capability to remount,rw the whole filesystem.



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
