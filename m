Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37955 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbcBLDih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 22:38:37 -0500
Received: by mail-ig0-f180.google.com with SMTP id y8so2241494igp.1
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 19:38:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160212032226.GA10542@localhost.localdomain>
References: <CABXGCsOrgnvE=qbftu=7OuJenq7Vw6HzM9B86DLT4xJGLmqbMQ@mail.gmail.com>
	<CAJCQCtS3MsrF43PnueK3-4kVLGfTNGjN4Tv-c=Jo1jVWYL7ksw@mail.gmail.com>
	<CABXGCsOAyYa96E965ruKp9evCY3FrCdBr-GTPvCws5VqmjUC5Q@mail.gmail.com>
	<CAJCQCtRjCixev=Mt=jaL1ZytYaxj7Fa-AViLYGB-ALufyL98VA@mail.gmail.com>
	<CAJCQCtRtVjyjvSfT=BCZZwfaSvbD4YVxEBezfAx+-q7cwMHmRQ@mail.gmail.com>
	<CABXGCsNivrLgTEE+HZOLHXA-kpLVQOUv9L_nTw96nvy+DHodZg@mail.gmail.com>
	<CAJCQCtTrcnwvumgt-bOx+9wX+f50S9ja5rDrnYAsuuN1aDTsZA@mail.gmail.com>
	<20160211191741.GA4762@localhost.localdomain>
	<CABXGCsPN3MOLkU68gpw=TsnZLODEkYZ66ZHgUxMyeqbdNME9Sw@mail.gmail.com>
	<20160212032226.GA10542@localhost.localdomain>
Date: Thu, 11 Feb 2016 20:38:36 -0700
Message-ID: <CAJCQCtRw2hm=c+0Jm8s3yVNO8kWkt_R7_6+67_76brH02x4StQ@mail.gmail.com>
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
From: Chris Murphy <lists@colorremedies.com>
To: bo.li.liu@oracle.com
Cc: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 11, 2016 at 8:22 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Fri, Feb 12, 2016 at 02:03:15AM +0500, Михаил Гаврилов wrote:
>> Thanks guys, I appreciate your's work.
>> In which kernel this patch would landed?
>
> You can try it on your 4.2.3 kernel or the latest 4.5, but I guess it
> doesn't not fix the real deadlock you're hitting...

I think the question is whether the patch is already in a stable
kernel, or mainline, or not yet merged?


-- 
Chris Murphy
