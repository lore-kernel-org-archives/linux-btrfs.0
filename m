Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49696 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab2ISHgD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 03:36:03 -0400
Received: by oago6 with SMTP id o6so756785oag.19
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 00:36:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20120919T083653-817@post.gmane.org>
References: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com>
	<5058068C.4040704@oracle.com>
	<loom.20120919T083653-817@post.gmane.org>
Date: Wed, 19 Sep 2012 14:36:02 +0700
Message-ID: <CAG1y0sfmGczX1u+JApcB3Dz_gd9g=mT6JGDKkqJR5fRfSViOTg@mail.gmail.com>
Subject: Re: Experiences: Why BTRFS had to yield for ZFS
From: "Fajar A. Nugraha" <list@fajar.net>
To: Casper Bang <casper.bang@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2012 at 2:28 PM, Casper Bang <casper.bang@gmail.com> wrote:
>> Anand Jain <Anand.Jain <at> oracle.com> writes:
>>   archive-log-apply script - if you could, can you share the
>>   script itself ? or provide more details about the script.
>>   (It will help to understand the work-load in question).
>
> Our setup entails a whole bunch of scripts, but the apply script looks like this
> (orion is the production environment, pandium is the shadow):
> http://pastebin.com/k4T7deap
>
> The script invokes rman passing rman_recover_database.rcs:

IIRC there were some patches post-3.0 which relates to sync. If oracle
db uses sync writes (or call sync somewhere, which it should), it
might help to re-run the test with more recent kernel. kernel-ml
repository might help.

> Ext4 starts out with a realtime to SCN ratio of about 3.4 and ends down around a
> factor 2.2.
>
> ZFS starts out with a realtime to SCN ratio of about 7.5 and ends down around a
> factor 4.4.

So zfsonlinux is actually faster than ext4 for that purpuse? coool !

>
> Btrfs starts out with a realtime to SCN ratio of about 2.2 and ends down around
> a factor 0.8. This of course means we will never be able to catch up with
> production, as btrfs can't apply these as fast as they're created.
>
> It was even worse with btrfs on our 10xSSD server, where 20 min. of realtime
> work would end up taking some 5h to get applied (factor 0.06), obviously useless
> to us.

Just wondering, did you use "discard" option by any chance? In my
experience it makes btrfs MUCH slower.

-- 
Fajar
