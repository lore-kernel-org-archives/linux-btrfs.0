From: Josef Bacik <josef@redhat.com>
Subject: Re: question about percentage utilization...
Date: Tue, 03 May 2011 10:54:45 -0400
Message-ID: <4DC01735.20801@redhat.com>
References: <4DB865DB.7080600@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "K. Richard Pixley" <rich@noir.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DB865DB.7080600@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/27/2011 02:52 PM, K. Richard Pixley wrote:
> At what percentage utilization are folks typically seeing "no space left
> on device"?
>
> And what would constitute "pathological" values worth reporting and/or
> offering up as debugging instances?
>

Well if you are having problems let us know what you are seeing and then 
we can tell you :).  Be sure to include

df
btrfs fi df /your/mount/point
btrfs-show

Thanks,

Josef
