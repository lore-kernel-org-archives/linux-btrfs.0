Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26919 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab3IBCve (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 22:51:34 -0400
Message-ID: <5223FECB.3010601@oracle.com>
Date: Mon, 02 Sep 2013 10:58:19 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs: v3, move out print in cmd_df to another function
References: <5222db6c.+9oeJwhGj6njPuoK%wangshilong1991@gmail.com>
In-Reply-To: <5222db6c.+9oeJwhGj6njPuoK%wangshilong1991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Wang, kindly note that this was fixed in v4.

Anand


On 09/01/2013 02:15 PM, Wang Shilong wrote:
> Hello, Using checkpatch.pl, i get the following warnings(errors):
> ERROR: "foo * bar" should be "foo *bar"
> #37: FILE: cmds-filesystem.c:47:
> +static char * group_type_str(u64 flag)
>
> ERROR: "foo * bar" should be "foo *bar"
> #69: FILE: cmds-filesystem.c:63:
> +static char * group_profile_str(u64 flag)
>
> total: 2 errors, 0 warnings, 229 lines checked
>
> patch has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
>
> Thanks, Wang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
