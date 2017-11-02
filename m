Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:47318 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934159AbdKBCph (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 22:45:37 -0400
Received: by mail-wm0-f50.google.com with SMTP id r196so8040581wmf.2
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 19:45:37 -0700 (PDT)
MIME-Version: 1.0
From: Dave <davestechshop@gmail.com>
Date: Wed, 1 Nov 2017 22:45:15 -0400
Message-ID: <CAH=dxU4vj_+_K9dE3hqMf42oC9wEJKXTPRDr6QyOjrQfEXmXXA@mail.gmail.com>
Subject: =?UTF-8?Q?Parity=2Dbased_redundancy_=28RAID5=2F6=2Ftriple_parity_and_b?=
        =?UTF-8?Q?eyond=29_on_BTRFS_and_MDADM_=28Dec_2014=29_=E2=80=93_Ronny_Egners_Blog?=
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Has this been discussed here? Has anything changed since it was written?

Parity-based redundancy (RAID5/6/triple parity and beyond) on BTRFS
and MDADM (Dec 2014) – Ronny Egners Blog
http://blog.ronnyegner-consulting.de/2014/12/10/parity-based-redundancy-raid56triple-parity-and-beyond-on-btrfs-and-mdadm-dec-2014/comment-page-1/

TL;DR: There are patches to extend the linux kernel to support up to 6
parity disks but BTRFS does not want them because it does not fit
their “business case” and MDADM would want them but somebody needs to
develop patches for the MDADM component. The kernel raid
implementation is ready and usable. If someone volunteers to do this
kind of work I would support with equipment and myself as a test
resource.
