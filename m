From: "K. Richard Pixley" <rich@noir.com>
Subject: Re: can't unmount
Date: Thu, 12 Aug 2010 08:58:41 -0700
Message-ID: <4C641A31.4090603@noir.com>
References: <4C641969.9070405@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C641969.9070405@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

  And should I be worried about what umount -l might be leaving behind?  
(eg, any unfreed kernel resources)  Or is that a reasonable way to deal 
with this situation on an ongoing basis?

--rich

On 8/12/10 08:55 , K. Richard Pixley wrote:
>  I'm running into a situation where I can't unmount a mounted 
> snapshot.  It shows "busy" even though neither lsof nor fuser show any 
> open files.  Umount -f doesn't work although umount -l does.
>
> Is there anything else I can do to debug this scenario or to clear the 
> busy status myself?  Or am I down to rebooting each time?
>
> This is on stock ubuntu-10.04, x86.
>
> --rich
