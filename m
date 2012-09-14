Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51811 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2INNEE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 09:04:04 -0400
Message-ID: <50532B3D.7060606@oracle.com>
Date: Fri, 14 Sep 2012 21:03:57 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/5] Btrfs: fix deadlock with freeze and sync
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com> <20120914124234.GJ12994@localhost.localdomain>
In-Reply-To: <20120914124234.GJ12994@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/14/2012 08:42 PM, Josef Bacik wrote:
> On Fri, Sep 14, 2012 at 02:58:03AM -0600, Liu Bo wrote:
>> While testing xfstests 068, I realized that
>>
>> commit bd7de2c9a449e26a5493d918618eb20ae60d56bd
>> (Btrfs: fix deadlock with freeze and sync V2)
>>
>> did not fix the bug yet, since someone might jump in between checking
>> running transaction and joining transaction, and we may still run into
>> deadlock between freeze and sync.
>>
>> So IMO the safest and most efficient way is to check running transaction
>> in joining a transaction directly.
>>
>> With this patch, I tested xfstests 068 for 120 times and it did not get
>> into deadlock at least here.
>>
> 
> This doesn't do anything since sync() won't have a transaction already started
> so this will always just return and we won't do a commit, NAK.  Thanks,
> 

Yeah, I'm digging this one, there is something wrong elsewhere, and Miao has pointed my fault :)

thanks,
liubo

> Josef
> 

