Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33658 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbcCDC6a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 21:58:30 -0500
Subject: Re: how many chunk trees and extent trees present
To: dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>,
        sri <toyours_sridhar@yahoo.co.in>, linux-btrfs@vger.kernel.org
References: <loom.20150417T081705-332@post.gmane.org>
 <20150417091911.GK22084@carfax.org.uk> <20150417172928.GT25622@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56D8F9C7.70609@oracle.com>
Date: Fri, 4 Mar 2016 10:58:15 +0800
MIME-Version: 1.0
In-Reply-To: <20150417172928.GT25622@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/18/2015 01:29 AM, David Sterba wrote:
> On Fri, Apr 17, 2015 at 09:19:11AM +0000, Hugo Mills wrote:
>>> In, some article i read that future there will be more chunk tree/ extent
>>> tree for single btrfs. Is this true.
>>
>>     I recall, many moons ago, Chris saying that there probably wouldn't
>> be.
>
> More extent trees tied to a set of fs trees/subvolumes would be very
> useful for certain usecases *cough*encryption*cough*.

  I didn't understand in full what's the idea here, but let met try..
  would it not defeat the purpose of encryption which is not to let
  disk have the un-encrypted data ? Looks like I am missing something
  here.

Thanks, Anand
