From: Josef Bacik <josef@redhat.com>
Subject: Re: device failure hangs the system
Date: Fri, 01 Jul 2011 16:14:37 -0400
Message-ID: <4E0E2AAD.1020406@redhat.com>
References: <4E0D929E.7030704@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0D929E.7030704@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/01/2011 05:25 AM, Anand Jain wrote:
> 
> hi,
> 
> Following test case causes my remote system to hard-hang and does
> not respond to any key strokes.
> 
> -----------
> # btrfs fi show
> failed to read /dev/sr0
> Label: none  uuid: 75ad3c9f-f661-498e-8c13-89d4e4c58312
>     Total devices 3 FS bytes used 28.00KB
>     devid    1 size 465.76GB used 2.02GB path /dev/sdb
>     devid    3 size 465.76GB used 2.01GB path /dev/sdd
>     devid    2 size 465.76GB used 1.01GB path /dev/sdc
> 
> Btrfs v0.19-35-g1b444cd
> ------------
> 
> 
> Stopping the disk
> ------------
> # echo 1 > /sys/block/sdd/device/delete
> ------------

Well that's a neat trick, do you have a way to undo that action too?
Seems a rescan doesn't make it show back up.  Please try the patch I
just posted to the list to fix this problem.  Thanks,

Josef
