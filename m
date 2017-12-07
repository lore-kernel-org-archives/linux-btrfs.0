Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f180.google.com ([74.125.82.180]:39623 "EHLO
        mail-ot0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbdLGBxh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Dec 2017 20:53:37 -0500
Received: by mail-ot0-f180.google.com with SMTP id v21so5124156oth.6
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Dec 2017 17:53:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR37A4GEC3UZs=W0AMiB+XR67BnoN9VZZrX4GPNOVdntQ@mail.gmail.com>
References: <1511364964.1675.57.camel@gmail.com> <CAJCQCtR37A4GEC3UZs=W0AMiB+XR67BnoN9VZZrX4GPNOVdntQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 6 Dec 2017 18:53:36 -0700
Message-ID: <CAJCQCtQxehp-qdSEgdSVfNPo290XEJ4gn741Aw+eYLwdLD9-eg@mail.gmail.com>
Subject: Re: mail notifications to root once quota limit reached
To: Chris Murphy <lists@colorremedies.com>
Cc: ST <smntov@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 22, 2017 at 9:39 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Wed, Nov 22, 2017 at 8:36 AM, ST <smntov@gmail.com> wrote:
>> Hello,
>>
>> is it possible to get mail notifications to root once quota limit is
>> reached? If not should I file a feature request?
>
> You should look at Nagios or OpenNMS, etc. That's where such
> functionality belongs.

I ran across this:

http://docs.gluster.org/en/latest/Administrator%20Guide/Gluster%20On%20ZFS/

It would need modification to do what you want with Btrfs, but maybe
it's a start.

-- 
Chris Murphy
