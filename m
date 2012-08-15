Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58941 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab2HOCs5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 22:48:57 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1T1TfE-0003fY-PR
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 19:48:56 -0700
Date: Tue, 14 Aug 2012 19:48:56 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: linux 3.5.0: BTRFS error in compress_file_range:581 (failed to join transaction)
Message-ID: <20120815024856.GL12659@merlins.org>
References: <20120814182314.GF12659@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120814182314.GF12659@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 14, 2012 at 11:23:14AM -0700, Marc MERLIN wrote:
> My laptop oopsed due to a wireless bug
> 
> When I rebooted, the system came back ok, and seemed to work, but soon went
> to read only with the error in the subject line.
> 
> I have hourly snapshots for each of the 5 subvolumes in that btrfs
> filesystem.
> 
> How do I recover from this? Revert all the snapshots one hour, find/guess
> which one caused the problem somehow and revert just that one? (the error
> message didn't give a subvolume or directory).
> 
> Also, before I do this, is there debug info I can get off my system?

I'm likely to have to do this tonight to get back to a working system.

If someone wants debug info before I lose it potentially, please ask soon ;)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
