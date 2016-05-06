Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34449 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbcEFLTz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 May 2016 07:19:55 -0400
Received: by mail-io0-f174.google.com with SMTP id 190so111323067iow.1
        for <linux-btrfs@vger.kernel.org>; Fri, 06 May 2016 04:19:55 -0700 (PDT)
Subject: Re: Spare volumes and hot auto-replacement feature
To: dsterba@suse.cz, Dmitry Katsubo <dma_k@mail.ru>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <572A8337.1030505@mail.ru>
 <008f1f81-df20-796f-a609-78075ddd9837@gmail.com>
 <20160506090822.GB29353@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <97c465c2-b2de-eb70-708b-6aa88569e156@gmail.com>
Date: Fri, 6 May 2016 07:19:44 -0400
MIME-Version: 1.0
In-Reply-To: <20160506090822.GB29353@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-06 05:08, David Sterba wrote:
> On Thu, May 05, 2016 at 07:23:11AM -0400, Austin S. Hemmelgarn wrote:
>> On 2016-05-04 19:18, Dmitry Katsubo wrote:
>>> Dear btrfs community,
>>>
>>> I am interested in spare volumes and hot auto-replacement feature [1]. I have a couple of questions:
>>>
>>> * Which kernel version this feature will be included?
>> Probably 4.7.  I would not suggest using it in production for at least a
>> few cycles though (probably 4.9).
>
> I wonder what are the grounds of the prediction, 4.7 is pretty much done
> regarding new features. And given the number of other features that are
> considered for merge I don't know an ETA. I haven't looked at the
> patches yet (but don't know about others).
>
I was under the impression that you had pulled them into your for-next 
branch, and forgot that that would mean probably mean 4.8 at the 
earliest, although looking at your tree now, I notice that the only 
patch from the series there is the first one which fixes a lockdep 
warning, and looking again at the ML is the only one you said you added.

So, taken altogether, the prediction was largely predicated on me being 
significantly absent-minded.
