From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Creation of pseudo items leads to (seemingly) duplicate inodes
 (BUG inside)
Date: Wed, 19 Oct 2011 12:11:44 +0200
Message-ID: <4E9EA260.9010107@jan-o-sch.net>
References: <4E9DA301.5050907@jan-o-sch.net> <20111018190401.GB31908@zambezi.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Ilya Dryomov <idryomov@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111018190401.GB31908@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On 18.10.2011 21:04, Ilya Dryomov wrote:
> On Tue, Oct 18, 2011 at 06:02:09PM +0200, Jan Schmidt wrote:
>> Reproducer for the curious:
>>
>> # mkfs.btrfs /dev/sdv2
>> # mount /dev/sdv2 /mnt
>> # btrfs subvol snap /mnt /mnt/snap1
>> # btrfs subvol snap /mnt /mnt/snap2
>> # btrfs subvol snap /mnt /mnt/snap3
>>
>> When snap2 was created, there was a dir item for snap1, so this is no
>> surprise:
>>
>> # ls -lai /mnt/snap2
>> total 8
>> 256 dr-xr-xr-x 1 root root 20 Jan  1  1970 .
>> 256 dr-xr-xr-x 1 root root 30 Jan  1  1970 ..
>>   2 drwxr-xr-x 1 root root  0 Oct 18 16:25 snap1
>>
>> Inode 2 seems a bit strange, but stay tuned. When snap3 was created,
>> there were dir items for snap1 and snap2, so ... *drumroll*
>>
>> # ls -lai /mnt/snap3
>> total 8
>> 256 dr-xr-xr-x 1 root root 30 Jan  1  1970 .
>> 256 dr-xr-xr-x 1 root root 30 Jan  1  1970 ..
>>   2 drwxr-xr-x 1 root root  0 Oct 18 16:26 snap1
>>   2 drwxr-xr-x 1 root root  0 Oct 18 16:26 snap2
> 
> The way I see it it's expected, at least conceptually.  There might be

I'm sure this violates some specification, and yes, I agree, it's
conceptually. Let's wait for some real complaints :-)

Jan

> something wrong in the implementation that confuses dcache, etc.  I'll
> take a look and try to fix it if nobody beats me.
> 
> Thanks,
> 
> 		Ilya
