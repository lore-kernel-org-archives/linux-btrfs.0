Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47660 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752167AbaFXQhZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 12:37:25 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: open_ctree failed
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53A92E2F.7090401@martos.bme.hu>
Date: Tue, 24 Jun 2014 10:37:22 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <ABC6B241-0575-42D7-937D-BC472FD8BCA8@colorremedies.com>
References: <539EF06A.4080803@martos.bme.hu> <539EF907.6010102@martos.bme.hu> <53A35B2D.4000606@martos.bme.hu> <53A37A9B.7020301@chinilu.com> <53A70E0C.6000602@martos.bme.hu> <53A92E2F.7090401@martos.bme.hu>
To: Tamas Papp <tompos@martos.bme.hu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 24, 2014, at 1:52 AM, Tamas Papp <tompos@martos.bme.hu> wrote:

> 
> On 06/22/2014 07:10 PM, Tamas Papp wrote:
>> 
>> On 06/20/2014 02:04 AM, George Mitchell wrote:
>>> Hello Tamas,
>>> 
>>> I think it would help to provide more information than what you have posted.  "open_ctree" can cover a lot of territory.
>>> 
>>> 1)  I may be missing something, but I see no attachment.  I am not sure the mailing list can handle attachments?
>> 
>> Indeed, thanks!
>> 
>> chunk recover:
>> http://pastebin.com/raw.php?i=01ZdbCDq
>> 
>> debug tree:
>> http://pastebin.com/raw.php?i=LgKgEhiC
>> 
>> dmesg:
>> http://pastebin.com/raw.php?i=zZ5zVxue
>> 
>> dmidecode:
>> http://pastebin.com/raw.php?i=zZ5zVxue
>> 
>> find root:
>> http://pastebin.com/raw.php?i=zWdn56tR
>> 
>> show super:
>> http://pastebin.com/raw.php?i=unqZECJ3
>> 
>> super recover:
>> http://pastebin.com/raw.php?i=y7fKtn3M
>> 
>>> 2) I think it would help to include some sort of brief narrative as to what you are trying to do when you encounter the open_ctree failure.
>> 
>> I'm just trying to mount the partition:
>> 
>> mount -t btrfs /dev/sda4 /1
>> 
> 
> dmesg after -o recovery:
> 
> http://pastebin.com/raw.php?i=VAG9msx2

super-recover says supers are good, btrfs-find-tree finds tree root, but chunk-recover fails.

Please post the result from smartctl -x <dev>

I'd make sure you're on kernel 3.14 at the oldest, and same for btrfs-progs. Currently you're on v.3.12. And then also post the result of btrfs check (without --repair).


Chris Murphy



