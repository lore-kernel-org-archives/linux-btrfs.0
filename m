Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.201]:58567 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbaCaQ0l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 12:26:41 -0400
Message-ID: <533995F7.7040606@gmx.com>
Date: Mon, 31 Mar 2014 12:21:11 -0400
From: "sepero111@gmx.com" <sepero111@gmx.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Especially broken btrfs
References: <532BB037.90401@gmx.com> <20140330045030.GA22552@merlins.org>
In-Reply-To: <20140330045030.GA22552@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I probably should have used a better subject title. Also, I submitted this 
without knowing if it would be helpful or not. If it can be used in a good way 
Great! If not, then no problem. I appreciate you getting back with me, Marc. 
Thanks. :)


On 03/30/2014 12:50 AM, Marc MERLIN wrote:
> On Thu, Mar 20, 2014 at 11:21:27PM -0400, sepero111@gmx.com wrote:
>> Hello all. I submit bugs to different foss projects regularly, but I
>> don't really have a bug report this time. I have a broken filesystem
>> to report. And I have no idea how to reproduce it.
>>
>> I am including a link to the filesystem itself, because it appears
>> to be unrepairable and unrestorable. I have no personal information
>> on the disk image. The filesystem is almost 512MB uncompressed. I
>> was using it on an old usb drive with 512MB size limitation. I only
>> used (abused?) it about 2 days before this corruption.
>>
>> My goal was to use the usb as a bootable rescue system. I decided to
>> try Btrfs instead of Ext4, because it supports filesystem
>> compression.
>>
>> BTRFS IMAGE LINK (please pardon my file hosting service)
>> http://www.mediafire.com/download/gdaydt3mz8uwtmm/sdb1.btrfs.xz
>   
> It looks like you got no answer, and I'm not a dev so I can't help you
> either.
>
> The btrfs devs are pretty busy and can't always get back to everyone.
> Hopefully they'll be able to look at this, but sorry if not.
>
> Marc
>   
>> These are some things that may have helped to cause the corruption.
>>
>> +Created btrfs with -M flag
>> +Installed Debian testing/unstable
>> +When mounting, I always used at least these options:
>> ssd_spread,noatime,compression=zlib,autodefrag
>> +Occasionally force powering off computer.
>> +While booted into usb system, I was constantly running out of space
>> while trying to install new packages.
>>
>> It is my hope that this image might be used to improve the btrfs
>> restore and btrfsck tools. Please let me know if I can provide any
>> further information. Big thanks to everyone helping to further
>> development of Btrfs.
>>
>> Sepero
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

