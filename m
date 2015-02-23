Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw8a-wendolyn.wadns.net ([41.185.62.100]:12021 "EHLO
	fw8a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751123AbbBWHAb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Feb 2015 02:00:31 -0500
Message-ID: <54EAD003.2040106@swiftspirit.co.za>
Date: Mon, 23 Feb 2015 09:00:19 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Dave Stevens <geek@uniserve.com>, linux-btrfs@vger.kernel.org
Subject: Re: OT raid-1 from raid-10?
References: <20150221170242.97157f5dfm60oib6@webmail.uniserve.com>
In-Reply-To: <20150221170242.97157f5dfm60oib6@webmail.uniserve.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015/02/22 03:02, Dave Stevens wrote:
> If there's a better list please say so.

Either way, there is definitely not enough information here for us to 
give any practical advice. This is a btrfs-related mailing list and 
there's no indication even that you are using btrfs as your filesystem.

Typically, "linux raid autodetect" refers to mdraid, which is not btrfs 
- and changing the partition's "type" won't change the underlying issue 
of the data being unavailable.

>
> I have a raid-10 array with two dirty drives and (according to the 
> kernel) not enough mirrors to repair the raid-10. But I think drives 
> sda and sdb are mirrored and maybe I could read the data off them if I 
> changed the fs type from linux raid autodetect to ext3. is that 
> reasonable?
>
> D
>

If at least 3 disks are still in good condition, there's a chance that 
you can recover all your data. If not, my advice is to restore from 
backup. If you don't have backups ... well ... we have a couple of 
sayings about that, mostly along the lines of: If you don't have backups 
of it, it wasn't that important to begin with.

Run the following commands (as root) and send us the output - then maybe 
someone will be kind enough to point you in the right direction:
uname -a
cat /etc/*release
btrfs --version
btrfs fi show
cat /proc/mdstat
fdisk -l
gdisk -l


-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

