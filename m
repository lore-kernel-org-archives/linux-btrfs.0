Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26251 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754746AbcGHN6T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 09:58:19 -0400
Subject: Re: errors with linux-next-20160701
To: <dsterba@suse.cz>, Laszlo Fiat <laszlo.fiat@gmail.com>,
        <linux-btrfs@vger.kernel.org>
References: <CA+7w51htypyk_RAUmf0i_12JSawq0BvKckSUk=sqyLHVkwvJNA@mail.gmail.com>
 <20160708135108.GH13336@twin.jikos.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <cff292c2-2969-df61-24c3-c6fdca202f05@fb.com>
Date: Fri, 8 Jul 2016 09:57:55 -0400
MIME-Version: 1.0
In-Reply-To: <20160708135108.GH13336@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/08/2016 09:51 AM, David Sterba wrote:
> On Thu, Jul 07, 2016 at 08:15:18PM +0200, Laszlo Fiat wrote:
>> I have a simple btrfs filesystem on a single device. It worked well so far.
>>
>> Recently I compiled a new kernel linux-next-20160701, with this new
>> kernel I get warnings and errors in the logs.
>
> I hope you're aware that using linux-next can lead to all sorts of
> problems.
>

This should be easy to verify by pulling Dave's for-next branch on top 
of Linus' current git.  Either the bugs will disappear or not.

-chris
