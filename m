Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37567 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbbLaGRk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 01:17:40 -0500
Date: Wed, 30 Dec 2015 21:15:44 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Runs the xor function if a Block has failed
Message-ID: <20151230211544.32bc337e@gmail.com>
In-Reply-To: <20151230171826.GG4227@twin.jikos.cz>
References: <1451456916-16520-1-git-send-email-jpage.lkml@gmail.com>
	<20151230171826.GG4227@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 30 Dec 2015 18:18:26 +0100
David Sterba <dsterba@suse.cz> wrote:

> That's just the comment copied, the changelog does not explain why
> it's ok to do just the run_xor there. It does not seem trivial to me.
> Please describe that the end result after the code change is expected.

In the RAID 6 case after a failure, we discover that the failure
affected the entire P stripe, without any bad data occurring. Hence, we
xor the previously stored parity data to return the data that was lost
in the P stripe failure.

The xor-red data is from the parity blocks. Hence, we are left with 
recovered data belonging to the P stripe.

If there is an error during the completion of the xor (provided by the
patch ), we got to the cleanup function.

Hope that is satisfactory.
