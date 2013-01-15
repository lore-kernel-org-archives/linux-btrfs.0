Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57800 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab3AOOtO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 09:49:14 -0500
Date: Tue, 15 Jan 2013 06:49:13 -0800
From: Marc MERLIN <marc@merlins.org>
To: David Brown <btrfs@davidb.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can moving data to a subvolume not take as long as a fully copy?
Message-ID: <20130115144912.GB5890@merlins.org>
References: <20130114173250.GA23026@merlins.org> <87libvaqlp.fsf@davidb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87libvaqlp.fsf@davidb.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 14, 2013 at 10:48:50PM -0800, David Brown wrote:
> Why not make a snapshot of the root volume, and then delete the files
> you want to move from the original root, and delete the rest of root
> from the snapshot?

Are a snapshot of the root volume and a subvolume effectively the same thing
as far as btrfs sees them?
Once I have that snapshot which I'll treat as a subvolume, can I then
snapshot that snapshot/subvolume further?

If so, that's definitely a good way of doing this for next time.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
