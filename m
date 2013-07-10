Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32520 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab3GJDiw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jul 2013 23:38:52 -0400
Message-ID: <51DCD86C.7020001@oracle.com>
Date: Wed, 10 Jul 2013 11:43:40 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: update usage message for cmds-restore
References: <1373401897-31850-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1373401897-31850-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Thanks.

> -	"btrfs restore [options] <device>",
> +	"btrfs restore [options] <device> <path> | btrfs restore -l <device>",

  should this be rather...

"btrfs restore [options] <device> <path> | -l <device>",


Thanks
Anand
