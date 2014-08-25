Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48335 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752188AbaHYBGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 21:06:08 -0400
Message-ID: <53FA8BFB.1000604@cn.fujitsu.com>
Date: Mon, 25 Aug 2014 09:06:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Distro vs latest kernel for BTRFS?
References: <CAH-HCWVMO+NO0B5i0o0gCHBy9dLjc08gcqxT7oEV5WkO2BHvMA@mail.gmail.com>
In-Reply-To: <CAH-HCWVMO+NO0B5i0o0gCHBy9dLjc08gcqxT7oEV5WkO2BHvMA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Personally, if doing development, compiling from latest stable or 
integration kernel is my choice.

But if not developing the codes, I prefer Arch's core repo, which is 
about 1~2 weeks late than the stable release.
Although somewhat late, but still much newer than most distros' stable repo.
(I also used to use Gentoo, but even with ccache, compiling everything 
is somewhat time killing and overkilled for me)

Thanks,
Qu
-------- Original Message --------
Subject: Distro vs latest kernel for BTRFS?
From: Shriramana Sharma <samjnaa@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: 2014年08月22日 19:59
> Hello. I've seen repeated advices to use the latest kernel. While
> hearing of the recent compression bug affecting recent kernels does
> somewhat warn one off the previous advice, I would like to know what
> people who are running regular distros do to get the latest kernel.
>
> Personally I'm on Kubuntu, which provides mainline kernels till a
> particular point but not beyond that.
>
> Do people here always compile the latest kernel themselves just to get
> the latest BTRFS stability fixes (and  improvements, though as a
> second priority)?
>

