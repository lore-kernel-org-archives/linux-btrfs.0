Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay004-omc1s20.hotmail.com ([65.54.190.31]:62697 "EHLO
	BAY004-OMC1S20.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754299AbbGBRBY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jul 2015 13:01:24 -0400
Message-ID: <BAY172-W3707C04E506E5EF57EC1F2B0970@phx.gbl>
From: Kyle Gates <kylegates@hotmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: possible enhancement: failing device converted to a seed device
Date: Thu, 2 Jul 2015 12:01:23 -0500
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'll preface this with the fact that I'm just a user and am only posing a question for a possible enhancement to btrfs.
 
I'm quite sure it isn't currently allowed but would it be possible to set a failing device as a seed instead of kicking it out of a multi-device filesystem? This would make the failing device RO, while keeping the filesystem as a whole RW thereby allowing the user additional protection when recovering/balancing. Is this a feasible/realistic request?
 
Thanks,
Kyle  		 	   		  