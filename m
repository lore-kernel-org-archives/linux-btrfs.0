From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH] btrfs: change resize ioctl to take device path instead
 of id
Date: Mon, 09 Jan 2012 10:15:15 -0500
Message-ID: <4F0B0483.4090702@cfl.rr.com>
References: <1323659529-2632-1-git-send-email-psusi@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1323659529-2632-1-git-send-email-psusi@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

Bump.

On 12/11/2011 10:12 PM, Phillip Susi wrote:
> The resize ioctl took an optional argument that was a string
> representation of the devid which you wish to resize.  For
> the sake of consistency with the other ioctls that take a
> device argument, I converted this to take a device path instead
> of a devid number, and look up the number from the path.
