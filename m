Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57688 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab2JKCH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Oct 2012 22:07:59 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q9B27tYS028969
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2012 10:07:55 +0800
Message-ID: <5076299D.2050605@cn.fujitsu.com>
Date: Thu, 11 Oct 2012 10:06:21 +0800
From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: introduce '-p' option and <fullpath> into
 subvolume set-default command
References: <1348468933-14839-1-git-send-email-chenyang.fnst@cn.fujitsu.com> <20121009144406.GR4405@twin.jikos.cz>
In-Reply-To: <20121009144406.GR4405@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-9 22:44, David Sterba wrote:
> On Mon, Sep 24, 2012 at 02:42:13PM +0800, Chen Yang wrote:
>> In command "btrfs subvolume set-default", we used subvolume <id> and <path>
>> to set the default subvolume of a filesystem. It's not easy for a common
>> user,
> 
> What is not easy? How often do you set-default subvolume that it's a
> concern to do it in two steps (list and set-default)?
> 
This patch is mean to improve the UI
If the description above if improper, I will fix it.

>> so I improved it and the <fullpath> of a subvolume can be used to
>> set the default subvolume of a filesystem.
> 
> Setting the default directly from a given path would be a good UI
> improvement.
> 
>> @@ -601,23 +602,66 @@ static int cmd_subvol_get_default(int argc, char **argv)
>>  static const char * const cmd_subvol_set_default_usage[] = {
>> -	"btrfs subvolume set-default <subvolid> <path>",
>> +	"btrfs subvolume set-default [-p] [<subvolid>] <path>",
> 
> This new syntax allows these forms:
> 
> 	1. set-default /path
The "path" must be a subvolume path
> 	2. set-default -p /path
The "path" can be any path under a mount point, if path is not a subvolume, 
The parent tree (subvolume) of the path will be find out and set to be default
> 	3. set-default id /path
current behaviour
> 	4. set-default -p id /path
Error! The improper description of the usage causes this misuse, I will fix it.
> 
> 3 is the current behaviour, can you please explain the rest to me? I'm
> afraid I'm not following the idea.
> 
I'm sorry to make you confused for giving an unclear usage about the new option of the command. 
I'm writing a new version. I will send it later.

>>  	"Set the default subvolume of a filesystem",
>> +	"-p    Set the parent tree(subvolume) of the PATH",
>> +	"      as the default subvolume, if PATH is not a subvolume",
> 
> "if PATH is not a subvolume" -- so I don't specify the mountpoint for
> PATH and I'm supposed to know if the path is or is not a subvolume --
> this is another step I need to do (because I want to be sure that I'm
> setting the right subvol), this does not save the commands compared to
> the current status.
The option “-p” is only used like this “set-default -p /path”, 
if PATH is not a subvolume -p" will help to find the parent tree (subvolume) of the PATH, and set it default.
> 
>>  	NULL
>>  };
> 
> thanks,
> david
> 

thanks for your advise,
chen yang
