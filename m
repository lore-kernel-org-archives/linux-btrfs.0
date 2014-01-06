Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:32834 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416AbaAFTZT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 14:25:19 -0500
Message-ID: <52CB031C.7060403@jrs-s.net>
Date: Mon, 06 Jan 2014 14:25:16 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>, Chris Samuel <chris@csamuel.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
References: <52C73987.7000106@jrs-s.net> <52C87A41.9030701@jrs-s.net> <05C97109-682D-4A62-B074-4EDCF8E9CE1E@colorremedies.com> <1416119.lWHlh5idGF@quad> <C7E0F781-5F46-4C76-BCC9-0DE416553046@colorremedies.com>
In-Reply-To: <C7E0F781-5F46-4C76-BCC9-0DE416553046@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FWIW, Ubuntu (and I presume Debian) will work just fine with a single / 
on btrfs, single or multi disk.

I currently have two machines booting to a btrfs-raid10 / with no 
separate /boot, one booting to a btrfs single disk / with no /boot, and 
one booting to a btrfs-raid10 / with an ext4-on-mdraid1 /boot.

On 01/06/2014 01:30 PM, Chris Murphy wrote:
> Color me surprised. Fedora 20 lets you create Btrfs raid1/raid0 for 
> rootfs, but due to a long standing grubby bug [1] /boot can't be on 
> Btrfs, so it's only ext4. 


