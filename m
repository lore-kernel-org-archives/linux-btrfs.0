Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38219 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3AaDPH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 22:15:07 -0500
Message-ID: <5109E14D.4020706@oracle.com>
Date: Thu, 31 Jan 2013 11:13:17 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: dsterba@suse.cz, gene@czarc.net, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/12] Btrfs-progs: add show subcommand to subvol cli
In-Reply-To: <5108F6D6.4030601@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1359442141-25498-1-git-send-email-anand.jain@oracle.com>
 <1359442141-25498-11-git-send-email-anand.jain@oracle.com>
 <5108F6D6.4030601@gmail.com>


Wang,

>> +	ret = 0;
>> +	/* print the info */
>      I think it will be better if you can move the following
>      printing to a function..it will make the code more clear and
>      readable..

  Thanks for looking into this. However IMO there is no need
  "as of now".  This can be taken when there is more reasonable
  need. I hope you would agree with me.

-Anand
