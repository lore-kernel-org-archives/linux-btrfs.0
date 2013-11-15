Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:52982 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab3KOQjp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 11:39:45 -0500
Received: by mail-ie0-f170.google.com with SMTP id to1so5107130ieb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 08:39:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131115152701.GR4315@carfax.org.uk>
References: <528630D6.5090103@elastichosts.com>
	<20131115152701.GR4315@carfax.org.uk>
Date: Fri, 15 Nov 2013 10:39:42 -0600
Message-ID: <CAE5mzvhba9s0zem3Ye4wuo0ja3FxqPFiVs7k2yJ9Q1ZJq0bzoQ@mail.gmail.com>
Subject: Re: Subvolume creation returns file exists
From: cwillu <cwillu@cwillu.com>
To: Hugo Mills <hugo@carfax.org.uk>, Alin Dobre <alin.dobre@elastichosts.com>,
        linux-btrfs@vger.kernel.org, cwillu@cwillu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 15, 2013 at 9:27 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Nov 15, 2013 at 02:33:58PM +0000, Alin Dobre wrote:
>> We are using btrfs filesystems in our infrastructure and, at some
>> point of time, they start refusing to create new subvolumes.
>>
>> Each file system is being quota initialized immediately after its
>> creation (with "btrfs quota enable") and then all subfolders under
>> the root directory are created as subvolumes (btrfs subvolume
>> create). Over time, these subvolumes may also be deleted. What's
>> under subvolumes are just various files and directories, should not
>> be related to this problem.
>>
>> After a while of using this setup, without any obvious steps to
>> reproduce it, the filesystem goes into a state where the following
>> happens:
>>     # btrfs subvolume create btrfs_mount/test_subvolume
>>     Create subvolume 'btrfs_mount/test_subvolume'
>>     ERROR: cannot create subvolume - File exists
>
>    We've had someone else with this kind of symptom (snapshot/subvol
> creation fails unexpectedly) on IRC recently. I don't think they've
> got to the bottom of it yet, but the investigation is ongoing. I've
> cc'd Carey in on this, because he was the one trying to debug it.
>
>    Hugo.
>
>> In regards to data, the filesystem is pretty empty, it only has a
>> single empty directory. I don't know about the metadata, at this
>> point.
>>
>> The problem goes away if we disable and re-enable the quota. It all
>> seems to be some dead metadata lying around.

And indeed, it turns out I did have quotas enabled, and disabling them
restores the ability to create subvolumes.
