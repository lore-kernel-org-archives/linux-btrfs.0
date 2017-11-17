Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:45491 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755116AbdKQBzj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 20:55:39 -0500
Received: by mail-oi0-f43.google.com with SMTP id v123so681948oif.12
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Nov 2017 17:55:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRKWA-tOaS5K-JOvxj4OYD==-Vrap4MbHZTfwYxc_FEKQ@mail.gmail.com>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com> <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com> <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
 <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com> <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
 <189cda7b-e3ee-4379-c7f2-57efd759b78a@gmx.com> <CAJCQCtRUGEdu13RCKFb6uZQ3UCzoAByhu97FdwQoFPxvsOua0Q@mail.gmail.com>
 <4baeb223-85d3-4c0c-e6d3-d0b495c2d950@gmx.com> <CAJCQCtRKWA-tOaS5K-JOvxj4OYD==-Vrap4MbHZTfwYxc_FEKQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 16 Nov 2017 18:55:37 -0700
Message-ID: <CAJCQCtTawScbtgWyrEWJ+crYdEkD78i9BPwRhs287iDOUHhSfg@mail.gmail.com>
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Zdenek Kabelac <zkabelac@redhat.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 16, 2017 at 6:54 PM, Chris Murphy <lists@colorremedies.com> wrote:

> The user doesn't have to setup dm-verity to get this.

Or dm-integrity, rather.

-- 
Chris Murphy
