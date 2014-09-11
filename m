Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18943 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaIKCfh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 22:35:37 -0400
Date: Thu, 11 Sep 2014 10:35:26 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Deadlock with 3.15.10
Message-ID: <20140911023525.GA9414@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAFvQSYQBTViupkLThmaxXNQ8is1ohO-3+0E=wwwP1WdETtHz5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFvQSYQBTViupkLThmaxXNQ8is1ohO-3+0E=wwwP1WdETtHz5w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Sep 10, 2014 at 06:44:10PM +0200, Clemens Eisserer wrote:
> Hi,
> 
> I've recently run into a deadlock on 3.15.10, don't know if the kernel
> stack-trace is useful: http://pastebin.com/guQNDAMX

Thanks for the report.

FYI, this's been fixed by https://patchwork.kernel.org/patch/4727711/

thanks,
-liubo

> 
> Br, Clemens
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
