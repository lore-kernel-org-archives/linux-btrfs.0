Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab3BYX0w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 18:26:52 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1PNQqPU009745
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 18:26:52 -0500
Date: Mon, 25 Feb 2013 15:26:51 -0800
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/17] btrfs-progs: Unify size-parsing
Message-ID: <20130225232651.GE1658@lenny.home.zabbo.net>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
 <1361832890-40921-2-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361832890-40921-2-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>  		case 'e':
>  			mult *= 1024;
> +			/* Fallthrough */

These comments still annoy me :).  And really, that code kind of annoys
me too.  That's a lot of duplicated code for a mapping of characters to
powers of 1024.

How about.. 

u64 pow_u64(u64 x, unsigned y)
{
	u64 ret = 1;

	while (y--)
		ret *= x;

	return ret;
}

u64 get_mult(char unit)
{
	static char *units = "bkmgtpe";
	char *found = index(units, unit);

	if (found)
		return pow_u64(1024, found - units);
	return 0;
}

Seems like a lot less noise for the same functionality.

- z
