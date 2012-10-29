Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005Ab2J2NG2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 09:06:28 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9TD6SAb002762
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Oct 2012 09:06:28 -0400
Received: from where.rdu.redhat.com (dhcp129-218.rdu.redhat.com [10.13.129.218])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q9TD6Rms016224
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Oct 2012 09:06:27 -0400
Message-ID: <508E7F53.3020004@electronsweatshop.com>
Date: Mon, 29 Oct 2012 09:06:27 -0400
From: Randy Barlow <randy@electronsweatshop.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
References: <50899151.1070503@inwind.it> <201210281133.10571.Martin@lichtvoll.de> <508D0FC5.1020404@inwind.it> <201210281216.43983.Martin@lichtvoll.de> <017607D1-1C4E-47A9-9308-FFEB5737B440@colorremedies.com> <20121028190601.GJ2381@yeono.kjorling.se>
In-Reply-To: <20121028190601.GJ2381@yeono.kjorling.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/28/2012 03:06 PM, Michael Kjörling wrote:
> You_can_  calculate a worst case
> scenario figure (no compression possible on the new payload data), but
> that's about it.

Well, there are those humorous edge cases where you compress a tiny 
amount of uncompressible data, and the "compressed" version ends up 
being larger. Not sure if that applies to the specific algorithms that 
btrfs uses, but I've seen it happen with tiny datasets before. Even 
worst case could be hard to get right perhaps!

-- 
R
