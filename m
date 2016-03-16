Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36267 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965719AbcCPGvC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 02:51:02 -0400
Received: by mail-ig0-f173.google.com with SMTP id nk17so85053896igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 23:51:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d50653c9-fe10-b97f-279b-d3e24625f064@mokrynskyi.com>
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
Date: Wed, 16 Mar 2016 00:51:00 -0600
Message-ID: <CAJCQCtRuLPBH5ELvVS5aP+gww5ZXrWN-inj_dgV4se+Jr4NJCg@mail.gmail.com>
Subject: Re: Major HDD performance degradation on btrfs receive
From: Chris Murphy <lists@colorremedies.com>
To: Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 15, 2016 at 10:23 PM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:
> Sounds like a really good idea!
>
> I'll try to implement in in my backup tool, but it might take some time to
> see real benefit from it (or no benefit:)).

There is a catch. I'm not sure how much testing deleting 100
subvolumes at once gets. It should work. I haven't looked in xfstests
to see how much of this is being tested. So it's possible you're
testing it. So be ready.

Also since it's batched, consider doing it at night when it's not
used. The cleaner task will always slow things down because it has to
decrement reference counts and then find out what to actually delete
and then update metadata to reflect it. You could also add in a 5
minute delay after subvolume deletes then issue sysrq+w in case
there's significant blocked tasks, the logs will have extra debug
info.

Another idea is maybe graphically modeling (seekwatcher) the normal
write pattern, and see how it changes when even a single subvolume is
deleted (the current every 15 minute method). That might give an idea
how significantly cleaner tasks affect your particular workload. The
results might support batching not only to avoid fragmentation by
getting larger contiguous free space, but to avoid the IOPS hit during
the day time from too aggressive (?) of a cleaner task.


-- 
Chris Murphy
