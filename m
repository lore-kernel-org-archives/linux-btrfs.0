Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:50710 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754519AbdKAS2Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 14:28:16 -0400
Received: by mail-io0-f179.google.com with SMTP id 97so8094194iok.7
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 11:28:16 -0700 (PDT)
Subject: Re: Several questions regarding btrfs
To: Andrei Borzenkov <arvidjaar@gmail.com>, ST <smntov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <1509467017.1662.37.camel@gmail.com>
 <edd9dfa6-a73d-54d6-d9d6-48bd5fd7f724@gmail.com>
 <1509480384.1662.84.camel@gmail.com>
 <ea097624-d485-9423-387f-3c9427508883@gmail.com>
 <deeb56f6-1245-abfd-bfdb-ab399bc857b8@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <708f17c4-c6e6-78f1-06f4-e3bda6ea208c@gmail.com>
Date: Wed, 1 Nov 2017 14:28:12 -0400
MIME-Version: 1.0
In-Reply-To: <deeb56f6-1245-abfd-bfdb-ab399bc857b8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-01 13:52, Andrei Borzenkov wrote:
> 01.11.2017 15:01, Austin S. Hemmelgarn пишет:
> ...
>> The default subvolume is what gets mounted if you don't specify a
>> subvolume to mount.  On a newly created filesystem, it's subvolume ID 5,
>> which is the top-level of the filesystem itself.  Debian does not
>> specify a subvo9lume in /etc/fstab during the installation, so setting
>> the default subvolume will control what gets mounted.  If you were to
>> add a 'subvolume=' or 'subvolid=' mount option to /etc/fstab for that
>> filesystem, that would override the default subvolume.
>>
>> The reason I say to set the default subvolume instead of editing
>> /etc/fstab is a pretty simple one though.  If you edit /etc/fstab and
>> don't set the default subvolume, you will need to mess around with the
>> bootloader configuration (and possibly rebuild the initramfs) to make
>> the system bootable again, whereas by setting the default subvolume, the
>> system will just boot as-is without needing any other configuration
>> changes.
> 
> That breaks as soon as you have nested subvolumes that are not
> explicitly mounted because they are lost in new snapshot.
> 
Unless they have been created manually, there won't be any such 
subvolumes on a Debian system.  Debian treats BTRFS no different from 
any other filesystem during the install, so you get no subvolumes 
whatsoever (in contrast to Fedora and SUSE treating BTRFS as a volume 
manager and not a filesystem, and thus having subvolumes all over the 
place in a default install).

Regardless of if you update /etc/fstab to point to the new subvolume or 
not, any old ones need to be either copied (the preferred method for 
stuff that isn't supposed to be equivalent to a separate filesystem), or 
have entries put in /etc/fstab.
