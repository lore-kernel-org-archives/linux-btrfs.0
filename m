Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:4038 "EHLO server"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752631AbaAFME6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 07:04:58 -0500
Message-ID: <52CA9A97.4000803@shiftmail.org>
Date: Mon, 06 Jan 2014 12:59:19 +0100
From: joystick <joystick@shiftmail.org>
MIME-Version: 1.0
To: Andrea Mazzoleni <amadvance@gmail.com>
CC: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [RFC v2 0/2] New RAID library supporting up to six parities
References: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
In-Reply-To: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/01/2014 10:31, Andrea Mazzoleni wrote:
> Hi,
>
> This is a port to the Linux kernel of a RAID engine that I'm currently using
> in a hobby project called SnapRAID. This engine supports up to six parities
> levels and at the same time maintains compatibility with the existing Linux
> RAID6 one.
>

This is just great Andrea,
thank you for such Epiphany present.

Just by looking at the Subjects, it seems patch number 0/1 is missing. 
It might have not gotten through to the lists, or be a numbering mistake.

Does your code also support (shortcut) RMW as opposed to RCW, for all 
parities?
RMW is: for a 4k write: read just nparities+1data disks, recompute 
parities, write nparities+1data disks,
RCW is: "read all disks" prior to recompute parities...

Part of such RMW code should be in handle_stripe_dirtying which is not 
in your patch 0/2 but that might have been in patch 0/1 which apparently 
didn't get through.

See this patch by Kumar for support of RMW in raid6 (raid5 has it) which 
unfortunately apparently wasn't merged up to now:
http://marc.info/?l=linux-raid&m=136624783417452&w=2

Thank you
J.

