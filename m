Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gitanes.rtfm.co.hu ([80.249.171.82]:48789 "EHLO
	gitanes.rtfm.co.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaFVRKk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 13:10:40 -0400
Message-ID: <53A70E0C.6000602@martos.bme.hu>
Date: Sun, 22 Jun 2014 19:10:36 +0200
From: Tamas Papp <tompos@martos.bme.hu>
MIME-Version: 1.0
To: george@chinilu.comHe, linux-btrfs@vger.kernel.org
Subject: Re: open_ctree failed
References: <539EF06A.4080803@martos.bme.hu> <539EF907.6010102@martos.bme.hu> <53A35B2D.4000606@martos.bme.hu> <53A37A9B.7020301@chinilu.com>
In-Reply-To: <53A37A9B.7020301@chinilu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 06/20/2014 02:04 AM, George Mitchell wrote:
> Hello Tamas,
>
> I think it would help to provide more information than what you have 
> posted.  "open_ctree" can cover a lot of territory.
>
> 1)  I may be missing something, but I see no attachment.  I am not 
> sure the mailing list can handle attachments?

Indeed, thanks!

chunk recover:
http://pastebin.com/raw.php?i=01ZdbCDq

debug tree:
http://pastebin.com/raw.php?i=LgKgEhiC

dmesg:
http://pastebin.com/raw.php?i=zZ5zVxue

dmidecode:
http://pastebin.com/raw.php?i=zZ5zVxue

find root:
http://pastebin.com/raw.php?i=zWdn56tR

show super:
http://pastebin.com/raw.php?i=unqZECJ3

super recover:
http://pastebin.com/raw.php?i=y7fKtn3M

> 2) I think it would help to include some sort of brief narrative as to 
> what you are trying to do when you encounter the open_ctree failure.

I'm just trying to mount the partition:

mount -t btrfs /dev/sda4 /1


Thanks,
tamas
