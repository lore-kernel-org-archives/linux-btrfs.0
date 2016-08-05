Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:40112 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161597AbcHEPzp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Aug 2016 11:55:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 06 Aug 2016 00:55:43 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Input/output error, nothing appended in dmesg
In-Reply-To: <e03fc4983421a31251c6f6274dd2c597@admin.virtall.com>
References: <ff95214f4e2dd819d42dee7dff5f6580@admin.virtall.com>
 <9fdb317f-9209-d1a7-3e1e-7ab4f5b09c8d@fb.com>
 <fe633b0f3cc110bc5520db164e54dfe3@admin.virtall.com>
 <98e070f7-2787-9df4-c1b8-ae8005c039ec@fb.com>
 <e8e15af203f0f559d46402ee6a296209@admin.virtall.com>
 <e03fc4983421a31251c6f6274dd2c597@admin.virtall.com>
Message-ID: <6a5c8e813a91f4edbf7353e55e87bd4a@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-06 00:45, Tomasz Chmielewski wrote:

> And, miracle cure O_o
> 
> # file ./2016-08-02/serverX/syslog.log
> ERROR: cannot read `./2016-08-02/serverX/syslog.log' (Input/output 
> error)
> 
> # echo 3 > /proc/sys/vm/drop_caches
> 
> # file 2016-08-02/serverX/syslog.log
> 2016-08-02/serverX/syslog.log: ASCII text, with very long lines
> 
> # cat 2016-08-02/serverX/syslog.log
> (...)

A few mins after the previous "echo 3 > /proc/sys/vm/drop_caches" (this 
file is around 1.5 MB and wasn't touched since 2016-06-21):

# file ./2016-06-21/serverY/nginx-dashboard-error.log
./2016-06-21/serverY/nginx-dashboard-error.log: ERROR: cannot read 
`./2016-06-21/serverY/nginx-dashboard-error.log' (Input/output error)

# echo 3 > /proc/sys/vm/drop_caches

# file ./2016-06-21/serverY/nginx-dashboard-error.log
./2016-06-21/serverY/nginx-dashboard-error.log: ASCII text, with very 
long lines

# cat ./2016-06-21/serverY/nginx-dashboard-error.log
(...works OK, no corruption...)


Tomasz Chmielewski
https://lxadm.com
