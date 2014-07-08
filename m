Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47895 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754022AbaGHUUo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jul 2014 16:20:44 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs and mount in gentoo linux
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53BC4172.8080300@xunil.at>
Date: Tue, 8 Jul 2014 14:20:41 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <A8D31CAA-14AC-407E-96BB-34E0ACF7F452@colorremedies.com>
References: <53BC4172.8080300@xunil.at>
To: lists@xunil.at
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 8, 2014, at 1:07 PM, Stefan G. Weichinger <lists@xunil.at> wrote:
> 
> Can you tell me where the problem/solution might be located?
> Is it a known behavior in a way … ?

It's known. Ubuntu has a patch so that mount shows subvolume names. This information is probably available on Gentoo with cat /proc/self/mountinfo.


Chris Murphy

