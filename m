Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41466 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab3KWD7T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 22:59:19 -0500
Message-ID: <52902808.8020706@oracle.com>
Date: Sat, 23 Nov 2013 11:59:04 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Daniel Pocock <daniel@pocock.com.au>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Nagios probe for btrfs RAID status?
References: <528F6085.4020603@pocock.com.au>
In-Reply-To: <528F6085.4020603@pocock.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> For example, would the command
>
>      btrfs filesystem show --all-devices
>
> give a non-zero error status or some other clue if any of the devices
> are at risk?

  No there isn't any good way as of now. that's something to fix.

Thanks, Anand
