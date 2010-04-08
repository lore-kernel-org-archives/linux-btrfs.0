From: Harshavardhana <harsha@gluster.com>
Subject: Re: ENOTEMPTY on "rm -rf" for snapshot and subvolume
Date: Thu, 08 Apr 2010 14:14:14 -0700
Message-ID: <4BBE4726.2070708@gluster.com>
References: <4BBD26E4.7070106@gluster.com> <20100408135216.GE1400@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100408135216.GE1400@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/08/2010 06:52 AM, Chris Mason wrote:
>> >        But either in that case too returning ENOTEMPTY does confuse a
>> >  user a lot. Isn't it valid
>> >        just by returning EPERM will explain a lot to users saying that
>> >  this is a snapshot of a
>> >        subvolume or a parent subvolume which is not supposed to be
>> >  deleted this way.
>>      
> Good point, eperm might be more intuitive.
>
> -chris
>    
Thanks a lot for the inputs sent a patch for that.

Regards

-- 
Harshavardhana
http://www.gluster.com

