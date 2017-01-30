Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:44897 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751371AbdA3U1p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 15:27:45 -0500
Subject: Re: btrfs recovery
To: Michael Born <Michael.Born@aei.mpg.de>, linux-btrfs@vger.kernel.org
References: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <5e1bf7ad-ab7a-8fbd-1028-3a3f5d9a4013@mendix.com>
Date: Mon, 30 Jan 2017 21:27:42 +0100
MIME-Version: 1.0
In-Reply-To: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/30/2017 09:02 PM, Michael Born wrote:
> Hi btrfs experts.
> 
> Hereby I apply for the stupidity of the month award.
> But, maybe you can help me restoring my dd backup or extracting some
> files from it?
> 
> Before switching from Suse 13.2 to 42.2, I copied my / partition with dd
> to an image file - while the system was online/running.
> Now, I can't mount the image.

Making a block level copy of a filesystem while it is online and being
modified has a near 100% chance of producing a corrupt result.

Simply think of the fact that something gets written somewhere at the
end of the disk which also relates to something that gets written at the
beginning of the disk, while your dd copy is doing its thing somewhere
in between...

-- 
Hans van Kranenburg
