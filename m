Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17024 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbaIJAmg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Sep 2014 20:42:36 -0400
Message-ID: <540F9E77.3080701@fb.com>
Date: Tue, 9 Sep 2014 20:42:31 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Morten Stevens <mstevens@fedoraproject.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs 3.16.2 system crash
References: <CAKSJeFLRK5PaZMd=KkkLNe_G_h86CYYNTrKVyt5eWzdKU+NbAw@mail.gmail.com> <540E3858.8060904@fb.com>
In-Reply-To: <540E3858.8060904@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/08/2014 07:14 PM, Chris Mason wrote:
> 
> 
> On 09/08/2014 06:51 PM, Morten Stevens wrote:
>> Hi,
>>
>> After some testing with the latest stable 3.16.2 kernel on my Fedora
>> 20 test-vm and a small filesystem
>> test with btrfs causes the system to crash.
>>
>> Kernel: 3.16.2
>> Mount options: rw,seclabel,relatime,compress=lzo,space_cache
>>
>> The test is really simple: only writing 16 GB files on the disk with dd
>> # dd if=/dev/zero of=ddfile bs=8k count=2000000
>>
>> You need to run it multiple times, after some time the host gets into
>> a non-responsive
>> state.
> 
> Hi Morten,
> 
> I haven't seen that one, and I ran an overnight stress before sending
> out the stable patches.   But, let me try here.

I ran the dd's overnight and some other tests without trouble.  But that
doesn't mean its not a btrfs bug, I'll try again tonight.

-chris

