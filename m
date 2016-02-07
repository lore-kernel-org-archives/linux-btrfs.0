Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31.italiaonline.it ([212.48.25.159]:52892 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750997AbcBGU0N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 7 Feb 2016 15:26:13 -0500
Reply-To: kreijack@inwind.it
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
 <56B412FC.8060007@oracle.com> <56B71777.7050609@gmx.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Anand Jain <anand.jain@oracle.com>,
        Moviuro <moviuro@gmail.com>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <56B7A861.2060802@inwind.it>
Date: Sun, 7 Feb 2016 21:26:09 +0100
MIME-Version: 1.0
In-Reply-To: <56B71777.7050609@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-07 11:07, Qu Wenruo wrote:
> +1 too.
> 
> But first in C, then python wrapper.
> 
> Not sure why there is no such libbtrfs for C wrapper of btrfs ioctls.
> 
> Maybe just because current btrfs ioctl is too easy to use?

Unfortunately no. 

I think the main problem of writing a libbtrfs, is the code changes needed. 
In fact in order to avoid code duplication (and to have more testing), the btrfs command has to be a client of libbtrfs. But it is not easy: you have to refactoring the error handling and the message printing...

> AFAIK, systemd (container storage part) calls btrfs ioctl directly, especially for subvolume/snapshot creation mainly > because the design of them are quite easy.

Also udev does the same (I don't remember if this happened before or after it went under the systemd umbrella).

I remember a case where it was impossible to change the semantic of BTRFS_IOC_DEVICES_READY: on the basis of its name, it could be seems that this ioctl should _only_ check if a filesystem is ready. Unfortunately it register also the device [1].
It was discussed in the ML to change its semantic, but having already widespread client  like udev it was impossible to do (even tough we could discuss to change their name)


> Thanks,
> Qu 


BR
G.Baroncelli


[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=772744
