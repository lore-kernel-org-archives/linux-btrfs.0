From: John Dong <jdong@ubuntu.com>
Subject: Re: btrfsctl -d race with df -h causes hang?
Date: Sun, 22 Nov 2009 11:42:36 -0500
Message-ID: <56546E3D-061B-4BEC-AFC3-CB13CA88C620@ubuntu.com>
References: <549778BA-0D47-458D-8CE1-022885B2A2BB@ubuntu.com> <30183CDB-9359-493D-B400-3312291C968B@ubuntu.com> <900EA6DB-EECC-4BA8-B551-1A6831949824@ubuntu.com> <20091120153527.GW3110@think>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091120153527.GW3110@think>
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 20, 2009, at 10:35 AM, Chris Mason wrote:

>  We've
> probably got a lock inversion hiding in the df handling.


Hi Chris, just an update; I've been able to get the hang to happen without issuing df. It seems like the btrfsctl -d activity combined with -o compress is enough to trigger it.