Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:34885 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbcAABpg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 20:45:36 -0500
Received: by mail-ig0-f170.google.com with SMTP id to4so203026027igc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 17:45:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ5Df8p4gJwBDLAF0HgKg9HNiNVbphn9=ao3To8CvkRkQ@mail.gmail.com>
References: <CAJCQCtQxFm5L-RtP9Ph8qaYtG0jVo3PfrHj6U35LJSStB5pyuQ@mail.gmail.com>
	<CAN05THS2=MFKwETJMPDz_FntDVFwfgbaY4Aros9=B4rhOF91qQ@mail.gmail.com>
	<CAN05THSvLdPvt9LmM4TLG-JWBQdRKNtEjrAkTX9jjL6r8kG8pA@mail.gmail.com>
	<CAJCQCtQ5Df8p4gJwBDLAF0HgKg9HNiNVbphn9=ao3To8CvkRkQ@mail.gmail.com>
Date: Thu, 31 Dec 2015 17:45:35 -0800
Message-ID: <CAN05THQj3W5tti5r4Ea2Oe2=V43hWt4F3EjaK3j3g6CFGjuc4w@mail.gmail.com>
Subject: Re: btrfs fail behavior when a device vanishes
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 31, 2015 at 5:27 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Dec 31, 2015 at 6:09 PM, ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
>> Here is a kludge I hacked up.
>> Someone that cares could clean this up and start building a proper
>> test suite or something.
>>
>> This test script creates a 3 disk raid1 filesystem and very slowly
>> writes a large file onto the filesystem while, one by one each disk is
>> disconnected then reconnected in a loop.
>> It is fairly trivial to trigger dataloss when devices are bounced like this.
>
> Yes, it's quite a torture test. I'd expect this would be a problem for
> Btrfs until this feature is done at least:
>
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Take_device_with_heavy_IO_errors_offline_or_mark_as_.22unreliable.22
>
> And maybe this one too
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#False_alarm_on_bad_disk_-_rebuild_mitigation
>
> Already we know that Btrfs tries to write indefinitely to missing
> devices. If it reappears, what gets written? Will that device be
> consistent? And then another one goes missing, comes back, now
> possibly two devices with totally different states for identical
> generations. It's a mess. We know that trivially causes major
> corruption with btrfs raid1 if a user mounts e.g. devid1 rw,degraded
> modifies that; then mounts devid2 (only) rw,degraded and modifies it;
> and then mounts both devids together. Kablewy. Big mess. And that's
> umounting each one in between those steps; not even the abrupt
> disconnect/reconnect.

Based on my test_0100... create a test script for that scenario too.
Even if btrfs can not handle it yet,  it does not hurt to have these
tests for scenarios that MUST work before the filesystem go officially
"stable+production".
Having these tests will possibly even make the work to close the
robustness gap easier since the devs will have reproducible test
scripts they can validate new features against.
