Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44496 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbcBLUf7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 15:35:59 -0500
Date: Fri, 12 Feb 2016 12:35:43 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: =?utf-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
Message-ID: <20160212203542.GB24399@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAJCQCtS3MsrF43PnueK3-4kVLGfTNGjN4Tv-c=Jo1jVWYL7ksw@mail.gmail.com>
 <CABXGCsOAyYa96E965ruKp9evCY3FrCdBr-GTPvCws5VqmjUC5Q@mail.gmail.com>
 <CAJCQCtRjCixev=Mt=jaL1ZytYaxj7Fa-AViLYGB-ALufyL98VA@mail.gmail.com>
 <CAJCQCtRtVjyjvSfT=BCZZwfaSvbD4YVxEBezfAx+-q7cwMHmRQ@mail.gmail.com>
 <CABXGCsNivrLgTEE+HZOLHXA-kpLVQOUv9L_nTw96nvy+DHodZg@mail.gmail.com>
 <CAJCQCtTrcnwvumgt-bOx+9wX+f50S9ja5rDrnYAsuuN1aDTsZA@mail.gmail.com>
 <20160211191741.GA4762@localhost.localdomain>
 <CABXGCsPN3MOLkU68gpw=TsnZLODEkYZ66ZHgUxMyeqbdNME9Sw@mail.gmail.com>
 <20160212032226.GA10542@localhost.localdomain>
 <CAJCQCtRw2hm=c+0Jm8s3yVNO8kWkt_R7_6+67_76brH02x4StQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtRw2hm=c+0Jm8s3yVNO8kWkt_R7_6+67_76brH02x4StQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 11, 2016 at 08:38:36PM -0700, Chris Murphy wrote:
> On Thu, Feb 11, 2016 at 8:22 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > On Fri, Feb 12, 2016 at 02:03:15AM +0500, Михаил Гаврилов wrote:
> >> Thanks guys, I appreciate your's work.
> >> In which kernel this patch would landed?
> >
> > You can try it on your 4.2.3 kernel or the latest 4.5, but I guess it
> > doesn't not fix the real deadlock you're hitting...
> 
> I think the question is whether the patch is already in a stable
> kernel, or mainline, or not yet merged?

Oh, it's not merged, just a quick patch to see if it can fix the deadlock.

Thanks,

-liubo
