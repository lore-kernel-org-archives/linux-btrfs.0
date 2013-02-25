Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759631Ab3BYXhJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 18:37:09 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1PNb9HG027670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 18:37:09 -0500
Message-ID: <512BF5A1.8040404@redhat.com>
Date: Mon, 25 Feb 2013 17:37:05 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/17] btrfs-progs: Unify size-parsing
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com> <1361832890-40921-2-git-send-email-sandeen@redhat.com> <20130225232651.GE1658@lenny.home.zabbo.net>
In-Reply-To: <20130225232651.GE1658@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/25/13 5:26 PM, Zach Brown wrote:
>>  		case 'e':
>>  			mult *= 1024;
>> +			/* Fallthrough */
> 
> These comments still annoy me :).  

it shuts up coverity & other static checkers which are worried about
a missing break...

> And really, that code kind of annoys
> me too.  That's a lot of duplicated code for a mapping of characters to
> powers of 1024.
> 
> How about.. 
> 
> u64 pow_u64(u64 x, unsigned y)
> {
> 	u64 ret = 1;
> 
> 	while (y--)
> 		ret *= x;
> 
> 	return ret;
> }
> 
> u64 get_mult(char unit)
> {
> 	static char *units = "bkmgtpe";
> 	char *found = index(units, unit);
> 
> 	if (found)
> 		return pow_u64(1024, found - units);
> 	return 0;
> }
> 
> Seems like a lot less noise for the same functionality.

If you want to submit that patch as a further cleanup I'd review it ;)

But TBH (going out on a limb crossing Zach here ;) my feeble brain
is easily confused by your clever code.  I'd rather just do the
simple thing simply...

-Eric

> - z
> 

