Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gitanes.rtfm.co.hu ([80.249.171.82]:57095 "EHLO
	gitanes.rtfm.co.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaFXHwR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 03:52:17 -0400
Received: from [10.32.0.11] (atom.chemaxon.com [91.120.7.54])
	(using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: tamas.papp@rtfm.co.hu)
	by gitanes.rtfm.co.hu (Postfix) with ESMTPSA id 8E8FE112C19
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 09:52:15 +0200 (CEST)
Message-ID: <53A92E2F.7090401@martos.bme.hu>
Date: Tue, 24 Jun 2014 09:52:15 +0200
From: Tamas Papp <tompos@martos.bme.hu>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: open_ctree failed
References: <539EF06A.4080803@martos.bme.hu> <539EF907.6010102@martos.bme.hu> <53A35B2D.4000606@martos.bme.hu> <53A37A9B.7020301@chinilu.com> <53A70E0C.6000602@martos.bme.hu>
In-Reply-To: <53A70E0C.6000602@martos.bme.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 06/22/2014 07:10 PM, Tamas Papp wrote:
>
> On 06/20/2014 02:04 AM, George Mitchell wrote:
>> Hello Tamas,
>>
>> I think it would help to provide more information than what you have 
>> posted.  "open_ctree" can cover a lot of territory.
>>
>> 1)  I may be missing something, but I see no attachment.  I am not 
>> sure the mailing list can handle attachments?
>
> Indeed, thanks!
>
> chunk recover:
> http://pastebin.com/raw.php?i=01ZdbCDq
>
> debug tree:
> http://pastebin.com/raw.php?i=LgKgEhiC
>
> dmesg:
> http://pastebin.com/raw.php?i=zZ5zVxue
>
> dmidecode:
> http://pastebin.com/raw.php?i=zZ5zVxue
>
> find root:
> http://pastebin.com/raw.php?i=zWdn56tR
>
> show super:
> http://pastebin.com/raw.php?i=unqZECJ3
>
> super recover:
> http://pastebin.com/raw.php?i=y7fKtn3M
>
>> 2) I think it would help to include some sort of brief narrative as 
>> to what you are trying to do when you encounter the open_ctree failure.
>
> I'm just trying to mount the partition:
>
> mount -t btrfs /dev/sda4 /1
>

dmesg after -o recovery:

http://pastebin.com/raw.php?i=VAG9msx2



Thanks for the help!


tamas
