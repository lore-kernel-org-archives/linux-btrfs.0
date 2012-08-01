Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:44369 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab2HAP4c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 11:56:32 -0400
Message-ID: <501951A9.4070809@oracle.com>
Date: Wed, 01 Aug 2012 23:56:25 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] add crtime to the snapshot list
References: <1343822481-26707-1-git-send-email-Anand.Jain@oracle.com> <CAB9VWqCcNhUVX3CsZeCar07TYr2hXuw+-A_wDbb4uNstLr_9Fg@mail.gmail.com>
In-Reply-To: <CAB9VWqCcNhUVX3CsZeCar07TYr2hXuw+-A_wDbb4uNstLr_9Fg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>   Eg output:
>>     #btrfs su list -s 1 /btrfs
>>     ID 258 gen 39 cgen 6 top level 5 crtime 2012-07-27 17:43:55 path ss1
>>     ID 260 gen 8 cgen 8 top level 5 crtime 2012-07-27 17:47:51 path ss2
>>     ID 263 gen 16 cgen 16 top level 5 crtime 2012-07-29 00:50:19 path ss3
>>     ID 264 gen 25 cgen 25 top level 5 crtime 2012-07-30 09:56:50 path sv1/.snap
> Is it possible to rename crtime to otime? I used otime to refer
> creation time all the time. Using crtime could be confusing, as ctime
> is the change time and rtime is the receive time.

  Yeah.  Will rename it to otime

  just to mention the choices were..
      Birth-time (as in stat output), crtime and otime.

Thanks, Anand
