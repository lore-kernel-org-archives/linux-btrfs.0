From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: Device files on read-only file systems?
Date: Mon, 15 Aug 2011 13:19:06 -0400
Message-ID: <4E49550A.1040204@suse.de>
References: <4E491AFC.5030403@suse.de> <1313420293-sup-2507@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1313420293-sup-2507@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/15/2011 10:58 AM, Chris Mason wrote:
> Excerpts from Jeff Mahoney's message of 2011-08-15 09:11:24 -0400:
>> Hi all -
>>
>> btrfs_permission currently returns -EROFS when the root is set read-only
>> and the open is requested read-write. It doesn't make an exception for
>> device files. Is this intentional?
>
> No, definitely not intentional.

Ok. I'll post a patch in a few minutes.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
