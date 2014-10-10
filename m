Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42193 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750786AbaJJElo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 00:41:44 -0400
Received: from cablepool1-225.stoweaccess.com ([199.188.178.225]:61840 helo=[192.168.2.7])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XcS1Q-001XYi-1G
	for linux-btrfs@vger.kernel.org; Thu, 09 Oct 2014 22:41:44 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Confusion with newly converted filesystem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAAKzf7=XxK0FXtSrMtFou-gZ9DDYJtuHFy4R5cdjQFjBm0urvg@mail.gmail.com>
Date: Fri, 10 Oct 2014 00:41:41 -0400
Message-Id: <4AC5138B-075A-45C9-BEEE-94A38CE8FE3C@colorremedies.com>
References: <CAAKzf7nLzh1ck7YK8z_E3fx1hK5zWLbKRh1NiG5oVpxuaGtO7Q@mail.gmail.com> <CAAKzf7=XxK0FXtSrMtFou-gZ9DDYJtuHFy4R5cdjQFjBm0urvg@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Oct 9, 2014, at 2:58 PM, Tim Cuthbertson <ratcheer@gmail.com> wrote:

> Never mind. I have stumbled my way into a solution.
> 
> I ran "btrfs subv delete /ext2_saved". Then I ran "btrfs balance start
> /". That relocated 15 of 15 chunks. Now fi show shows 2.03 GB used on
> each device and fi df shows 1 GB of metadata total.
> 
> Apparently, that saved ext4 subvolume was a real mess.


Not a mess, it's just a side effect of the conversion while it's still reversible. It's kinda both ext3/4 and Btrfs at the same time after conversion. You can even still mount the snapshot as ext3/4. Once you're ready to commit to Btrfs and not use the ext rollback snapshot, deleting it and balancing completes the conversion. It's more of a metadata duplication via in-line migration.

Chris Murphy