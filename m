From: Arne Jansen <sensille@gmx.net>
Subject: Re: Synchronous snapshot delete
Date: Wed, 21 Mar 2012 12:44:57 +0100
Message-ID: <4F69BF39.5090708@gmx.net>
References: <4F695302.4060809@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F695302.4060809@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

On 21.03.2012 05:03, Anand Jain wrote:
> 
> Hi Team,
> 
>  Could you let me know if you are working on..
> 
>    Synchronous snapshot delete  (or similar)
> 
>  few requested for this feature, just wanted
>  to know if anyone has picked up this and is
>  working on it.

I'm not working directly on that feature, but I'm reworking
the snapshot deletion process to make use of the metadata
readahead. This should touch only very slightly the code that
needs adjustment for sync snapshot deletion.
Another thing you could add while you fiddle with this interface
would be the capability to trigger the deletion of several snapshots
in one transaction. This would speed up the process if you want
to delete hundreds or thousands of snapshots.

-Arne

> Thanks, Anand
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

