Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gitanes.rtfm.co.hu ([80.249.171.82]:36410 "EHLO
	gitanes.rtfm.co.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147AbaFYNJ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 09:09:56 -0400
Message-ID: <53AACA21.5060504@martos.bme.hu>
Date: Wed, 25 Jun 2014 15:09:53 +0200
From: Tamas Papp <tompos@martos.bme.hu>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: open_ctree failed
References: <539EF06A.4080803@martos.bme.hu> <539EF907.6010102@martos.bme.hu> <53A35B2D.4000606@martos.bme.hu> <53A37A9B.7020301@chinilu.com> <53A70E0C.6000602@martos.bme.hu> <53A92E2F.7090401@martos.bme.hu> <ABC6B241-0575-42D7-937D-BC472FD8BCA8@colorremedies.com>
In-Reply-To: <ABC6B241-0575-42D7-937D-BC472FD8BCA8@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 06/24/2014 06:37 PM, Chris Murphy wrote:
> On Jun 24, 2014, at 1:52 AM, Tamas Papp <tompos@martos.bme.hu> wrote:
>
>> On 06/22/2014 07:10 PM, Tamas Papp wrote:
>>> On 06/20/2014 02:04 AM, George Mitchell wrote:
>>>> Hello Tamas,
>>>>
>>>> I think it would help to provide more information than what you have posted.  "open_ctree" can cover a lot of territory.
>>>>
>>>> 1)  I may be missing something, but I see no attachment.  I am not sure the mailing list can handle attachments?
>>> Indeed, thanks!
>>>
>>> chunk recover:
>>> http://pastebin.com/raw.php?i=01ZdbCDq
>>>
>>> debug tree:
>>> http://pastebin.com/raw.php?i=LgKgEhiC
>>>
>>> dmesg:
>>> http://pastebin.com/raw.php?i=zZ5zVxue
>>>
>>> dmidecode:
>>> http://pastebin.com/raw.php?i=zZ5zVxue
>>>
>>> find root:
>>> http://pastebin.com/raw.php?i=zWdn56tR
>>>
>>> show super:
>>> http://pastebin.com/raw.php?i=unqZECJ3
>>>
>>> super recover:
>>> http://pastebin.com/raw.php?i=y7fKtn3M
>>>
>>>> 2) I think it would help to include some sort of brief narrative as to what you are trying to do when you encounter the open_ctree failure.
>>> I'm just trying to mount the partition:
>>>
>>> mount -t btrfs /dev/sda4 /1
>>>
>> dmesg after -o recovery:
>>
>> http://pastebin.com/raw.php?i=VAG9msx2
> super-recover says supers are good, btrfs-find-tree finds tree root, but chunk-recover fails.
>
> Please post the result from smartctl -x <dev>
>
> I'd make sure you're on kernel 3.14 at the oldest, and same for btrfs-progs. Currently you're on v.3.12. And then also post the result of btrfs check (without --repair).

smartctl -x:

http://pastebin.com/raw.php?i=S3eaCb8b


The machine was running 3.15rcX, when it failed. Unfortunately I have 
only a live system now with this kernel versionI. I tried with the 
latest btrfs-progs from git with no success.

btrfs check (with v3.12):

Check tree block failed, want=325877760, have=0
Check tree block failed, want=325877760, have=0
Check tree block failed, want=325877760, have=0
read block failed check_tree_block
Couldn't setup extent tree
Critical roots corrupted, unable to fsck the FS
Checking filesystem on /dev/sda4
UUID: 7cf95491-8ec6-48a2-b4c4-4b80650d169a


tamas
