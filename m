Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:55931 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbcHEOoI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Aug 2016 10:44:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 05 Aug 2016 23:44:04 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Input/output error, nothing appended in dmesg
In-Reply-To: <9fdb317f-9209-d1a7-3e1e-7ab4f5b09c8d@fb.com>
References: <ff95214f4e2dd819d42dee7dff5f6580@admin.virtall.com>
 <9fdb317f-9209-d1a7-3e1e-7ab4f5b09c8d@fb.com>
Message-ID: <fe633b0f3cc110bc5520db164e54dfe3@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-05 23:26, Chris Mason wrote:
> On 08/05/2016 07:42 AM, Tomasz Chmielewski wrote:
>> I'm getting occasional (every few weeks) input/output errors on a 
>> btrfs
>> filesystem with compress-force=zlib, running on Amazon EC2, with 4.5.2
>> kernel:
>> 
>> # cat 2016-08-02/serverX/syslog.log
>> cat: 2016-08-02/serverX/syslog.log: Input/output error
> 
> How big is the file?  We had one bug with inline files that might have
> caused this.

This one's tiny, 158137 bytes.



Tomasz Chmielewski
https://lxadm.com
