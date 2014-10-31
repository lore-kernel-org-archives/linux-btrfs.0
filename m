Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35236 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670AbaJaLFI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 07:05:08 -0400
Message-ID: <54536CDA.4090901@oracle.com>
Date: Fri, 31 Oct 2014 19:04:58 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2 v4] btrfs-progs: optimize btrfs_scan_lblkid() for
 multiple calls
References: <1413334270-25766-1-git-send-email-anand.jain@oracle.com> <1414728680-25468-1-git-send-email-anand.jain@oracle.com> <1414728680-25468-2-git-send-email-anand.jain@oracle.com> <20141031090830.GP10134@x2.net.home>
In-Reply-To: <20141031090830.GP10134@x2.net.home>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





On 31/10/2014 17:08, Karel Zak wrote:
> On Fri, Oct 31, 2014 at 12:11:20PM +0800, Anand Jain wrote:
>> btrfs_scan_lblikd() is called by most the device related command functions.
>> And btrfs_scan_lblkid() is most expensive function and it becomes more expensive
>> as number of devices in the system increase. Further some threads call this
>
> wouldn't be possible to ask udev rather than scan all devices? I
> understand than in some cases it's necessary to have robust and
> independent solution, but for usual use-cases it would be less
> expensive to read the info from udev where we already keep track about
> all block devices and where we call libblkid.
>
> It would be possible to implement it as optional feature (#ifdev HAVE_LIBUDEV),
> the library API is very easy to use.
>
> (For example lsblk uses libblkid as fallback, the default is udev).
>
>      Karel
>
>

I might be missing something, correct me if wrong. Is there any udev API 
which gives me a list of devices which hold btrfs ? I just browsed
through there isn't any.

Anand
