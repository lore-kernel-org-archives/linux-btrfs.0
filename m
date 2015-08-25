Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1207.opentransfer.com ([98.130.1.227]:50003 "EHLO
	mail1207.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbbHYPx6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 11:53:58 -0400
Message-ID: <55DC8F94.1020200@friendlyvirus.org>
Date: Tue, 25 Aug 2015 16:53:56 +0100
From: =?UTF-8?B?TWlndWVsIE5lZ3LDo28=?=
	<miguel.negrao-lists@friendlyvirus.org>
MIME-Version: 1.0
To: Matt Ruffalo <matt.ruffalo@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs tragedy: lack of space for metadata leads to loss of fs.
References: <loom.20150825T151154-787@post.gmane.org> <55DC8718.8060209@gmail.com>
In-Reply-To: <55DC8718.8060209@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25-08-2015 16:17, Matt Ruffalo wrote:
> On 2015-08-25 09:44, Miguel Negrão wrote:
>> Hi list,
>>
>> This weekend had my first btrfs horror story. 
>>
>> system: 3.13.0-49-lowlatency, btrfs-progs v4.1.2
>>
>> A disclaimer: I know 3.13 is very out of date, but I the requirement of
>> keeping kernel up to date clashes with my requirement of keeping a stable
>> system. At the moment I can't disturb my system as I'm doing important work,
>> upgrading kernel requires upgrading ubuntu, which will upgrade a lot of
>> packages and might lead to problems which I don't have time to fix. One
>> might argue that in the end I lost time anyway dealing with these btrfs
>> issues. When I'm done with this current work I will update the whole system
>> which will update the kernel in the process.
> 
> Hi-
> 
> I have no useful advice about filesystem recovery, but would like to
> point out that newer kernels are backported to Ubuntu LTS versions and
> can be installed without any significant disruption of the system.
> 
> The normal kernel backports are named 'linux-generic-lts-<version
> codename>', and the low latency versions are
> 'linux-lowlatency-lts-<version codename>', so you could install kernel
> 3.16 (from 14.10 "utopic") by installing linux-lowlatency-lts-utopic,
> and kernel 3.19 (from 15.04 "vivid") by installing
> linux-lowlatency-lts-vivid. Kernel 4.1 will be available as
> linux-{generic,lowlatency}-lts-wily a bit after 15.10 is released.

Oh, that's very good advice. Running 3.19 now, great thanks ! When 4.1
comes out will update.

Thanks !
Miguel
