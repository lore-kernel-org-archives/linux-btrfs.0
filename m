Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gitanes.rtfm.co.hu ([80.249.171.82]:48904 "EHLO
	gitanes.rtfm.co.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaFPOCt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 10:02:49 -0400
Received: from [10.32.0.10] (atom.chemaxon.com [91.120.7.54])
	(using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: tamas.papp@rtfm.co.hu)
	by gitanes.rtfm.co.hu (Postfix) with ESMTPSA id 3A8BC1042BF
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 16:02:47 +0200 (CEST)
Message-ID: <539EF907.6010102@martos.bme.hu>
Date: Mon, 16 Jun 2014 16:02:47 +0200
From: Tamas Papp <tompos@martos.bme.hu>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: open_ctree failed
References: <539EF06A.4080803@martos.bme.hu>
In-Reply-To: <539EF06A.4080803@martos.bme.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 06/16/2014 03:26 PM, Tamas Papp wrote:
> hi All,
>
> There is a Dell XPS 13 laptop with and SSD.
>
> System:
>
> Ubuntu 14.04 amd64
> Kernel is from the daily ppa, like 3.15rcX.
>
> Now, it's running live system:
>
> Linux ubuntu 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:11:08 UTC 
> 2014 x86_64 x86_64 x86_64 GNU/Linux
>
>
> Linux ubuntu 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:11:08 UTC 
> 2014 x86_64 x86_64 x86_64 GNU/Linux
> Label: none  uuid: 7cf95491-8ec6-48a2-b4c4-4b80650d169a
>     Total devices 1 FS bytes used 121.91GiB
>     devid    1 size 236.53GiB used 146.02GiB path /dev/sda4
>
> Btrfs v3.14.1
>
>
>
> I've attached all debug output, that I was able to get.
> btrfs check exited with segfault.
>
>
> Can you help me with this?
>

I just fixed the subject.

tamas
