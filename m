Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab3JIBGW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Oct 2013 21:06:22 -0400
Date: Tue, 8 Oct 2013 18:06:16 -0700
From: Zach Brown <zab@redhat.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: regression, can't move subvols into subvols
Message-ID: <20131009010616.GW25712@lenny.home.zabbo.net>
References: <459265C7-5E22-4F5B-A69C-A5A6AC455495@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <459265C7-5E22-4F5B-A69C-A5A6AC455495@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 08, 2013 at 03:58:23PM -0600, Chris Murphy wrote:
> I don't think this is expected, is it? I can no longer move a
> subvolume into another subvolume. I can move a subvolume into a
> directory. This happens with 3.11.3, and 3.12 rc4. I'm not sure yet
> when the regression first appeared.

If you revert 

commit 9c52057c698fb96f8f07e7a4bcf4801a092bda89
Author: Chris Mason <chris.mason@fusionio.com>
Date:   Mon Dec 17 14:26:57 2012 -0500

    Btrfs: fix hash overflow handling

Does it still fail?

I have some guesses, but I really don't know this code, and I'm needed
upstairs to feed a toddler at this *precise* moment :).

- z
