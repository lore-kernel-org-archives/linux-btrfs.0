From: John Dong <jdong@johndong.com>
Subject: Re: btrfsctl -d race with df -h causes hang?
Date: Wed, 2 Dec 2009 01:30:39 -0500
Message-ID: <DBE1C27D-386C-4B4B-82A0-F01C4281EF01@johndong.com>
References: <549778BA-0D47-458D-8CE1-022885B2A2BB@ubuntu.com> <30183CDB-9359-493D-B400-3312291C968B@ubuntu.com> <900EA6DB-EECC-4BA8-B551-1A6831949824@ubuntu.com> <20091120153527.GW3110@think> <56546E3D-061B-4BEC-AFC3-CB13CA88C620@ubuntu.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: John Dong <jdong@ubuntu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <56546E3D-061B-4BEC-AFC3-CB13CA88C620@ubuntu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Anything else I can do to help? I can definitely still consistently reproduce this behavior...


On Nov 22, 2009, at 11:42 AM, John Dong wrote:

> 
> On Nov 20, 2009, at 10:35 AM, Chris Mason wrote:
> 
>> We've
>> probably got a lock inversion hiding in the df handling.
> 
> 
> Hi Chris, just an update; I've been able to get the hang to happen without issuing df. It seems like the btrfsctl -d activity combined with -o compress is enough to trigger it.--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

