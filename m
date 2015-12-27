Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 60-241-247-214.static.tpgi.com.au ([60.241.247.214]:40695 "EHLO
	ns1.allsupp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbbL0P2D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 10:28:03 -0500
Subject: Re: How to change BTRFS filesystem UUID
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <567FF63E.3010106@ganomi.com>
 <20151227144535.GJ1586@carfax.org.uk>
From: Jiri Kanicky <j@ganomi.com>
Message-ID: <5680034D.7030509@ganomi.com>
Date: Mon, 28 Dec 2015 02:27:09 +1100
MIME-Version: 1.0
In-Reply-To: <20151227144535.GJ1586@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Thanks for the reply. Looks like I will have o use some newer distro. 
Debian Jessie rescue CD does not seem to have this. Anyway, i will play 
with this.

Thank you Jiri

On 28/12/2015 1:45 AM, Hugo Mills wrote:
> On Mon, Dec 28, 2015 at 01:31:26AM +1100, Jiri Kanicky wrote:
>> Hi,
>>
>> I cloned several machines from the same disk and they all have same
>> BTRFS filesystem UUID. I need to recovery one disk from failure, but
>> if I attach two disks to the same machine, both disks have the same
>> ID.
>>
>> This seem to confuse UDEV, because /dev/disk/by-uuid seem to show
>> just one link, not two links to two disks.
>>
>> Is there a way to change the BTRFS ID (generate new one) that I can
>> differentiate between the two disks on one host?
>     btrfstune, with -u or -U
>
>     Hugo.
>

