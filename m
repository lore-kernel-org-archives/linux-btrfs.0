Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48422 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753681AbaLWMel (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 07:34:41 -0500
Message-ID: <549960B9.20300@cn.fujitsu.com>
Date: Tue, 23 Dec 2014 20:31:53 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, Grzegorz Kowal <custos.mentis@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Standards Problems [Was: [PATCH v2 1/3] Btrfs: get more accurate
 output in df command.]
References: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com>	<548B4117.1040007@inwind.it>	<CA+qeAOokzptsxMKJaQwtVSFe5UxYuZnx5E22iMjRqM4AsuN8bA@mail.gmail.com>	<CABmMA7tw9BDsBXGHLO4vjcO4gaYmZPb_BQV8w22griqFvCJpPA@mail.gmail.com> <CABmMA7vtHzUYAhnEfpnx3Fx93SJyx=Qqoaz-PyQcivo=51jKsA@mail.gmail.com> <548E377D.6030804@cn.fujitsu.com> <548E7A7A.90505@pobox.com> <548E929B.2090203@pobox.com> <548E9B38.9080202@cn.fujitsu.com> <548EABBB.4060204@pobox.com> <548FA762.2070504@pobox.com> <549017E8.7060107@cn.fujitsu.com> <54908D8A.8040101@pobox.com> <54916B39.5080409@cn.fujitsu.com> <549252FF.10400@pobox.com>
In-Reply-To: <549252FF.10400@pobox.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/18/2014 12:07 PM, Robert White wrote:
> I don't disagree with the _ideal_ of your patch. I just think that 
> it's impossible to implement it without lying to the user or making 
> things just as bad in a different way. I would _like_ you to be right. 
> But my thing is finding and quantifying failure cases and the entire 
> question is full of fail.
>
...
>
> See you keep giving me these examples where the history of the 
> filesystem is uniform. It was made a certain way and stayed that way. 
> But in real life this sort of thing is going to happen and your patch 
> simply report's a _different_ _wrong_ number. A _friendlier_ wrong 
> number, I'll grant you that, but still wrong.
>

Hi Robert, sorry for the late. (It's busy to deal with some other work.)

Yes, you are providing some examples here to show that in some cases the
numbers from df is not helpful to understand the real space state in 
disk. But
I'm afraid we can not blame df reporting a wrong number. You could say
"Hey df, you are stupid, we can store the small file in metadata to exceed
your @size.". But he just reports the information from what he is seeing 
from FS level honestly.
He is reporting what he can see, and do not care about the other things 
out of
his business.

The all special cases you provided in this thread, actually lead to one 
result that
"Btrfs is special, df command will report an improper in some case.". It 
means
we need some other methods to tell user about the space info. And yes, 
we had. It's
btrfs fi df.

You are trying to make df showing information as more as possible, even 
change
the behaviour of df in btrfs to show the numbers of different meaning 
with what it
is in other filesystems. And my answer is keeping df command doing what 
he want,
and solve the problems in our private "df" , btrfs fi df.

Thanx
Yang
> . xaE
>

