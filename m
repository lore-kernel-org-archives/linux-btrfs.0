Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514Ab3CGPNd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Mar 2013 10:13:33 -0500
Message-ID: <5138AE96.3020304@redhat.com>
Date: Thu, 07 Mar 2013 09:13:26 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
CC: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>, Anand.Jain@oracle.com
Subject: Re: mkfs.btrfs broken
References: <513883DD.8080203@petaramesh.org> <5138980C.8080000@redhat.com> <5138ADA6.5070101@petaramesh.org>
In-Reply-To: <5138ADA6.5070101@petaramesh.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/7/13 9:09 AM, Swâmi Petaramesh wrote:
> Le 07/03/2013 14:37, Eric Sandeen a écrit :
>> What error messages does it emit, anything helpful? 
> 
> root@partedmagic:~# file -s /dev/sda5
> /dev/sda5: data
> 
> root@partedmagic:~# mkfs.btrfs /dev/sda5
> 
> WARNING! - Btrfs v0.20-rc1 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
> 
> error checking /dev/sda5 mount status

Ok, so that's unhelpful isn't it.  :)

> root@partedmagic:~# echo $?
> 1
> 
>> The option is quite new, and still exists upstream. But it only forces
>> overwrite of an existing filesystem, it has never affected the mount
>> status check AFAIK. 
> 
> I remember that, in the past, I was several time able to override this
> very error by using a -f switch...
> 

maybe it was some non-upstream hack I'm not aware of.

>> There are also steps you could take to investigate some more yourself:
>> Did earlier versions of the livecd work for you? If so, when did it break?
> 
> It was broke first time I tried to use it more than a year ago ; I don't
> clearly remember if it has been fixed at some point in time... I'm
> positively sure that I saw the exact same error on other live distros
> (possibly Ubuntu but not sure...)
> 
>> Can you capture an strace of the failing mkfs.btrfs? -Eric 
> I don't know how to do this, I'm no developper myself...

# strace -o tracefile.txt mkfs.btrfs /dev/sda5

tracefile.txt will contain all syscalls made by the binary and their results,
which might give us a clue what's gone wrong.

-Eric

> Kind regards.
> 

