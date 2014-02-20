Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4705 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbaBTKww (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 05:52:52 -0500
Message-ID: <5305DE1E.8080302@cn.fujitsu.com>
Date: Thu, 20 Feb 2014 18:51:10 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Meaning of "no_csum" field when scrubbing with -R option
References: <5304AA69.5020800@informatik.uni-bonn.de> <pan$165e8$a9517bbb$99fb7bd6$7e251ef6@cox.net>
In-Reply-To: <pan$165e8$a9517bbb$99fb7bd6$7e251ef6@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/20/2014 06:31 PM, Duncan wrote:
> Sebastian Ochmann posted on Wed, 19 Feb 2014 13:58:17 +0100 as excerpted:
>
>> So my question is, why does scrub show a high (i.e. non-zero) value for
>> no_csum? I never enabled nodatasum or a similar option.
Did you enable nodatacow option? if  nodatacow option is enabled,
data checksums will be also disabled at the same time.

Thanks,
Wang
> I've no answer but have wondered that myself.  So hopefully you get an
> answer I can read too. =:^)
>

