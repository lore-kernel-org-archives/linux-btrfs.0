Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37038 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbcCPU6B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 16:58:01 -0400
Received: by mail-ig0-f169.google.com with SMTP id mh10so54506911igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Mar 2016 13:58:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56E94934.4030306@gmail.com>
References: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
	<72cb240a-fdb2-c38b-adb1-2b72847ab29a@mokrynskyi.com>
	<CAPmG0jZvioaxdr4FNHRQJTDZwuxq5EwUTay+VB=c+hKAzdDGYg@mail.gmail.com>
	<ce805cd7-422c-ab6a-fbf8-18a304aa640d@mokrynskyi.com>
	<CAPmG0jbRmWeHvL4cUzhPBAfA=_Ue03uC-pLE4O-u5bzFF_kzEQ@mail.gmail.com>
	<5240211f-27b7-2c87-41e7-c10953374921@mokrynskyi.com>
	<CAPmG0jZwapQ1=V-dHMEEwMYQUjb4+1M102eo96XQeJQV1JoxeQ@mail.gmail.com>
	<1557fe0b-bbcc-c125-5220-46a56e936590@mokrynskyi.com>
	<CAJCQCtTNO_BydLdKcZh_Ebv5ie2=mRfkosUTHH+ZSu003zwq+A@mail.gmail.com>
	<d50653c9-fe10-b97f-279b-d3e24625f064@mokrynskyi.com>
	<CAJCQCtRuLPBH5ELvVS5aP+gww5ZXrWN-inj_dgV4se+Jr4NJCg@mail.gmail.com>
	<56E94934.4030306@gmail.com>
Date: Wed, 16 Mar 2016 14:58:00 -0600
Message-ID: <CAJCQCtREYsBMQ8GP7nCqGBrCBw_R2Qie5KEuZtx9OTr_qc-NWQ@mail.gmail.com>
Subject: Re: Major HDD performance degradation on btrfs receive
From: Chris Murphy <lists@colorremedies.com>
To: Austin Hemmelgarn <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 16, 2016 at 5:53 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-03-16 02:51, Chris Murphy wrote:
>>
>> On Tue, Mar 15, 2016 at 10:23 PM, Nazar Mokrynskyi <nazar@mokrynskyi.com>
>> wrote:
>>>
>>> Sounds like a really good idea!
>>>
>>> I'll try to implement in in my backup tool, but it might take some time
>>> to
>>> see real benefit from it (or no benefit:)).
>>
>>
>> There is a catch. I'm not sure how much testing deleting 100
>> subvolumes at once gets. It should work. I haven't looked in xfstests
>> to see how much of this is being tested. So it's possible you're
>> testing it. So be ready.
>
> I've actually tested bulk removal of large numbers of snapshots multiple
> times before (it's actually one of the things that isn't in xfstests that I
> check when testing patches, I usually test power of two groups from 16 up to
> 256 at a time).  It works, but it may tie up most of the disk bandwidth for
> a while depending on what type of storage you're using.

Good to know.

-- 
Chris Murphy
