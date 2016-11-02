Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:38312 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbcKBLpF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Nov 2016 07:45:05 -0400
Received: by mail-it0-f47.google.com with SMTP id q124so30735883itd.1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Nov 2016 04:45:04 -0700 (PDT)
Subject: Re: Snapper & apt-btrfs-snapshot on Ubuntu
To: badara+ml@gmail.com, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAN5=xXnZmaqApRds3w=AKLAvfk=+dEPNazEb+Tzym_=2OdnfzA@mail.gmail.com>
 <7d615bfc-b7f0-dd01-6cff-61d0f978fc53@mendix.com>
 <CAN5=xXm+SEmXXer3a8PqHBASN4CJtsRFAMDDoq6ZMBXU0_VXPQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <c422a16f-0f5b-b769-3c5a-a6afee64ff80@gmail.com>
Date: Wed, 2 Nov 2016 07:44:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAN5=xXm+SEmXXer3a8PqHBASN4CJtsRFAMDDoq6ZMBXU0_VXPQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-02 07:25, Ahmed Badr wrote:
> On Wed, Nov 2, 2016 at 2:19 AM, Hans van Kranenburg
> <hans.van.kranenburg@mendix.com> wrote:
>> While all of the snapshots with a matching parent_uuid are snapshots of
>> the same thing in linear time for btrfs, the tools may have their own
>> added administration on top (like snapshot names, or directories they're
>> placed in), which prevents them from being able to do something with the
>> other ones. This is not the fault of btrfs, it's because those tools
>> probably are designed to ignore anything they didn't cause to happen
>> themselves.
>
> I understand now. Both apps seems to behave well and do not mess with
> each others snapshots so I'm tempted to use both but I think I better
> stick to only one as I might get confused with so many snapshots and
> rollback to the wrong one.
What I would suggest doing in this case is to split out /home to a 
separate filesystem, use snapper for that, and use apt-btrfs-snapshot 
for everything else (except possibly stuff which gets served externally 
by the system, such as /var/www).  That way you get the benefits of 
snapper for the files where that type of snapshotting matters, and 
apt-btrfs-snapshot for where that actually matters, and you have no 
chance of them stepping on each others toes.

Also, make sure to check the settings for snapper, the defaults are 
pathologically bad for most end-users and will quite often put you in a 
bad situation eventually with the filesystem.  What actually works is up 
to your use case, but you almost certainly don't need snapshots more 
frequently than every few minutes.
