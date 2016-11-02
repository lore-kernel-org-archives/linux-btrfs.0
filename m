Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:33888 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbcKBLZl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Nov 2016 07:25:41 -0400
Received: by mail-qk0-f180.google.com with SMTP id q130so13838986qke.1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Nov 2016 04:25:41 -0700 (PDT)
MIME-Version: 1.0
Reply-To: badara+ml@gmail.com
In-Reply-To: <7d615bfc-b7f0-dd01-6cff-61d0f978fc53@mendix.com>
References: <CAN5=xXnZmaqApRds3w=AKLAvfk=+dEPNazEb+Tzym_=2OdnfzA@mail.gmail.com>
 <7d615bfc-b7f0-dd01-6cff-61d0f978fc53@mendix.com>
From: Ahmed Badr <badara+ml@gmail.com>
Date: Wed, 2 Nov 2016 13:25:00 +0200
Message-ID: <CAN5=xXm+SEmXXer3a8PqHBASN4CJtsRFAMDDoq6ZMBXU0_VXPQ@mail.gmail.com>
Subject: Re: Snapper & apt-btrfs-snapshot on Ubuntu
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 2, 2016 at 2:19 AM, Hans van Kranenburg
<hans.van.kranenburg@mendix.com> wrote:
> While all of the snapshots with a matching parent_uuid are snapshots of
> the same thing in linear time for btrfs, the tools may have their own
> added administration on top (like snapshot names, or directories they're
> placed in), which prevents them from being able to do something with the
> other ones. This is not the fault of btrfs, it's because those tools
> probably are designed to ignore anything they didn't cause to happen
> themselves.

I understand now. Both apps seems to behave well and do not mess with
each others snapshots so I'm tempted to use both but I think I better
stick to only one as I might get confused with so many snapshots and
rollback to the wrong one.
