Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54333 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752291AbaFFBMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 21:12:37 -0400
Message-ID: <539115C1.5020507@cn.fujitsu.com>
Date: Fri, 6 Jun 2014 09:13:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: "Fajar A. Nugraha" <list@fajar.net>, Tomasz Chmielewski <tch@virtall.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: latest btrfs-progs and asciidoc dependency
References: <0f2f49c05a626f2f2e635a6db818e302@admin.virtall.com>	<20140605144146.GC14713@merlins.org> <CAG1y0sf8nGuhww7h4P+yGxOBVOV9aQRmLrUV3ZzZ2__5d3UYmw@mail.gmail.com>
In-Reply-To: <CAG1y0sf8nGuhww7h4P+yGxOBVOV9aQRmLrUV3ZzZ2__5d3UYmw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: latest btrfs-progs and asciidoc dependency
From: Fajar A. Nugraha <list@fajar.net>
To: Tomasz Chmielewski <tch@virtall.com>
Date: 2014年06月05日 22:51
> On Thu, Jun 5, 2014 at 9:41 PM, Marc MERLIN <marc@merlins.org> wrote:
>> On Thu, Jun 05, 2014 at 12:52:04PM +0100, Tomasz Chmielewski wrote:
>>> And it looks the dependency is ~1 GB of new packages? O_o
>> That seems painful, but at the same time, the alternative, nroff/troff sucks.
>>
>> Part ofyour problem however seems to be runaway dependencies.
>> You are getting x11 and stuff like libdrm which clearly you shouldn't need.
>> If your disk space is more valuable than your time, I recommend you build
>> asciidoc yourself and you should hopefully end up with less.
>>
>> Or you can also remove asciidoc from the makefile and read the raw files
>> which are readable.
>
> ... or try this
>
> # apt-get install --no-install-recommends asciidoc
>
> If that still doesn't work, AND you have lost of free time, AND
> familiar with debian packaging, then you can use latest available
> debian source, adapt it for latest version, and use opensuse build
> service to compile it.
>
It seems to be distribution related problems. And I use debian seldom, 
so I can't provide any help
but such problem doesn't occur to me.

For my daily use distribution(Archlinux), asciidoc has python2,libxslt 
and docbook-xsl as dependency.
For my test environment distribution(RHEL7), I install xmlto by yum and 
then I compile asciidoc manually.

Maybe dig more about the deb package things may help?
-If it does not help, a VM installed with Archlinux would be better?-

Thanks,
Qu
